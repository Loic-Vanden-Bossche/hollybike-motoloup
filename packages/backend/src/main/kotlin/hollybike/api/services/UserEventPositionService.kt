/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import hollybike.api.exceptions.BadRequestException
import hollybike.api.exceptions.EventJourneyStepNotFoundException
import hollybike.api.json
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.participation.TEventCallerParticipationStepJourney
import hollybike.api.types.event.participation.TUserJourney
import hollybike.api.types.journey.*
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.*
import hollybike.api.utils.AccelPreprocess
import hollybike.api.utils.EkfPositionSample
import hollybike.api.utils.EkfJourney
import hollybike.api.utils.EkfState
import hollybike.api.utils.PositionSample
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.dao.load
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.jdbc.deleteWhere
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import java.util.UUID
import kotlin.math.abs
import kotlin.math.atan2
import kotlin.math.hypot
import kotlin.math.max
import kotlin.math.min
import kotlin.math.sqrt
import kotlin.time.Instant

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope,
	private val storageService: StorageService
) {
	companion object {
		// Temporary testing hook. Set to false (or remove related helpers) when no longer needed.
		private const val ENABLE_RAW_DEBUG_JOURNEY_SAVE = true
		private const val RAW_DEBUG_NAME_PREFIX = "[DEBUG RAW]"
	}

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
					val currentStep = getCurrentEventStep(event.id.value)
					UserEventPosition.new {
						this.user = user
						this.event = event
						this.participation = participation
						this.journeyStep = currentStep
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

	private fun getCurrentEventStep(eventId: Int): EventJourneyStep? {
		return EventJourneyStep.find {
			(EventJourneySteps.event eq eventId) and (EventJourneySteps.isCurrent eq true)
		}.limit(1).firstOrNull()
	}

	private fun getStepForEvent(eventId: Int, stepId: Int): EventJourneyStep? {
		return EventJourneyStep.find {
			(EventJourneySteps.id eq stepId) and (EventJourneySteps.event eq eventId)
		}.limit(1).firstOrNull()
	}

	private fun getParticipation(user: User, event: Event): EventParticipation? {
		return EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull()
	}

	fun getUserJourneyFromEvent(user: User, event: Event): UserJourney? = transaction(db) {
		val currentStep = getCurrentEventStep(event.id.value)
		if (currentStep == null) {
			val participation = getParticipation(user, event) ?: return@transaction null
			return@transaction participation.load(EventParticipation::journey).journey
		}
		getUserJourneyFromEventStep(user, event, currentStep.id.value)
	}

	fun getUserJourneyFromEventStep(user: User, event: Event, stepId: Int): UserJourney? = transaction(db) {
		if (getStepForEvent(event.id.value, stepId) == null) {
			return@transaction null
		}
		val participation = getParticipation(user, event) ?: return@transaction null
		val stepJourney = EventParticipationStepJourney.find {
			(EventParticipationStepJourneys.participation eq participation.id) and
				(EventParticipationStepJourneys.step eq stepId)
		}.limit(1).firstOrNull()

		stepJourney?.journey ?: if (getCurrentEventStep(event.id.value)?.id?.value == stepId) {
			participation.load(EventParticipation::journey).journey
		} else {
			null
		}
	}

	fun removeUserJourneyFromEvent(user: User, event: Event) = transaction(db) {
		val currentStep = getCurrentEventStep(event.id.value)
		if (currentStep == null) {
			val participation = getParticipation(user, event) ?: return@transaction
			participation.journey?.let { clearJourneyContextLink(it) }
			participation.journey = null
			return@transaction
		}
		removeUserJourneyFromEventStep(user, event, currentStep.id.value)
	}

	fun removeUserJourneyFromEventStep(user: User, event: Event, stepId: Int) = transaction(db) {
		if (getStepForEvent(event.id.value, stepId) == null) {
			throw EventJourneyStepNotFoundException("Étape $stepId introuvable")
		}
		val participation = getParticipation(user, event) ?: return@transaction

		val stepMappings = EventParticipationStepJourney.find {
			(EventParticipationStepJourneys.participation eq participation.id) and
				(EventParticipationStepJourneys.step eq stepId)
		}.toList()
		stepMappings.forEach { mapping ->
			clearJourneyContextLink(mapping.journey)
			mapping.delete()
		}

		UsersEventsPositions.deleteWhere {
			(UsersEventsPositions.participation eq participation.id) and
				(UsersEventsPositions.journeyStep eq stepId)
		}

		if (getCurrentEventStep(event.id.value)?.id?.value == stepId) {
			participation.journey?.let { clearJourneyContextLink(it) }
			participation.journey = null
		}
	}

	private fun clearJourneyContextLink(userJourney: UserJourney) {
		userJourney.event = null
		userJourney.eventJourneyStep = null
	}

	fun getCallerStepJourneys(
		user: User,
		event: Event,
		steps: List<EventJourneyStep>
	): List<TEventCallerParticipationStepJourney> = transaction(db) {
		val participation = getParticipation(user, event) ?: return@transaction emptyList()
		val mappings = EventParticipationStepJourney.find {
			EventParticipationStepJourneys.participation eq participation.id
		}.associateBy { it.step.id.value }
		val recordedCounts = UserEventPosition.find {
			UsersEventsPositions.participation eq participation.id
		}.groupingBy { it.journeyStep?.id?.value }.eachCount()

		steps.sortedBy { it.position }.map { step ->
			val mapping = mappings[step.id.value]
			val journey = mapping?.journey
			TEventCallerParticipationStepJourney(
				stepId = step.id.value,
				journey = journey?.let {
					TUserJourney(
						it,
						getIsBetterThanForUserJourneyInTransaction(it),
						step.event.name,
						step.name
					)
				},
				hasRecordedPositions = (recordedCounts[step.id.value] ?: 0) >= 2
			)
		}
	}

	fun getParticipationStepJourneys(
		participation: EventParticipation
	): List<TEventCallerParticipationStepJourney> = transaction(db) {
		EventParticipationStepJourney.find {
			EventParticipationStepJourneys.participation eq participation.id
		}.sortedBy { it.step.position }
			.map { mapping ->
				TEventCallerParticipationStepJourney(
					stepId = mapping.step.id.value,
					journey = TUserJourney(
						mapping.journey,
						getIsBetterThanForUserJourneyInTransaction(mapping.journey),
						mapping.step.event.name,
						mapping.step.name
					),
					hasRecordedPositions = false
				)
			}
	}

	fun getJourneyEventAndStepNames(userJourney: UserJourney): Pair<String?, String?> = transaction(db) {
		getJourneyEventAndStepNamesInTransaction(userJourney)
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
		getIsBetterThanForUserJourneyInTransaction(userJourney)
	}

	private fun getIsBetterThanForUserJourneyInTransaction(userJourney: UserJourney?): Map<String, Double>? {
		if (userJourney == null) {
			return null
		}

		val event = userJourney.event ?: return null
		val step = userJourney.eventJourneyStep
		val othersJourneys = if (step != null) {
			if (step.event.id.value != event.id.value) {
				return null
			}

			EventParticipationStepJourney.find {
				EventParticipationStepJourneys.step eq step.id
			}.mapNotNull { row ->
				if (!row.participation.isJoined) return@mapNotNull null
				val otherJourney = row.journey
				if (otherJourney.id.value == userJourney.id.value) return@mapNotNull null
				val otherEvent = otherJourney.event
				val otherStep = otherJourney.eventJourneyStep
				if (otherEvent?.id?.value != event.id.value || otherStep?.id?.value != step.id.value) {
					return@mapNotNull null
				}
				otherJourney
			}
		} else {
			EventParticipation.find {
				(EventParticipations.event eq event.id) and (EventParticipations.isJoined eq true)
			}.mapNotNull { participation ->
				val otherJourney = participation.journey ?: return@mapNotNull null
				if (otherJourney.id.value == userJourney.id.value) return@mapNotNull null
				if (otherJourney.event?.id?.value != event.id.value) return@mapNotNull null
				if (otherJourney.eventJourneyStep != null) return@mapNotNull null
				otherJourney
			}
		}

		if (othersJourneys.isEmpty()) {
			return emptyMap()
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

		return hasBest
	}

	private fun getJourneyEventAndStepNamesInTransaction(userJourney: UserJourney): Pair<String?, String?> {
		val event = userJourney.event
		val step = userJourney.eventJourneyStep
		val eventName = event?.name
		val stepName =
			if (event != null && step != null && step.event.id.value == event.id.value) {
				step.name
			} else {
				null
			}
		return eventName to stepName
	}

	private data class FilteringArtifacts(
		val smoothedStates: List<EkfState>,
		val origin: EkfJourney.Origin,
		val accelMetrics: List<AccelPreprocess.AccelMetrics?>
	)

	private data class JourneyComputation(
		val geoJson: Feature,
		val avgSpeed: Double,
		val totalElevationGain: Double,
		val totalElevationLoss: Double,
		val totalDistance: Double,
		val minElevation: Double,
		val maxElevation: Double,
		val totalTime: Long,
		val maxSpeed: Double,
		val avgGForce: Double,
		val maxGForce: Double
	)

	suspend fun terminateUserJourney(user: User, event: Event): UserJourney {
		val currentStep = transaction(db) { getCurrentEventStep(event.id.value) }
		return if (currentStep != null) {
			terminateUserJourney(user, event, currentStep.id.value)
		} else {
			terminateUserJourney(user, event, null)
		}
	}

	suspend fun terminateUserJourney(user: User, event: Event, stepId: Int?): UserJourney {
		if (stepId != null) {
			val stepExists = transaction(db) { getStepForEvent(event.id.value, stepId) != null }
			if (!stepExists) {
				throw EventJourneyStepNotFoundException("Étape $stepId introuvable")
			}
		}
		val raw = loadRawJourneySamples(user, event, stepId)
		if (raw.size < 2) {
			throw BadRequestException("Aucune position exploitable pour terminer le trajet")
		}

		val filtering = computeFilteringArtifacts(raw)
		val computed = buildJourneyComputation(raw, filtering.smoothedStates, filtering.origin, filtering.accelMetrics)
		val file = uploadUserJourney(computed.geoJson, event.id.value, user.id.value)
		val journey = persistJourney(user, event, stepId, file, computed)

		if (ENABLE_RAW_DEBUG_JOURNEY_SAVE) {
			runCatching {
				persistRawDebugJourney(user, event, stepId, raw)
			}.onFailure {
				println("Failed to persist raw debug journey: ${it.message}")
			}
		}

		return journey
	}

	private fun loadRawJourneySamples(user: User, event: Event, stepId: Int?): List<PositionSample> = transaction(db) {
		UserEventPosition.find {
			(UsersEventsPositions.user eq user.id) and
				(UsersEventsPositions.event eq event.id) and
				if (stepId == null) {
					UsersEventsPositions.journeyStep.isNull()
				} else {
					UsersEventsPositions.journeyStep eq stepId
				}
		}
			.orderBy(UsersEventsPositions.time to SortOrder.ASC)
			.map { pos ->
				PositionSample(
					timeMillis = pos.time.toEpochMilliseconds(),
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
	}

	private fun computeFilteringArtifacts(raw: List<PositionSample>): FilteringArtifacts {
		val ekfSamples = raw.map {
			EkfPositionSample(
				timeMillis = it.timeMillis,
				lat = it.lat,
				lon = it.lon,
				accuracyM = it.accuracyM,
				speedMps = it.speedMps
			)
		}
		val (smoothedStates, origin) = EkfJourney.smoothTrajectory(ekfSamples)
		val accelMetrics = AccelPreprocess.computeLinearAccelMetrics(
			samples = raw,
			gravityTauSeconds = 0.8,
			linLowPassTauSeconds = 0.15,
			spikeClampMS2 = 35.0
		)
		return FilteringArtifacts(smoothedStates, origin, accelMetrics)
	}

	private fun buildJourneyComputation(
		raw: List<PositionSample>,
		smoothedStates: List<EkfState>,
		origin: EkfJourney.Origin,
		accelMetrics: List<AccelPreprocess.AccelMetrics?>
	): JourneyComputation {
		val coord = mutableListOf<GeoJsonCoordinates>()
		val times = mutableListOf<JsonPrimitive>()
		val speedArr = mutableListOf<JsonPrimitive>()
		val rawLatArr = mutableListOf<JsonPrimitive>()
		val rawLonArr = mutableListOf<JsonPrimitive>()
		val rawAltArr = mutableListOf<JsonPrimitive>()
		val smoothedLatArr = mutableListOf<JsonPrimitive>()
		val smoothedLonArr = mutableListOf<JsonPrimitive>()
		val accuracyArr = mutableListOf<JsonPrimitive>()
		val gpsSpeedArr = mutableListOf<JsonElement>()
		val gpsSpeedValidArr = mutableListOf<JsonPrimitive>()
		val speedSourceArr = mutableListOf<JsonPrimitive>()
		val speedDeltaArr = mutableListOf<JsonElement>()
		val vxArr = mutableListOf<JsonPrimitive>()
		val vyArr = mutableListOf<JsonPrimitive>()
		val ekfSpeedArr = mutableListOf<JsonPrimitive>()
		val headingDegArr = mutableListOf<JsonPrimitive>()
		val dtArr = mutableListOf<JsonPrimitive>()
		val segmentDistanceArr = mutableListOf<JsonPrimitive>()
		val cumulativeDistanceArr = mutableListOf<JsonPrimitive>()
		val elevationDeltaArr = mutableListOf<JsonPrimitive>()
		val cumulativeElevationGainArr = mutableListOf<JsonPrimitive>()
		val cumulativeElevationLossArr = mutableListOf<JsonPrimitive>()
		val linAccelArr = mutableListOf<JsonElement>()
		val gForceArr = mutableListOf<JsonElement>()
		val jerkArr = mutableListOf<JsonElement>()
		val hasAccelMetricsArr = mutableListOf<JsonPrimitive>()

		var elevationGain = 0.0
		var elevationLoss = 0.0
		var minElevation = Double.POSITIVE_INFINITY
		var maxElevation = Double.NEGATIVE_INFINITY
		var prevAltitude: Double? = null
		var prevTimeMillis: Long? = null
		var prevState: EkfState? = null
		var cumulativeDistance = 0.0

		var maxSpeed = Double.NEGATIVE_INFINITY
		var totalSpeed = 0.0
		var speedCount = 0
		var gpsSpeedCount = 0
		var totalAccuracy = 0.0
		var accuracyCount = 0

		var maxGForce = Double.NEGATIVE_INFINITY
		var totalGForce = 0.0
		var gCount = 0

		var maxJerk = Double.NEGATIVE_INFINITY

		for (i in raw.indices) {
			val s = raw[i]
			val st = smoothedStates[i]

			val (latS, lonS) = EkfJourney.xyToLatLon(origin, st.x, st.y)
			rawLatArr.add(JsonPrimitive(s.lat))
			rawLonArr.add(JsonPrimitive(s.lon))
			rawAltArr.add(JsonPrimitive(s.alt))
			smoothedLatArr.add(JsonPrimitive(latS))
			smoothedLonArr.add(JsonPrimitive(lonS))
			accuracyArr.add(JsonPrimitive(s.accuracyM))
			if (s.accuracyM.isFinite()) {
				totalAccuracy += s.accuracyM
				accuracyCount++
			}

			coord.add(listOf(lonS, latS, s.alt))
			times.add(JsonPrimitive(Instant.fromEpochMilliseconds(s.timeMillis).toString()))

			val gpsSpeed = s.speedMps?.takeIf { it.isFinite() && it >= 0.0 }
			val gpsSpeedValid = gpsSpeed != null
			if (gpsSpeedValid) gpsSpeedCount++

			val ekfSpeed = hypot(st.vx, st.vy)
			val v = gpsSpeed ?: ekfSpeed
			speedArr.add(JsonPrimitive(v))
			gpsSpeedArr.add(if (gpsSpeedValid) JsonPrimitive(gpsSpeed) else JsonNull)
			gpsSpeedValidArr.add(JsonPrimitive(gpsSpeedValid))
			speedSourceArr.add(JsonPrimitive(if (gpsSpeedValid) "gps" else "ekf"))
			speedDeltaArr.add(if (gpsSpeedValid) JsonPrimitive(gpsSpeed - ekfSpeed) else JsonNull)
			vxArr.add(JsonPrimitive(st.vx))
			vyArr.add(JsonPrimitive(st.vy))
			ekfSpeedArr.add(JsonPrimitive(ekfSpeed))
			headingDegArr.add(JsonPrimitive(Math.toDegrees(atan2(st.vy, st.vx))))

			val dtSeconds = if (prevTimeMillis == null) 0.0 else max(0.0, (s.timeMillis - prevTimeMillis).toDouble() / 1000.0)
			dtArr.add(JsonPrimitive(dtSeconds))
			prevTimeMillis = s.timeMillis

			val segmentDistance = if (prevState == null) 0.0 else hypot(st.x - prevState.x, st.y - prevState.y)
			segmentDistanceArr.add(JsonPrimitive(segmentDistance))
			cumulativeDistance += segmentDistance
			cumulativeDistanceArr.add(JsonPrimitive(cumulativeDistance))
			prevState = st

			val elevationDelta = if (prevAltitude == null) 0.0 else s.alt - prevAltitude
			elevationDeltaArr.add(JsonPrimitive(elevationDelta))
			if (prevAltitude != null) {
				val dh = s.alt - prevAltitude
				if (dh >= 0) elevationGain += dh else elevationLoss += -dh
			}
			prevAltitude = s.alt
			cumulativeElevationGainArr.add(JsonPrimitive(elevationGain))
			cumulativeElevationLossArr.add(JsonPrimitive(elevationLoss))
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

				linAccelArr.add(JsonPrimitive(am.linMag))
				gForceArr.add(JsonPrimitive(g))
				jerkArr.add(JsonPrimitive(am.jerk))
				hasAccelMetricsArr.add(JsonPrimitive(true))
			} else {
				linAccelArr.add(JsonNull)
				gForceArr.add(JsonNull)
				jerkArr.add(JsonNull)
				hasAccelMetricsArr.add(JsonPrimitive(false))
			}
		}

		if (coord.isEmpty() || times.isEmpty()) {
			throw BadRequestException("Aucune position exploitable pour terminer le trajet")
		}

		val avgSpeed = if (speedCount > 0) totalSpeed / speedCount else 0.0
		val avgGForce = if (gCount > 0) totalGForce / gCount else 0.0
		val maxGForceSafe = if (maxGForce.isFinite()) maxGForce else 0.0
		val maxJerkSafe = if (maxJerk.isFinite()) maxJerk else 0.0
		val meanAccuracy = if (accuracyCount > 0) totalAccuracy / accuracyCount else 0.0

		val totalTime = (Instant.parse(times.last().content) - Instant.parse(times.first().content)).inWholeSeconds
		val totalDistance = calculateDistance(coord)

		val geoJson = Feature(
			geometry = LineString(coord),
			properties = JsonObject(
				mapOf(
					"coordTimes" to JsonArray(times),
					"speed" to JsonArray(speedArr),
					"rawLatitude" to JsonArray(rawLatArr),
					"rawLongitude" to JsonArray(rawLonArr),
					"rawAltitude" to JsonArray(rawAltArr),
					"smoothedLatitude" to JsonArray(smoothedLatArr),
					"smoothedLongitude" to JsonArray(smoothedLonArr),
					"accuracyM" to JsonArray(accuracyArr),
					"gpsSpeedMps" to JsonArray(gpsSpeedArr),
					"gpsSpeedValid" to JsonArray(gpsSpeedValidArr),
					"speedSource" to JsonArray(speedSourceArr),
					"speedDeltaGpsMinusEkfMps" to JsonArray(speedDeltaArr),
					"ekfVxMps" to JsonArray(vxArr),
					"ekfVyMps" to JsonArray(vyArr),
					"ekfSpeedMps" to JsonArray(ekfSpeedArr),
					"headingDeg" to JsonArray(headingDegArr),
					"dtSeconds" to JsonArray(dtArr),
					"segmentDistanceM" to JsonArray(segmentDistanceArr),
					"cumulativeDistanceM" to JsonArray(cumulativeDistanceArr),
					"elevationDeltaM" to JsonArray(elevationDeltaArr),
					"cumulativeElevationGainM" to JsonArray(cumulativeElevationGainArr),
					"cumulativeElevationLossM" to JsonArray(cumulativeElevationLossArr),
					"linearAccelerationMps2" to JsonArray(linAccelArr),
					"gForce" to JsonArray(gForceArr),
					"jerkMps3" to JsonArray(jerkArr),
					"hasAccelMetrics" to JsonArray(hasAccelMetricsArr),
					"summary" to JsonObject(
						mapOf(
							"pointCount" to JsonPrimitive(coord.size),
							"totalTimeSeconds" to JsonPrimitive(totalTime),
							"totalDistanceMeters" to JsonPrimitive(totalDistance),
							"totalDistanceFromStateMeters" to JsonPrimitive(cumulativeDistance),
							"averageSpeedMps" to JsonPrimitive(avgSpeed),
							"maxSpeedMps" to JsonPrimitive(maxSpeed),
							"meanAccuracyM" to JsonPrimitive(meanAccuracy),
							"samplesWithValidGpsSpeed" to JsonPrimitive(gpsSpeedCount),
							"samplesWithAccelMetrics" to JsonPrimitive(gCount),
							"totalElevationGainM" to JsonPrimitive(elevationGain),
							"totalElevationLossM" to JsonPrimitive(elevationLoss),
							"minElevationM" to JsonPrimitive(minElevation),
							"maxElevationM" to JsonPrimitive(maxElevation),
							"averageGForce" to JsonPrimitive(avgGForce),
							"maxGForce" to JsonPrimitive(maxGForceSafe),
							"maxAbsJerkMps3" to JsonPrimitive(maxJerkSafe)
						)
					)
				)
			)
		).apply {
			bbox = getBoundingBox()
		}

		return JourneyComputation(
			geoJson = geoJson,
			avgSpeed = avgSpeed,
			totalElevationGain = elevationGain,
			totalElevationLoss = elevationLoss,
			totalDistance = totalDistance,
			minElevation = minElevation,
			maxElevation = maxElevation,
			totalTime = totalTime,
			maxSpeed = maxSpeed,
			avgGForce = avgGForce,
			maxGForce = maxGForceSafe
		)
	}

	private fun persistJourney(
		user: User,
		event: Event,
		stepId: Int?,
		file: String,
		computed: JourneyComputation
	): UserJourney {
		return transaction(db) {
			val participation = EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
			}.first()
			val step = stepId?.let {
				EventJourneyStep.find {
					(EventJourneySteps.id eq it) and (EventJourneySteps.event eq event.id)
				}.limit(1).firstOrNull() ?: throw BadRequestException("Étape introuvable")
			}
			if (step == null) {
				UserJourney.find {
					(UsersJourneys.user eq user.id) and
						(UsersJourneys.event eq event.id) and
						UsersJourneys.eventJourneyStep.isNull()
				}.forEach { existing ->
					existing.event = null
					existing.eventJourneyStep = null
				}
			}
			UserJourney.new {
				this.journey = file
				this.avgSpeed = computed.avgSpeed
				this.totalElevationGain = computed.totalElevationGain
				this.totalElevationLoss = computed.totalElevationLoss
				this.totalDistance = computed.totalDistance
				this.minElevation = computed.minElevation
				this.maxElevation = computed.maxElevation
				this.totalTime = computed.totalTime
				this.maxSpeed = computed.maxSpeed

				this.avgGForce = computed.avgGForce
				this.maxGForce = computed.maxGForce

				this.user = user
				this.event = event
				this.eventJourneyStep = step
				this.name = if (step != null) {
					"${event.name} x ${step.name?.takeIf { it.isNotBlank() } ?: "Étape ${step.position}"}"
				} else {
					event.name
				}
			}.apply {
				if (step != null) {
					val existingStepJourney = EventParticipationStepJourney.find {
						(EventParticipationStepJourneys.participation eq participation.id) and
							(EventParticipationStepJourneys.step eq step.id)
					}.limit(1).firstOrNull()

					if (existingStepJourney != null) {
						existingStepJourney.journey = this
					} else {
						EventParticipationStepJourney.new {
							this.participation = participation
							this.step = step
							this.journey = this@apply
						}
					}
				}

				if (step == null || step.isCurrent) {
					participation.journey = this
				}

				UsersEventsPositions.deleteWhere {
					(UsersEventsPositions.user eq user.id) and
						(UsersEventsPositions.event eq event.id) and
						if (step == null) {
							UsersEventsPositions.journeyStep.isNull()
						} else {
							UsersEventsPositions.journeyStep eq step.id
						}
				}
			}
		}
	}


	private suspend fun uploadUserJourney(geoJson: GeoJson, eventId: Int, userId: Int): String {
		val json = json.encodeToString(geoJson).toByteArray()
		val path = "e/$eventId/u/$userId/j"
		storageService.store(json, path, "application/geo+json")
		return path
	}

	private fun buildRawGeoJson(raw: List<PositionSample>): Feature {
		val coordinates = raw.map { sample -> listOf(sample.lon, sample.lat, sample.alt) }
		val times = raw.map { sample -> JsonPrimitive(Instant.fromEpochMilliseconds(sample.timeMillis).toString()) }
		val epochMillis = mutableListOf<JsonPrimitive>()
		val rawLat = mutableListOf<JsonPrimitive>()
		val rawLon = mutableListOf<JsonPrimitive>()
		val rawAlt = mutableListOf<JsonPrimitive>()
		val rawAccuracy = mutableListOf<JsonPrimitive>()
		val rawSpeed = mutableListOf<JsonElement>()
		val rawAx = mutableListOf<JsonElement>()
		val rawAy = mutableListOf<JsonElement>()
		val rawAz = mutableListOf<JsonElement>()
		val rawAccelNorm = mutableListOf<JsonElement>()
		val rawAccelG = mutableListOf<JsonElement>()
		val dtSeconds = mutableListOf<JsonPrimitive>()
		val segmentDistanceM = mutableListOf<JsonPrimitive>()
		val cumulativeDistanceM = mutableListOf<JsonPrimitive>()
		val elevationDeltaM = mutableListOf<JsonPrimitive>()
		val cumulativeElevationGainM = mutableListOf<JsonPrimitive>()
		val cumulativeElevationLossM = mutableListOf<JsonPrimitive>()
		val headingDeg = mutableListOf<JsonElement>()
		val speedFromPositionMps = mutableListOf<JsonElement>()
		val gpsSpeedDeltaMps = mutableListOf<JsonElement>()

		var prev: PositionSample? = null
		var cumulativeDistance = 0.0
		var cumulativeElevationGain = 0.0
		var cumulativeElevationLoss = 0.0
		var speedCount = 0
		var speedValidCount = 0
		var speedSum = 0.0
		var speedMin = Double.POSITIVE_INFINITY
		var speedMax = Double.NEGATIVE_INFINITY
		var accuracyCount = 0
		var accuracySum = 0.0
		var accuracyMin = Double.POSITIVE_INFINITY
		var accuracyMax = Double.NEGATIVE_INFINITY
		var accelCount = 0
		var accelNormSum = 0.0
		var accelNormMax = Double.NEGATIVE_INFINITY

		raw.forEach { sample ->
			epochMillis.add(JsonPrimitive(sample.timeMillis))
			rawLat.add(JsonPrimitive(sample.lat))
			rawLon.add(JsonPrimitive(sample.lon))
			rawAlt.add(JsonPrimitive(sample.alt))
			rawAccuracy.add(JsonPrimitive(sample.accuracyM))
			rawSpeed.add(sample.speedMps?.let { JsonPrimitive(it) } ?: JsonNull)
			rawAx.add(sample.ax?.let { JsonPrimitive(it) } ?: JsonNull)
			rawAy.add(sample.ay?.let { JsonPrimitive(it) } ?: JsonNull)
			rawAz.add(sample.az?.let { JsonPrimitive(it) } ?: JsonNull)

			if (sample.accuracyM.isFinite()) {
				accuracyCount++
				accuracySum += sample.accuracyM
				accuracyMin = min(accuracyMin, sample.accuracyM)
				accuracyMax = max(accuracyMax, sample.accuracyM)
			}

			val accelNorm = if (sample.ax != null && sample.ay != null && sample.az != null) {
				sqrt(sample.ax * sample.ax + sample.ay * sample.ay + sample.az * sample.az)
			} else {
				null
			}
			rawAccelNorm.add(accelNorm?.let { JsonPrimitive(it) } ?: JsonNull)
			rawAccelG.add(accelNorm?.let { JsonPrimitive(it / 9.80665) } ?: JsonNull)
			if (accelNorm != null && accelNorm.isFinite()) {
				accelCount++
				accelNormSum += accelNorm
				accelNormMax = max(accelNormMax, accelNorm)
			}

			val previous = prev
			if (previous == null) {
				dtSeconds.add(JsonPrimitive(0.0))
				segmentDistanceM.add(JsonPrimitive(0.0))
				cumulativeDistanceM.add(JsonPrimitive(0.0))
				elevationDeltaM.add(JsonPrimitive(0.0))
				cumulativeElevationGainM.add(JsonPrimitive(0.0))
				cumulativeElevationLossM.add(JsonPrimitive(0.0))
				headingDeg.add(JsonNull)
				speedFromPositionMps.add(JsonNull)
				gpsSpeedDeltaMps.add(JsonNull)
			} else {
				val dt = max(0.0, (sample.timeMillis - previous.timeMillis).toDouble() / 1000.0)
				dtSeconds.add(JsonPrimitive(dt))

				val segmentDistance = calculateDistance(
					listOf(
						listOf(previous.lon, previous.lat),
						listOf(sample.lon, sample.lat)
					)
				)
				segmentDistanceM.add(JsonPrimitive(segmentDistance))
				cumulativeDistance += segmentDistance
				cumulativeDistanceM.add(JsonPrimitive(cumulativeDistance))

				val elevationDelta = sample.alt - previous.alt
				elevationDeltaM.add(JsonPrimitive(elevationDelta))
				if (elevationDelta >= 0) {
					cumulativeElevationGain += elevationDelta
				} else {
					cumulativeElevationLoss += -elevationDelta
				}
				cumulativeElevationGainM.add(JsonPrimitive(cumulativeElevationGain))
				cumulativeElevationLossM.add(JsonPrimitive(cumulativeElevationLoss))

				val heading = Math.toDegrees(atan2(sample.lon - previous.lon, sample.lat - previous.lat))
				headingDeg.add(JsonPrimitive(heading))

				val derivedSpeed = if (dt > 0) segmentDistance / dt else null
				speedFromPositionMps.add(derivedSpeed?.let { JsonPrimitive(it) } ?: JsonNull)

				val gpsSpeed = sample.speedMps?.takeIf { it.isFinite() && it >= 0.0 }
				if (gpsSpeed != null) {
					speedValidCount++
					speedSum += gpsSpeed
					speedMin = min(speedMin, gpsSpeed)
					speedMax = max(speedMax, gpsSpeed)
				}
				speedCount++
				gpsSpeedDeltaMps.add(
					if (gpsSpeed != null && derivedSpeed != null) {
						JsonPrimitive(gpsSpeed - derivedSpeed)
					} else {
						JsonNull
					}
				)
			}

			prev = sample
		}

		val bboxValues = Feature(geometry = LineString(coordinates), properties = null).apply { bbox = getBoundingBox() }.bbox
		val avgGpsSpeed = if (speedValidCount > 0) speedSum / speedValidCount else 0.0
		val avgAccuracy = if (accuracyCount > 0) accuracySum / accuracyCount else 0.0
		val avgAccelNorm = if (accelCount > 0) accelNormSum / accelCount else 0.0

		return Feature(
			geometry = LineString(coordinates),
			properties = JsonObject(
				mapOf(
					"coordTimes" to JsonArray(times),
					"epochMillis" to JsonArray(epochMillis),
					"rawLatitude" to JsonArray(rawLat),
					"rawLongitude" to JsonArray(rawLon),
					"rawAltitude" to JsonArray(rawAlt),
					"rawAccuracyM" to JsonArray(rawAccuracy),
					"rawSpeedMps" to JsonArray(rawSpeed),
					"rawAccelerationXMps2" to JsonArray(rawAx),
					"rawAccelerationYMps2" to JsonArray(rawAy),
					"rawAccelerationZMps2" to JsonArray(rawAz),
					"rawAccelerationNormMps2" to JsonArray(rawAccelNorm),
					"rawAccelerationNormG" to JsonArray(rawAccelG),
					"dtSeconds" to JsonArray(dtSeconds),
					"segmentDistanceM" to JsonArray(segmentDistanceM),
					"cumulativeDistanceM" to JsonArray(cumulativeDistanceM),
					"speedFromPositionMps" to JsonArray(speedFromPositionMps),
					"gpsSpeedDeltaMps" to JsonArray(gpsSpeedDeltaMps),
					"headingDeg" to JsonArray(headingDeg),
					"elevationDeltaM" to JsonArray(elevationDeltaM),
					"cumulativeElevationGainM" to JsonArray(cumulativeElevationGainM),
					"cumulativeElevationLossM" to JsonArray(cumulativeElevationLossM),
					"summary" to JsonObject(
						mapOf(
							"pointCount" to JsonPrimitive(coordinates.size),
							"startEpochMillis" to JsonPrimitive(raw.first().timeMillis),
							"endEpochMillis" to JsonPrimitive(raw.last().timeMillis),
							"totalTimeSeconds" to JsonPrimitive((raw.last().timeMillis - raw.first().timeMillis) / 1000.0),
							"totalDistanceMeters" to JsonPrimitive(cumulativeDistance),
							"totalDistanceFromGeometryMeters" to JsonPrimitive(calculateDistance(coordinates)),
							"totalElevationGainM" to JsonPrimitive(cumulativeElevationGain),
							"totalElevationLossM" to JsonPrimitive(cumulativeElevationLoss),
							"bbox" to (bboxValues?.let { JsonArray(it.map { value -> JsonPrimitive(value) }) } ?: JsonNull),
							"averageGpsSpeedMps" to JsonPrimitive(avgGpsSpeed),
							"minGpsSpeedMps" to JsonPrimitive(if (speedMin.isFinite()) speedMin else 0.0),
							"maxGpsSpeedMps" to JsonPrimitive(if (speedMax.isFinite()) speedMax else 0.0),
							"samplesWithValidGpsSpeed" to JsonPrimitive(speedValidCount),
							"samplesWithAnySpeed" to JsonPrimitive(speedCount),
							"averageAccuracyM" to JsonPrimitive(avgAccuracy),
							"minAccuracyM" to JsonPrimitive(if (accuracyMin.isFinite()) accuracyMin else 0.0),
							"maxAccuracyM" to JsonPrimitive(if (accuracyMax.isFinite()) accuracyMax else 0.0),
							"samplesWithFiniteAccuracy" to JsonPrimitive(accuracyCount),
							"averageAccelerationNormMps2" to JsonPrimitive(avgAccelNorm),
							"maxAccelerationNormMps2" to JsonPrimitive(if (accelNormMax.isFinite()) accelNormMax else 0.0),
							"samplesWithAccelerationVector" to JsonPrimitive(accelCount)
						)
					)
				)
			)
		).apply {
			this.bbox = getBoundingBox()
		}
	}

	private suspend fun uploadRawDebugJourney(geoJson: GeoJson, eventId: Int, userId: Int): String {
		val json = json.encodeToString(geoJson).toByteArray()
		val path = "e/$eventId/u/$userId/j-raw-${UUID.randomUUID()}"
		storageService.store(json, path, "application/geo+json")
		return path
	}

	private suspend fun persistRawDebugJourney(
		user: User,
		event: Event,
		stepId: Int?,
		raw: List<PositionSample>
	): UserJourney {
		val rawGeoJson = buildRawGeoJson(raw)
		val path = uploadRawDebugJourney(rawGeoJson, event.id.value, user.id.value)
		val totalTime = if (raw.size >= 2) {
			(raw.last().timeMillis - raw.first().timeMillis) / 1000
		} else {
			0L
		}
		val speeds = raw.mapNotNull { sample -> sample.speedMps?.takeIf { it.isFinite() && it >= 0.0 } }
		val maxSpeed = speeds.maxOrNull() ?: 0.0
		val avgSpeed = if (speeds.isEmpty()) 0.0 else speeds.average()
		val elevation = rawGeoJson.minMaxAltitude
		val (elevationGain, elevationLoss) = rawGeoJson.totalHeightDifference

		return transaction(db) {
			UserJourney.new {
				this.journey = path
				this.avgSpeed = avgSpeed
				this.totalElevationGain = elevationGain
				this.totalElevationLoss = elevationLoss
				this.totalDistance = rawGeoJson.totalDistance
				this.minElevation = elevation?.first
				this.maxElevation = elevation?.second
				this.totalTime = totalTime
				this.maxSpeed = maxSpeed
				this.avgGForce = null
				this.maxGForce = null
				this.user = user
				this.event = null
				this.eventJourneyStep = null
				this.name = if (stepId != null) {
					"$RAW_DEBUG_NAME_PREFIX ${event.name} (step $stepId)"
				} else {
					"$RAW_DEBUG_NAME_PREFIX ${event.name}"
				}
			}
		}
	}
}
