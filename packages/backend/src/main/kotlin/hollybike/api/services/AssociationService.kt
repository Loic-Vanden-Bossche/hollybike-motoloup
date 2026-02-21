/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import hollybike.api.exceptions.*
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociationInsights
import hollybike.api.types.association.TEventMonthStatus
import hollybike.api.types.association.TInsightBucket
import hollybike.api.types.association.TInvitationFunnel
import hollybike.api.types.association.TJourneyAdoption
import hollybike.api.types.association.TOnboardingUpdate
import hollybike.api.types.event.EEventStatus
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.http.*
import kotlinx.datetime.TimeZone
import kotlinx.datetime.number
import kotlinx.datetime.toLocalDateTime
import org.jetbrains.exposed.v1.exceptions.ExposedSQLException
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.isNotNull
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import org.postgresql.util.PSQLException
import java.sql.BatchUpdateException
import kotlin.time.Clock

class AssociationService(
	private val db: Database,
	private val storageService: StorageService,
) {
	private fun authorizeUpdate(caller: User, association: Association) = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == association.id
		EUserScope.User -> false
	}

	private fun authorizeGet(caller: User, association: Association) = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == association.id
		EUserScope.User -> caller.association.id == association.id
	}

	private infix fun Association?.getIfAllowed(caller: User) = if(this != null && authorizeGet(caller, this)) this else null

	private fun checkAlreadyExistsException(e: ExposedSQLException): Boolean {
		val cause = when (e.cause) {
			is BatchUpdateException if (e.cause as BatchUpdateException).cause is PSQLException -> {
				(e.cause as BatchUpdateException).cause as PSQLException
			}

			is PSQLException -> {
				e.cause as PSQLException
			}

			else -> {
				return false
			}
		}

		return if (
			cause.serverErrorMessage?.constraint == "associations_name_uindex" &&
			cause.serverErrorMessage?.detail?.contains("already exists") == true
		) {
			true
		} else {
			e.printStackTrace()
			false
		}
	}

	suspend fun updateMyAssociationPicture(
		association: Association,
		image: ByteArray,
		contentType: ContentType
	): Association {
		val path = "a/${association.id}/p"
		storageService.store(image, path, contentType.contentType)
		transaction(db) { association.picture = path }

		return association
	}

	fun getAll(caller: User, searchParam: SearchParam): Result<List<Association>> = transaction(db) {
		if(caller.scope not EUserScope.Root) {
			return@transaction Result.failure(NotAllowedException())
		}
		Result.success(Association.wrapRows(Associations.selectAll().applyParam(searchParam)).toList())
	}

	fun countAssociations(caller: User, searchParam: SearchParam): Result<Long> = transaction(db) {
		if(caller.scope not EUserScope.Root) {
			return@transaction Result.failure(NotAllowedException())
		}
		Result.success(Associations.selectAll().applyParam(searchParam, false).count())
	}

	fun getById(caller: User, id: Int): Association? = transaction(db) {
		Association.findById(id) getIfAllowed caller
	}

	fun createAssociation(name: String): Result<Association> {
		return try {
			transaction(db) {
				Result.success(
					Association.new {
						this.name = name
					}
				)
			}
		} catch (e: ExposedSQLException) {
			if (checkAlreadyExistsException(e)) {
				return Result.failure(AssociationAlreadyExists())
			}

			return Result.failure(e)
		}
	}

	fun updateAssociation(id: Int, name: String?, status: EAssociationsStatus?): Result<Association> {
		return try {
			transaction {
				val association = Association.findById(id) ?: run {
					return@transaction Result.failure(AssociationNotFound("Association not found"))
				}
				name?.let { association.name = it }
				status?.let { association.status = it }

				Result.success(association)
			}
		} catch (e: ExposedSQLException) {
			if (checkAlreadyExistsException(e)) {
				return Result.failure(AssociationAlreadyExists())
			}

			return Result.failure(e)
		}
	}

	fun updateAssociationOnboarding(caller: User, association: Association, update: TOnboardingUpdate): Result<Association> {
		if(!authorizeUpdate(caller, association)) {
			return Result.failure(NotAllowedException())
		}
		return transaction(db) {
			update.updateDefaultUser?.let { association.updateDefaultUser = it }
			update.updateAssociation?.let {
				if(it && !association.updateDefaultUser) {
					return@transaction Result.failure(AssociationOnboardingUserNotEditedException())
				}
				association.updateAssociation = it
			}
			update.createInvitation?.let {
				if(it && !association.updateAssociation) {
					return@transaction Result.failure(AssociationsOnboardingAssociationNotEditedException())
				}
				association.createInvitation = it
			}
			return@transaction Result.success(association)
		}
	}

	suspend fun updateAssociationPicture(id: Int, image: ByteArray, contentType: ContentType): Result<Association> {
		val path = "a/$id/p"
		storageService.store(image, path, contentType.contentType)

		return transaction {
			val association = Association.findById(id) ?: run {
				return@transaction Result.failure(AssociationNotFound("Association $id inconnue"))
			}
			association.picture = path

			Result.success(association)
		}
	}

	suspend fun deleteAssociation(id: Int): Result<Unit> {
		val association = transaction(db) {
			Association.findById(id)
		} ?: run {
			return Result.failure(AssociationNotFound("Association $id inconnue"))
		}

		transaction(db) {
			User.find { Users.association eq association.id.value }.forEach { it.delete() }

			association.delete()
		}

		association.picture?.let {
			storageService.delete(it)
		}

		return Result.success(Unit)
	}

	fun getAssociationUsersCount(caller: User, association: Association): Long? = transaction(db) {
		if(!authorizeGet(caller, association)) {
			null
		} else {
			User.count(Users.association eq association.id)
		}
	}

	fun getAssociationTotalEvent(caller: User, association: Association): Long? = transaction(db) {
		if(!authorizeGet(caller, association)) {
			null
		} else {
			Event.count(Events.association eq association.id)
		}
	}

	fun getAssociationTotalEventWithJourney(caller: User, association: Association): Long? = transaction(db) {
		if(!authorizeGet(caller, association)) {
			null
		} else {
			Event.count((Events.association eq association.id) and (Events.journey.isNotNull()))
		}
	}

	fun getAssociationTotalJourney(caller: User, association: Association): Long? = transaction(db) {
		if(!authorizeGet(caller, association)) {
			null
		} else {
			Journey.count(Journeys.association eq association.id)
		}
	}

	fun getAssociationInsights(caller: User, association: Association): TAssociationInsights? = transaction(db) {
		if (!authorizeGet(caller, association)) {
			return@transaction null
		}

		val now = Clock.System.now()

		val events = Event.find { Events.association eq association.id }.toList()
		val eventByMonth = events
			.groupBy { event ->
				val localDateTime = event.startDateTime.toLocalDateTime(TimeZone.UTC)
				Pair(localDateTime.year, localDateTime.month.number)
			}
			.toList()
			.sortedWith(compareBy({ it.first.first }, { it.first.second }))
			.flatMap { entry ->
				EEventStatus.entries.map { status ->
					TEventMonthStatus(
						year = entry.first.first,
						month = entry.first.second,
						status = status.name.lowercase(),
						count = entry.second.count { EEventStatus.fromEvent(it) == status }.toLong()
					)
				}
			}

		val invitations = Invitation.find { Invitations.association eq association.id }.toList()
		val invitationFunnel = TInvitationFunnel(
			totalCreated = invitations.size.toLong(),
			activeLinks = invitations.count { invitation ->
				val isExpired = invitation.expiration?.let { it < now } == true
				val isSaturated = invitation.maxUses != null && invitation.uses >= invitation.maxUses!!
				invitation.status == EInvitationStatus.Enabled && !isExpired && !isSaturated
			}.toLong(),
			usedLinks = invitations.count { it.uses > 0 }.toLong(),
			expiredLinks = invitations.count { invitation -> invitation.expiration?.let { it < now } == true }.toLong(),
			disabledLinks = invitations.count { it.status == EInvitationStatus.Disabled }.toLong(),
			saturatedLinks = invitations.count { invitation ->
				invitation.maxUses != null && invitation.uses >= invitation.maxUses!!
			}.toLong(),
		)

		val totalEvents = events.size.toLong()
		val totalEventsWithJourney = events.count { it.journey != null }.toLong()
		val totalJourneys = Journey.count(Journeys.association eq association.id)
		val journeyAdoption = TJourneyAdoption(
			totalEvents = totalEvents,
			totalEventsWithJourney = totalEventsWithJourney,
			totalJourneys = totalJourneys,
			adoptionRatePercent = if (totalEvents == 0L) 0.0 else (totalEventsWithJourney * 100.0) / totalEvents
		)

		val users = User.find { Users.association eq association.id }.toList()
		val usersByStatus = EUserStatus.entries.map { status ->
			TInsightBucket(
				key = status.name.lowercase(),
				count = users.count { it.status == status }.toLong()
			)
		}

		val userLastLoginBuckets = listOf(
			"0_7_days" to 0L,
			"8_30_days" to 0L,
			"31_90_days" to 0L,
			"91_plus_days" to 0L
		).toMutableList()

		users.forEach { user ->
			val daysSinceLastLogin = (now - user.lastLogin).inWholeDays
			val bucketIndex = when {
				daysSinceLastLogin <= 7 -> 0
				daysSinceLastLogin <= 30 -> 1
				daysSinceLastLogin <= 90 -> 2
				else -> 3
			}
			val current = userLastLoginBuckets[bucketIndex]
			userLastLoginBuckets[bucketIndex] = current.copy(second = current.second + 1)
		}

		TAssociationInsights(
			eventsByMonth = eventByMonth,
			invitationFunnel = invitationFunnel,
			journeyAdoption = journeyAdoption,
			usersByStatus = usersByStatus,
			userLastLoginBuckets = userLastLoginBuckets.map { TInsightBucket(it.first, it.second) }
		)
	}
}


