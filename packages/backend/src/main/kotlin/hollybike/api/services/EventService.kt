/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import org.jetbrains.exposed.v1.jdbc.*
import hollybike.api.database.addtime
import hollybike.api.database.now
import hollybike.api.exceptions.*
import hollybike.api.repository.*
import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.participation.EEventRole
import hollybike.api.types.event.EEventStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.DeleteEventNotification
import hollybike.api.types.websocket.EventStatusUpdateNotification
import hollybike.api.types.websocket.NewEventNotification
import hollybike.api.types.websocket.UpdateEventNotification
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import kotlinx.coroutines.runBlocking
import kotlin.time.Clock
import kotlin.time.Instant
import org.jetbrains.exposed.v1.dao.load
import org.jetbrains.exposed.v1.dao.with
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.greaterEq
import org.jetbrains.exposed.v1.core.less
import org.jetbrains.exposed.v1.core.neq
import org.jetbrains.exposed.v1.jdbc.transactions.suspendTransaction
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import java.util.*
import kotlin.time.Duration.Companion.hours

class EventService(
	private val db: Database,
	private val storageService: StorageService,
	private val notificationService: NotificationService
) {
	private fun checkEventTextFields(name: String, description: String?): Result<Unit> {
		if (name.isBlank()) {
			return Result.failure(InvalidEventNameException("Le nom de l'événement ne peut pas être vide"))
		}

		if (name.length > 100) {
			return Result.failure(InvalidEventNameException("Le nom de l'événement ne peut pas dépasser 100 caractères"))
		}

		if (description != null && description.isBlank()) {
			return Result.failure(InvalidEventDescriptionException("La description de l'événement ne peut pas être vide"))
		}

		if (description != null && description.length > 1000) {
			return Result.failure(InvalidEventDescriptionException("La description de l'événement ne peut pas dépasser 1000 caractères"))
		}

		return Result.success(Unit)
	}

	private fun checkEventInputDates(
		startDate: Instant,
		endDate: Instant? = null
	): Result<Unit> {
		if (endDate == null) {
			return Result.success(Unit)
		}

		if (startDate >= endDate) {
			return Result.failure(InvalidDateException("La date de fin doit être après la date de début"))
		}

		return Result.success(Unit)
	}

	private fun findEventIfOrganizer(eventId: Int, user: User): Result<Event> {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(user)
		}.with(Event::owner, Event::participants, EventParticipation::user, Event::association).firstOrNull()
			?: return Result.failure(
				EventNotFoundException("Event $eventId introuvable")
			)

		if (user.scope === EUserScope.Root) {
			return Result.success(event)
		}

		val participation = event.participants.find { it.user.id == user.id }
			?: return Result.failure(EventActionDeniedException("Vous ne participez pas à cet événement"))

		if (participation.role != EEventRole.Organizer) {
			return Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier l'événement"))
		}

		return Result.success(event)
	}

	fun eventUserCondition(caller: User): Op<Boolean> {
		return if (caller.scope !== EUserScope.Root) {
			(
				(((Events.owner eq caller.id) and (Events.status eq EEventStatus.Pending.value)) or
					(Events.status neq EEventStatus.Pending.value)) and
					(Events.association eq caller.association.id))
		} else {
			object : Op<Boolean>() {
				override fun toQueryBuilder(queryBuilder: QueryBuilder) {
					queryBuilder.append("true")
				}
			}
		}
	}

	private fun eventsQuery(caller: User, searchParam: SearchParam, pagination: Boolean = true): Query {
		val participation = EventParticipations.alias("participation")
		val participant = Users.alias("participant")

		val eventsQuery = Events.innerJoin(
			Associations,
			{ association },
			{ Associations.id }
		).innerJoin(
			Users,
			{ Events.owner },
			{ Users.id }
		).leftJoin(
			participation,
			{ participation[EventParticipations.event] },
			{ Events.id },
		).leftJoin(
			participant,
			{ participant[Users.id] },
			{ participation[EventParticipations.user] },
			{ participation[EventParticipations.isJoined] eq true }
		).select(Events.columns + Users.columns + Associations.columns)
			.applyParam(searchParam, pagination).withDistinct()

		if (caller.scope != EUserScope.Root) {
			eventsQuery.andWhere {
				eventUserCondition(caller)
			}
		}

		return eventsQuery
	}

	private fun participatingEventsQuery(caller: User, searchParam: SearchParam, pagination: Boolean = true): Query {
		val participation = EventParticipations.alias("participation")
		val participant = Users.alias("participant")
		val searchParamWithoutSort = searchParam.copy(sort = emptyList())
		val sortBucket = participatingEventSortBucket()
		val upcomingSortDate = participatingUpcomingSortDate()
		val pastSortDate = participatingPastSortDate()

		val eventsQuery = Events.innerJoin(
			Associations,
			{ association },
			{ Associations.id }
		).innerJoin(
			Users,
			{ Events.owner },
			{ Users.id }
		).leftJoin(
			participation,
			{ participation[EventParticipations.event] },
			{ Events.id },
		).leftJoin(
			participant,
			{ participant[Users.id] },
			{ participation[EventParticipations.user] },
			{ participation[EventParticipations.isJoined] eq true }
		).select(Events.columns + Users.columns + Associations.columns + listOf(sortBucket, upcomingSortDate, pastSortDate))
			.applyParam(searchParamWithoutSort, pagination)
			.withDistinct()
			.orderBy(
				sortBucket to SortOrder.ASC,
				upcomingSortDate to SortOrder.ASC,
				pastSortDate to SortOrder.DESC,
				Events.id to SortOrder.ASC
			)

		if (caller.scope != EUserScope.Root) {
			eventsQuery.andWhere {
				Events.association eq caller.association.id
			}
		}

		return eventsQuery
	}

	private fun participatingEventSortBucket() = object : ExpressionWithColumnType<Int>() {
		override val columnType: IColumnType<Int>
			get() = IntegerColumnType()

		override fun toQueryBuilder(queryBuilder: QueryBuilder) {
			queryBuilder.append("CASE WHEN ")
			queryBuilder.append(
				Events.status,
				" NOT IN (",
				EEventStatus.Cancelled.value.toString(),
				", ",
				EEventStatus.Finished.value.toString(),
				")"
			)
			queryBuilder.append(" AND (")
			queryBuilder.append(Events.startDateTime, " >= ", now())
			queryBuilder.append(" OR (")
			queryBuilder.append(Events.status, " = ", EEventStatus.Scheduled.value.toString())
			queryBuilder.append(" AND ((")
			queryBuilder.append(Events.endDateTime, " IS NOT NULL AND ", Events.endDateTime, " >= ", now())
			queryBuilder.append(") OR (")
			queryBuilder.append(Events.endDateTime, " IS NULL AND ", addtime(Events.startDateTime, 4.hours), " >= ", now())
			queryBuilder.append(")))")
			queryBuilder.append(") THEN 0 ELSE 1 END")
		}
	}

	private fun participatingUpcomingSortDate() = object : Expression<Instant?>() {
		override fun toQueryBuilder(queryBuilder: QueryBuilder) {
			queryBuilder.append("CASE WHEN ", participatingEventSortBucket(), " = 0 THEN ", Events.startDateTime, " ELSE NULL END")
		}
	}

	private fun participatingPastSortDate() = object : Expression<Instant?>() {
		override fun toQueryBuilder(queryBuilder: QueryBuilder) {
			queryBuilder.append(
				"CASE WHEN ",
				participatingEventSortBucket(),
				" = 1 THEN COALESCE(",
				Events.endDateTime,
				", ",
				Events.startDateTime,
				") ELSE NULL END"
			)
		}
	}

	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) {
		when (exception) {
			is EventNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Évènement inconnu"
			)

			is EventActionDeniedException -> call.respond(
				HttpStatusCode.Forbidden,
				exception.message ?: "Action denied"
			)

			is InvalidDateException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Date invalide"
			)

			is InvalidEventNameException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Nom de l'évènement vide ou invalide"
			)

			is InvalidEventDescriptionException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Description de l'événement invalide"
			)

			is BadRequestException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Requete invalide"
			)
			is AlreadyParticipatingToEventException -> call.respond(
				HttpStatusCode.Conflict,
				exception.message ?: "Vous participer déjà à l'événement"
			)

			is NotParticipatingToEventException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Vous ne participez pas à l'évènements"
			)

			is JourneyNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Trajet introuvable"
			)

			is EventJourneyStepNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Étape introuvable"
			)

			is DuplicateEventJourneyStepException -> call.respond(
				HttpStatusCode.Conflict,
				exception.message ?: "Cette étape existe déjà"
			)

			else -> {
				exception.printStackTrace()
				call.respond(HttpStatusCode.InternalServerError, "Internal server error")
			}
		}
	}

	fun getAllEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			eventsQuery(caller, searchParam)
		).with(Event::owner, Event::association, Event::participants).toList()
	}

	fun countAllEvents(caller: User, searchParam: SearchParam): Long = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).count()
	}

	private fun futureEventsCondition(): Op<Boolean> {
		return (
			((Events.startDateTime greaterEq now()) or
				((Events.endDateTime neq null) and (Events.endDateTime greaterEq now())) or
				((Events.endDateTime eq null) and (addtime(Events.startDateTime, 4.hours) greaterEq now())))
			and
				(Events.status neq EEventStatus.Finished.value)
		)
	}

	fun getFutureEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			eventsQuery(caller, searchParam).andWhere { futureEventsCondition() }
		).with(Event::owner, Event::association, Event::participants).toList()
	}

	fun countFutureEvents(caller: User, searchParam: SearchParam): Long = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).andWhere { futureEventsCondition() }.count()
	}

	fun getParticipatingEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			participatingEventsQuery(caller, searchParam)
		).with(Event::owner, Event::association, Event::participants).toList()
	}

	fun countParticipatingEvents(caller: User, searchParam: SearchParam): Long = transaction(db) {
		participatingEventsQuery(caller, searchParam, pagination = false).count()
	}

	private fun archivedEventsCondition(): Op<Boolean> {
		return (Events.status eq EEventStatus.Finished.value) or
			((Events.startDateTime less now()) and
				(((Events.endDateTime neq null) and (Events.endDateTime less now())) or
					((Events.endDateTime eq null) and (addtime(Events.startDateTime, 4.hours) less now()))))
	}

	fun getArchivedEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			eventsQuery(caller, searchParam).andWhere { archivedEventsCondition() }
		).with(Event::owner, Event::association, Event::participants).toList()
	}

	fun countArchivedEvents(caller: User, searchParam: SearchParam): Long = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).andWhere { archivedEventsCondition() }.count()
	}

	fun getEventWithParticipation(caller: User, id: Int): Triple<Event, EventParticipation?, List<EventJourneyStep>>? = transaction(db) {
		val eventRow = Events.innerJoin(
			Users,
			{ owner },
			{ Users.id }
		).leftJoin(
			EventParticipations,
			{ Events.id },
			{ event },
			{ (EventParticipations.user eq caller.id) and (EventParticipations.isJoined eq true) }
		).selectAll().where {
			Events.id eq id and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction null

		val event = Event.wrapRow(eventRow).load(
			Event::owner,
			Event::association,
		)
		val callerParticipation = eventRow.getOrNull(EventParticipations.id)?.let {
			EventParticipation.wrapRow(eventRow).load(
				EventParticipation::user,
				EventParticipation::journey,
				EventParticipation::recordedPositions
			)
		}
		val steps = getEventJourneyStepsForEvent(event.id.value)
		if (callerParticipation != null && callerParticipation.journey == null && steps.isEmpty()) {
			val fallbackJourney = UserJourney.find {
				(UsersJourneys.user eq callerParticipation.user.id) and
					(UsersJourneys.event eq event.id) and
					UsersJourneys.eventJourneyStep.isNull()
			}.orderBy(UsersJourneys.createdAt to SortOrder.DESC).limit(1).firstOrNull()

			if (fallbackJourney != null) {
				callerParticipation.journey = fallbackJourney
			}
		}

		Triple(event, callerParticipation, steps)
	}

	private fun getEventJourneyStepsForEvent(eventId: Int): List<EventJourneyStep> {
		return EventJourneyStep.find {
			EventJourneySteps.event eq eventId
		}.with(
			EventJourneyStep::journey,
			Journey::start,
			Journey::end,
			Journey::destination
		).sortedBy { it.position }
	}

	private fun syncLegacyParticipationJourneysForCurrentStep(eventId: Int) {
		val currentStep = EventJourneyStep.find {
			(EventJourneySteps.event eq eventId) and (EventJourneySteps.isCurrent eq true)
		}.limit(1).firstOrNull()
		val eventEntity = Event.findById(eventId) ?: return

		EventParticipation.find { EventParticipations.event eq eventId }.forEach { participation ->
			val mappedJourney = currentStep?.let { step ->
				EventParticipationStepJourney.find {
					(EventParticipationStepJourneys.participation eq participation.id) and
						(EventParticipationStepJourneys.step eq step.id)
				}.limit(1).firstOrNull()?.journey
			} ?: UserJourney.find {
				(UsersJourneys.user eq participation.user.id) and
					(UsersJourneys.event eq eventEntity.id) and
					UsersJourneys.eventJourneyStep.isNull()
			}.orderBy(UsersJourneys.createdAt to SortOrder.DESC).limit(1).firstOrNull()

			if (currentStep == null && mappedJourney != null && mappedJourney.eventJourneyStep != null) {
				participation.journey = null
				return@forEach
			}

			participation.journey = mappedJourney
		}
	}

	private fun linkUnsteppedJourneysToCreatedFirstStep(event: Event, createdStep: EventJourneyStep) {
		EventParticipation.find {
			(EventParticipations.event eq event.id) and (EventParticipations.isJoined eq true)
		}.forEach { participation ->
			val journey = participation.journey ?: return@forEach

			if (journey.event?.id?.value != event.id.value) {
				return@forEach
			}

			if (journey.eventJourneyStep != null) {
				return@forEach
			}

			journey.eventJourneyStep = createdStep
			journey.name = "${event.name} x ${createdStep.name?.takeIf { it.isNotBlank() } ?: "Étape ${createdStep.position}"}"

			val existing = EventParticipationStepJourney.find {
				(EventParticipationStepJourneys.participation eq participation.id) and
					(EventParticipationStepJourneys.step eq createdStep.id)
			}.limit(1).firstOrNull()

			if (existing == null) {
				EventParticipationStepJourney.new {
					this.participation = participation
					this.step = createdStep
					this.journey = journey
				}
			}
		}
	}

	fun getEventJourneySteps(caller: User, eventId: Int): Result<List<EventJourneyStep>> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(
			EventNotFoundException("Event $eventId introuvable")
		)
		Result.success(getEventJourneyStepsForEvent(event.id.value))
	}

	fun getCurrentJourneyDistances(eventIds: List<Int>): Map<Int, Int?> = transaction(db) {
		if (eventIds.isEmpty()) {
			return@transaction emptyMap()
		}

		val steps = EventJourneyStep.find {
			EventJourneySteps.event inList eventIds
		}.with(EventJourneyStep::journey)

		val summedDistancesByEvent = steps.groupBy { it.event.id.value }.mapValues { (_, eventSteps) ->
			var hasDistance = false
			val total = eventSteps.sumOf { step ->
				val distance = step.journey.totalDistance
				if (distance != null) {
					hasDistance = true
					distance
				} else {
					0
				}
			}
			if (hasDistance) total else null
		}

		eventIds.associateWith { summedDistancesByEvent[it] }
	}

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner, Event::participants, EventParticipation::user, Event::association).firstOrNull()
			?: return@transaction null
	}

	fun createEvent(
		caller: User,
		name: String,
		description: String?,
		startDate: Instant,
		endDate: Instant?,
		association: Association
	): Result<Event> {
		checkEventInputDates(startDate, endDate).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
			val createdEvent = Event.new {
				owner = caller
				this.association = association
				this.name = name
				this.description = description
				this.startDateTime = startDate
				this.endDateTime = endDate
				status = EEventStatus.Pending
			}

			EventParticipation.new {
				user = caller
				event = createdEvent
				role = EEventRole.Organizer
			}

			Result.success(
				createdEvent.load(Event::participants)
			)
		}
	}

	fun addJourneyStepToEvent(
		caller: User,
		eventId: Int,
		journeyId: Int,
		name: String?,
		position: Int?
	): Result<List<EventJourneyStep>> = transaction(db) {
		val event = findEventIfOrganizer(eventId, caller).getOrElse { return@transaction Result.failure(it) }
		val journey = Journey.find { Journeys.id eq journeyId }.firstOrNull() ?: return@transaction Result.failure(
			JourneyNotFoundException("Trajet $journeyId introuvable")
		)

		val currentSteps = getEventJourneyStepsForEvent(event.id.value).toMutableList()
		if (currentSteps.any { it.journey.id.value == journeyId }) {
			return@transaction Result.failure(DuplicateEventJourneyStepException("Ce trajet est déjà lié à cet événement"))
		}

		val normalizedName = name?.trim()?.takeIf { it.isNotBlank() }

		val insertPosition = when (position) {
			null -> currentSteps.size + 1
			else -> {
				if (position < 1 || position > currentSteps.size + 1) {
					return@transaction Result.failure(BadRequestException("Position d'étape invalide"))
				}
				position
			}
		}

		currentSteps.filter { it.position >= insertPosition }.forEach { it.position += 1 }

		val createdStep = EventJourneyStep.new {
			this.event = event
			this.journey = journey
			this.name = normalizedName ?: "Étape $insertPosition"
			this.position = insertPosition
			this.isCurrent = currentSteps.isEmpty()
		}
		currentSteps.filter { it.name.isNullOrBlank() }.forEach { existingStep ->
			existingStep.name = "Étape ${existingStep.position}"
		}
		if (currentSteps.isEmpty()) {
			linkUnsteppedJourneysToCreatedFirstStep(event, createdStep)
		}

		syncLegacyParticipationJourneysForCurrentStep(event.id.value)

		Result.success(getEventJourneyStepsForEvent(event.id.value))
	}

	fun removeJourneyStepFromEvent(
		caller: User,
		eventId: Int,
		stepId: Int
	): Result<List<EventJourneyStep>> = transaction(db) {
		val event = findEventIfOrganizer(eventId, caller).getOrElse { return@transaction Result.failure(it) }

		val step = EventJourneyStep.find {
			(EventJourneySteps.id eq stepId) and (EventJourneySteps.event eq eventId)
		}.firstOrNull() ?: return@transaction Result.failure(
			EventJourneyStepNotFoundException("�tape $stepId introuvable")
		)
		val removedMappings = EventParticipationStepJourney.find {
			EventParticipationStepJourneys.step eq step.id
		}.toList()
		val remainingCount =
			EventJourneyStep.count(
				(EventJourneySteps.event eq eventId) and (EventJourneySteps.id neq step.id)
			).toInt()

		removedMappings.forEach { mapping ->
			val candidateJourney = mapping.journey
			val participation = mapping.participation

			if (remainingCount > 0) {
				candidateJourney.event = null
				candidateJourney.eventJourneyStep = null
			} else {
				val hasOtherNoStepJourney = UserJourney.find {
					(UsersJourneys.user eq participation.user.id) and
						(UsersJourneys.event eq event.id) and
						UsersJourneys.eventJourneyStep.isNull() and
						(UsersJourneys.id neq candidateJourney.id)
				}.limit(1).firstOrNull() != null

				if (hasOtherNoStepJourney) {
					candidateJourney.event = null
					candidateJourney.eventJourneyStep = null
				} else {
					candidateJourney.event = event
					candidateJourney.eventJourneyStep = null
				}
			}

			mapping.delete()
		}

		val removedPosition = step.position
		val wasCurrent = step.isCurrent
		step.delete()

		val remaining = getEventJourneyStepsForEvent(eventId).toMutableList()
		remaining.filter { it.position > removedPosition }.forEach { it.position -= 1 }

		if (wasCurrent && remaining.isNotEmpty()) {
			remaining.forEach { it.isCurrent = false }
			val nextStep = remaining.firstOrNull { it.position == removedPosition }
			if (nextStep != null) {
				nextStep.isCurrent = true
			} else {
				remaining.maxByOrNull { it.position }?.let { it.isCurrent = true }
			}
		}

		syncLegacyParticipationJourneysForCurrentStep(eventId)

		Result.success(getEventJourneyStepsForEvent(eventId))
	}

	fun renameJourneyStep(
		caller: User,
		eventId: Int,
		stepId: Int,
		name: String?
	): Result<List<EventJourneyStep>> = transaction(db) {
		findEventIfOrganizer(eventId, caller).getOrElse { return@transaction Result.failure(it) }

		val step = EventJourneyStep.find {
			(EventJourneySteps.id eq stepId) and (EventJourneySteps.event eq eventId)
		}.firstOrNull() ?: return@transaction Result.failure(
			EventJourneyStepNotFoundException("Étape $stepId introuvable")
		)

		val normalizedName = name?.trim()?.takeIf { it.isNotBlank() }
		step.name = normalizedName
		Result.success(getEventJourneyStepsForEvent(eventId))
	}

	fun setCurrentJourneyStep(
		caller: User,
		eventId: Int,
		stepId: Int
	): Result<List<EventJourneyStep>> = transaction(db) {
		findEventIfOrganizer(eventId, caller).getOrElse { return@transaction Result.failure(it) }

		val step = EventJourneyStep.find {
			(EventJourneySteps.id eq stepId) and (EventJourneySteps.event eq eventId)
		}.firstOrNull() ?: return@transaction Result.failure(
			EventJourneyStepNotFoundException("Étape $stepId introuvable")
		)

		EventJourneyStep.find { EventJourneySteps.event eq eventId }.forEach { it.isCurrent = false }
		step.isCurrent = true
		syncLegacyParticipationJourneysForCurrentStep(eventId)

		Result.success(getEventJourneyStepsForEvent(eventId))
	}

	suspend fun updateEvent(
		caller: User,
		eventId: Int,
		name: String,
		description: String?,
		startDate: Instant,
		endDate: Instant?,
		budget: Int?
	): Result<Event> {
		checkEventInputDates(startDate, endDate).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
				findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }
				.onSuccess { event ->
					// Compare at minute precision because the web calendar input does
					// not expose seconds and may normalize them when untouched.
					val hasDateChanges =
						event.startDateTime.epochSeconds / 60 != startDate.epochSeconds / 60 ||
							event.endDateTime?.epochSeconds?.div(60) != endDate?.epochSeconds?.div(60)
					if (hasDateChanges) {
						val now = Clock.System.now()
						val computedStatus = EEventStatus.fromEvent(event)
						val isInProgress = computedStatus == EEventStatus.Now
						val isTerminated = event.status == EEventStatus.Cancelled || computedStatus == EEventStatus.Finished

						if (isInProgress) {
							return@transaction Result.failure(
								InvalidDateException("Impossible de modifier les dates d'un événement en cours")
							)
						}

						if (isTerminated) {
							val startDateInPast = startDate < now
							val endDateInPast = endDate?.let { it < now } == true
							if (startDateInPast || endDateInPast) {
								return@transaction Result.failure(
									InvalidDateException("Pour un événement terminé, les dates modifiées ne peuvent pas être dans le passé")
								)
							}
						}
					}

					event.apply {
						this.name = name
						this.description = description
						this.startDateTime = startDate
						this.endDateTime = endDate
						this.budget = budget
					}

					Result.success(event)
				}
		}.apply {
			onSuccess { event ->
				if(event.status != EEventStatus.Pending) {
					notificationService.send(
						event.participants.filter { it.role == EEventRole.Organizer }.map { it.user }.toList(),
						UpdateEventNotification(event),
						caller
					)
				}
			}
		}
	}

	suspend fun updateEventStatus(caller: User, eventId: Int, status: EEventStatus): Result<Unit> = suspendTransaction(db = db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@suspendTransaction Result.failure(EventNotFoundException("Event $eventId introuvable"))
		val currentStatus = EEventStatus.fromEvent(event)

		val participation = EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()
			?: return@suspendTransaction Result.failure(EventActionDeniedException("Vous ne participez pas à cet événement"))

		if (participation.role != EEventRole.Organizer) {
			return@suspendTransaction Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier le statut de l'événement"))
		}

		if (status == event.status) {
			return@suspendTransaction Result.failure(EventActionDeniedException("Event déjà ${status.name.lowercase()}"))
		}

		val oldStatus = event.status

		when (status) {
			EEventStatus.Pending -> {
				if (event.owner.id != caller.id) {
					return@suspendTransaction Result.failure(EventActionDeniedException("Seul le propriétaire peut mettre l'événement en attente"))
				}
			}

			EEventStatus.Cancelled -> {
				if (currentStatus == EEventStatus.Now) {
					return@suspendTransaction Result.failure(EventActionDeniedException("Impossible d'annuler un événement en cours"))
				}

				if (currentStatus != EEventStatus.Scheduled) {
					return@suspendTransaction Result.failure(EventActionDeniedException("Seul un événement planifié peut être annulé"))
				}
			}

			EEventStatus.Finished -> {
				if (currentStatus != EEventStatus.Scheduled && currentStatus != EEventStatus.Now) {
					return@suspendTransaction Result.failure(EventActionDeniedException("Seul un événement planifié ou en cours peut être terminé"))
				}
			}

			EEventStatus.Scheduled -> Unit
			EEventStatus.Now -> Unit
		}

		event.status = status

		if(status != EEventStatus.Pending && oldStatus != EEventStatus.Pending) {
			notificationService.send(event.participants.map { it.user }.toList(), EventStatusUpdateNotification(event, oldStatus), caller)
		} else if(oldStatus == EEventStatus.Pending && status == EEventStatus.Scheduled) {
			notificationService.sendToAssociation(caller.association.id.value, NewEventNotification(event), caller)
		}

		Result.success(Unit)
	}

	fun uploadEventImage(caller: User, eventId: Int, image: ByteArray, imageContentType: String): Result<Event> =
		transaction(db) {
			findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }.onSuccess { it ->
				try {
					it.image?.let {
						runBlocking { storageService.delete(it) }
					}
				} catch (e: Exception) {
					e.printStackTrace()
				}

				val uuid = UUID.randomUUID().toString()
				val path = "e/$eventId/i-$uuid"

				runBlocking {
					storageService.store(image, path, imageContentType)
				}

				it.image = path

				Result.success(it)
			}
		}

	suspend fun deleteEvent(caller: User, eventId: Int): Result<Unit> = suspendTransaction(db = db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@suspendTransaction Result.failure(EventNotFoundException("Event $eventId introuvable"))
		val currentStatus = EEventStatus.fromEvent(event)

		if (event.owner.id != caller.id) {
			return@suspendTransaction Result.failure(EventActionDeniedException("Seul le propriétaire peut supprimer l'événement"))
		}
		if (currentStatus == EEventStatus.Now) {
			return@suspendTransaction Result.failure(EventActionDeniedException("Impossible de supprimer un événement en cours"))
		}

		if(event.status == EEventStatus.Pending) {
			notificationService.send(event.participants.map { it.user }.toList(), DeleteEventNotification(event), caller)
		}

		event.image?.let {
			storageService.delete(it)
		}

		EventImage.find { EventImages.event eq event.id }.forEach {
			storageService.delete(it.path)
		}

		Expense.find { Expenses.event eq event.id }.forEach {
			it.proof?.let { proof ->
				storageService.delete(proof)
			}
		}

		// Keep check constraint valid during event deletion:
		// a journey step cannot remain set when event becomes null.
		UsersJourneys.update({ UsersJourneys.event eq event.id }) { stmt ->
			stmt[UsersJourneys.eventJourneyStep] = null
			stmt[UsersJourneys.event] = null
		}

		Result.success(event.delete())
	}
}






