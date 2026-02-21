/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import hollybike.api.exceptions.BadRequestException
import hollybike.api.json
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.journey.*
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.*
import hollybike.api.utils.AccelPreprocess
import hollybike.api.utils.EkfJourney
import hollybike.api.utils.PositionSample
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.dao.load
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.jdbc.deleteWhere
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import kotlin.math.abs
import kotlin.math.hypot
import kotlin.math.max
import kotlin.math.min
import kotlin.time.Instant

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope,
	private val storageService: StorageService
) {
	private val receiveChannels: MutableMap<Pair<Int, Int>, Channel<Body>> = mutableMapOf()

	private val sendChannels: MutableMap<Int, MutableSharedFlow<Body>> = mutableMapOf()

	val lastPosition: MutableMap<Int, MutableMap<Int, UserEventPosition>> = mutableMapOf()

	fun getSendChannel(eventId: Int): MutableSharedFlow<Body> {
		return sendChannels[eventId] ?: run {
			MutableSharedFlow<Body>(15, 15).apply { sendChannels[eventId] = this }
		}
	}

	private suspend fun sendPosition(eventId: Int, position: UserEventPosition) {
		getSendChannel(eventId).emit(
			UserReceivePosition(
				position.latitude,
				position.longitude,
				position.altitude,
				position.time,
				position.speed,
				position.user.id.value
			)
		)
	}

	private suspend fun sendStopPosition(eventId: Int, user: Int) {
		getSendChannel(eventId).emit(
			StopUserReceivePosition(user)
		)
	}

	fun getReceiveChannel(eventId: Int, userId: Int): Channel<Body> {
		return receiveChannels[eventId to userId] ?: run {
			lastPosition[eventId] ?: run {
				lastPosition[eventId] = mutableMapOf()
			}
			Channel<Body>(Channel.BUFFERED).apply {
				scope.launch {
					println("listen")
					listenChannel(eventId, userId)
				}
				receiveChannels[eventId to userId] = this
			}
		}
	}

	private suspend fun Channel<Body>.listenChannel(eventId: Int, userId: Int) {
		val event = transaction(db) { Event.findById(eventId) } ?: return
		val user = transaction(db) { User.findById(userId) } ?: return
		val participation = transaction(db) {
			EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id) and (EventParticipations.isJoined eq true)
			}.firstOrNull()
		} ?: return
		for (message in this) {
			if(message is UserSendPosition) {
				val entity = transaction(db) {
					transaction(db) {
						UserEventPosition.new {
							this.user = user
							this.event = event
							this.participation = participation
							this.latitude = message.latitude
							this.longitude = message.longitude
							this.altitude = message.altitude
							this.time = message.time
							this.speed = message.speed
							this.heading = message.heading
							this.accelerationX = message.accelerationX
							this.accelerationY = message.accelerationY
							this.accelerationZ = message.accelerationZ
							this.accuracy = message.accuracy
							this.speedAccuracy = message.speedAccuracy
						}
					}.load(UserEventPosition::user)
				}
				lastPosition[eventId]!![userId] = entity
				sendPosition(eventId, entity)
			} else if(message is StopUserSendPosition) {
				lastPosition[eventId]!!.remove(userId)
				sendStopPosition(eventId, userId)
			}
		}
	}

	private fun authorizeGet(caller: User, target: UserJourney): Boolean = when(caller.scope) {
		EUserScope.User -> target.user?.id == caller.id
		EUserScope.Admin -> target.user?.association?.id == caller.association.id
		EUserScope.Root -> true
	}

	private infix fun UserJourney?.getIfAllowed(caller: User): UserJourney? = this?.let { if(authorizeGet(caller, it)) it else null }

	fun getUserJourneyFromEvent(user: User, event: Event): UserJourney? = transaction(db) {
		val participation = EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull()?.load(EventParticipation::journey) ?: return@transaction null
		participation.journey
	}

	fun removeUserJourneyFromEvent(user: User, event: Event) = transaction(db) {
		val participation = EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull() ?: return@transaction

		participation.journey = null
	}

	suspend fun deleteUserJourney(userJourney: UserJourney) {
		transaction(db) { userJourney.delete() }
		storageService.delete(userJourney.journey)
	}

	fun getUserJourney(caller: User, userJourneyId: Int): UserJourney? {
		return transaction(db) {
			UserJourney.find { (UsersJourneys.id eq userJourneyId) and (UsersJourneys.user eq caller.id) }.firstOrNull()?.load(UserJourney::user, User::association)
		} getIfAllowed caller
	}

	fun getUserJourneys(caller: User, userId: Int, searchParams: SearchParam): List<UserJourney> = transaction(db) {
		UserJourney.wrapRows(
			UsersJourneys
				.innerJoin(Users, { Users.id }, { UsersJourneys.user }, { Users.association eq caller.association.id })
				.selectAll()
				.where(UsersJourneys.user eq userId)
				.applyParam(searchParams)
		).toList()
	}

	fun countUserJourneys(userId: Int, searchParams: SearchParam): Long = transaction(db) {
		UsersJourneys
			.selectAll().where { UsersJourneys.user eq userId }
			.applyParam(searchParams, pagination = false)
			.count()
	}

	private fun calculatePercentage(value: Double, otherValues: List<Double>): Double {
		val countBetter = otherValues.count { it <= value }
		return (countBetter.toDouble() / otherValues.size.toDouble()) * 100
	}

	private fun getValueForKey(journey: UserJourney, key: String): Double? {
		return when (key) {
			"max_speed" -> journey.maxSpeed
			"avg_speed" -> journey.avgSpeed
			"min_elevation" -> journey.minElevation
			"max_elevation" -> journey.maxElevation
			"total_elevation_gain" -> journey.totalElevationGain
			"total_elevation_loss" -> journey.totalElevationLoss
			"avg_g_force" -> journey.avgGForce
			"max_g_force" -> journey.maxGForce
			else -> null
		}
	}

	fun getIsBetterThanForUserJourney(userJourney: UserJourney?): Map<String, Double>? = transaction(db) {
		if (userJourney == null) {
			return@transaction null
		}

		val participation = EventParticipation.find {
			(EventParticipations.journey eq userJourney.id) and (EventParticipations.isJoined eq true)
		}.firstOrNull()

		if (participation == null) {
			return@transaction null
		}

		val eventId = participation.event.id.value

		val otherParticipations = EventParticipation.find {
			(EventParticipations.event eq eventId) and
				(EventParticipations.isJoined eq true) and
				(EventParticipations.id neq participation.id)
		}

		val othersJourneys = otherParticipations.mapNotNull { it.journey }

		if (othersJourneys.isEmpty()) {
			return@transaction emptyMap()
		}

		val hasBest = mutableMapOf<String, Double>()

		val valueMapping = mapOf(
			"max_speed" to userJourney.maxSpeed,
			"avg_speed" to userJourney.avgSpeed,
			"min_elevation" to userJourney.minElevation,
			"max_elevation" to userJourney.maxElevation,
			"total_elevation_gain" to userJourney.totalElevationGain,
			"total_elevation_loss" to userJourney.totalElevationLoss,
			"avg_g_force" to userJourney.avgGForce,
			"max_g_force" to userJourney.maxGForce
		)

		for ((key, value) in valueMapping) {
			value ?: continue

			val otherValues = othersJourneys.mapNotNull { getValueForKey(it, key) }
			hasBest[key] = calculatePercentage(value, otherValues)
		}

		hasBest
	}

	suspend fun terminateUserJourney(user: User, event: Event): UserJourney {
		val raw = mutableListOf<PositionSample>()

		transaction(db) {
			UserEventPosition.find {
				(UsersEventsPositions.user eq user.id) and
					(UsersEventsPositions.event eq event.id)
			}
				.orderBy(UsersEventsPositions.time to SortOrder.ASC)
				.forEach { pos ->
					raw += PositionSample(
						timeMillis = pos.time.toEpochMilliseconds(), // adapt if needed
						lat = pos.latitude,
						lon = pos.longitude,
						alt = pos.altitude,
						accuracyM = pos.accuracy,
						speedMps = pos.speed,
						ax = pos.accelerationX,
						ay = pos.accelerationY,
						az = pos.accelerationZ
					)
				}

			UsersEventsPositions.deleteWhere {
				(UsersEventsPositions.user eq user.id) and (UsersEventsPositions.event eq event.id)
			}
		}

		if (raw.size < 2) {
			throw BadRequestException("Aucune position exploitable pour terminer le trajet")
		}

		val (smoothedStates, origin) = EkfJourney.smoothTrajectory(raw)

		val accelMetrics = AccelPreprocess.computeLinearAccelMetrics(
			samples = raw,
			gravityTauSeconds = 0.8,
			linLowPassTauSeconds = 0.15,
			spikeClampMS2 = 35.0
		)

		val coord = mutableListOf<GeoJsonCoordinates>()
		val times = mutableListOf<JsonPrimitive>()
		val speedArr = mutableListOf<JsonPrimitive>()

		var elevationGain = 0.0
		var elevationLoss = 0.0
		var minElevation = Double.POSITIVE_INFINITY
		var maxElevation = Double.NEGATIVE_INFINITY
		var prevAltitude: Double? = null

		var maxSpeed = Double.NEGATIVE_INFINITY
		var totalSpeed = 0.0
		var speedCount = 0

		var maxGForce = Double.NEGATIVE_INFINITY
		var totalGForce = 0.0
		var gCount = 0

		var maxJerk = Double.NEGATIVE_INFINITY

		for (i in raw.indices) {
			val s = raw[i]
			val st = smoothedStates[i]

			val (latS, lonS) = EkfJourney.xyToLatLon(origin, st.x, st.y)

			coord.add(listOf(lonS, latS, s.alt))

			times.add(JsonPrimitive(Instant.fromEpochMilliseconds(s.timeMillis).toString()))

			val v = (s.speedMps?.takeIf { it.isFinite() && it >= 0.0 }) ?: hypot(st.vx, st.vy)
			speedArr.add(JsonPrimitive(v))

			if (prevAltitude != null) {
				val dh = s.alt - prevAltitude
				if (dh >= 0) elevationGain += dh else elevationLoss += -dh
			}
			prevAltitude = s.alt
			minElevation = min(minElevation, s.alt)
			maxElevation = max(maxElevation, s.alt)

			maxSpeed = max(maxSpeed, v)
			totalSpeed += v
			speedCount++

			val am = accelMetrics[i]
			if (am != null) {
				val g = am.gForce
				maxGForce = max(maxGForce, g)
				totalGForce += g
				gCount++

				val jerkAbs = abs(am.jerk)
				maxJerk = max(maxJerk, jerkAbs)
			}
		}

		if (coord.isEmpty() || times.isEmpty()) {
			throw BadRequestException("Aucune position exploitable pour terminer le trajet")
		}

		val avgSpeed = if (speedCount > 0) totalSpeed / speedCount else 0.0
		val avgGForce = if (gCount > 0) totalGForce / gCount else 0.0
		val maxGForceSafe = if (maxGForce.isFinite()) maxGForce else 0.0

		val totalTime = (Instant.parse(times.last().content) - Instant.parse(times.first().content)).inWholeSeconds

		val geoJson = Feature(
			geometry = LineString(coord),
			properties = JsonObject(
				mapOf(
					"coordTimes" to JsonArray(times),
					"speed" to JsonArray(speedArr)
				)
			)
		).apply {
			bbox = getBoundingBox()
		}

		val file = uploadUserJourney(geoJson, event.id.value, user.id.value)

		return transaction(db) {
			val participation = EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
			}.first()

			UserJourney.new {
				this.journey = file
				this.avgSpeed = avgSpeed
				this.totalElevationGain = elevationGain
				this.totalElevationLoss = elevationLoss
				this.totalDistance = calculateDistance(coord) // uses smoothed geometry now
				this.minElevation = minElevation
				this.maxElevation = maxElevation
				this.totalTime = totalTime
				this.maxSpeed = maxSpeed

				this.avgGForce = avgGForce
				this.maxGForce = maxGForceSafe

				this.user = user
			}.apply {
				participation.journey = this
			}
		}
	}


	private suspend fun uploadUserJourney(geoJson: GeoJson, eventId: Int, userId: Int): String {
		val json = json.encodeToString(geoJson).toByteArray()
		val path = "e/$eventId/u/$userId/j"
		storageService.store(json, path, "application/geo+json")
		return path
	}
}



