/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.eventMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.*
import hollybike.api.types.event.*
import hollybike.api.types.event.participation.TUserJourney
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.checkContentType
import hollybike.api.utils.get
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.patch
import io.ktor.server.resources.post
import io.ktor.server.resources.put
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.utils.io.jvm.javaio.toInputStream

class EventController(
	application: Application,
	private val eventService: EventService,
	private val eventParticipationService: EventParticipationService,
	private val associationService: AssociationService,
	private val userService: UserService,
	private val userEventPositionService: UserEventPositionService,
	private val expenseService: ExpenseService,
) {
	private val mapper = eventMapper + associationMapper + userMapper

	init {
		application.routing {
			authenticate {
				getAllEvents()
				getFutureEvents()
				getParticipatingEvents()
				getArchivedEvents()
				getEventDetails()
				getEventExpenseReport()
				getEvent()
				createEvent()
				getJourneySteps()
				addJourneyStepToEvent()
				removeJourneyStepFromEvent()
				renameJourneyStep()
				setCurrentJourneyStep()
				updateEvent()
				uploadEventImage()
				deleteEvent()
				cancelEvent()
				scheduleEvent()
				finishEvent()
				pendEvent()
				getMetaData()
				getParticipantJourney()
				resetEventJourney()
				terminateEventJourney()
				resetEventJourneyForStep()
				terminateEventJourneyForStep()
			}
		}
	}

	private fun Route.getAllEvents() {
		get<Events> {
			val params = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getAllEvents(call.user, params)
			val distances = eventService.getCurrentJourneyDistances(events.map { it.id.value })
			val totalEvents = eventService.countAllEvents(call.user, params)

			call.respond(TLists(events.map { TEventPartial(it, distances[it.id.value]) }, params, totalEvents))
		}
	}

	private fun Route.getFutureEvents() {
		get<Events.Future> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getFutureEvents(call.user, searchParam)
			val distances = eventService.getCurrentJourneyDistances(events.map { it.id.value })
			val totalEvents = eventService.countFutureEvents(call.user, searchParam)

			call.respond(TLists(events.map { TEventPartial(it, distances[it.id.value]) }, searchParam, totalEvents))
		}
	}

	private fun Route.getParticipatingEvents() {
		get<Events.Participating> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)
			val participantColumn = searchParam.mapper["participant_id"]

			if (participantColumn != null && searchParam.filter.none { it.column == participantColumn }) {
				searchParam.filter.add(
					Filter(
						column = participantColumn,
						value = call.user.id.value.toString(),
						mode = FilterMode.EQUAL
					)
				)
			}

			val events = eventService.getParticipatingEvents(call.user, searchParam)
			val distances = eventService.getCurrentJourneyDistances(events.map { it.id.value })
			val totalEvents = eventService.countParticipatingEvents(call.user, searchParam)

			call.respond(TLists(events.map { TEventPartial(it, distances[it.id.value]) }, searchParam, totalEvents))
		}
	}

	private fun Route.getArchivedEvents() {
		get<Events.Archived> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getArchivedEvents(call.user, searchParam)
			val distances = eventService.getCurrentJourneyDistances(events.map { it.id.value })
			val totalEvents = eventService.countArchivedEvents(call.user, searchParam)

			call.respond(TLists(events.map { TEventPartial(it, distances[it.id.value]) }, searchParam, totalEvents))
		}
	}

	private fun Route.getEventDetails() {
		get<Events.Id.Details> { id ->
			val (event, callerParticipation, journeySteps) = eventService.getEventWithParticipation(call.user, id.details.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "L'evenement n'a pas ete trouve")
			val callerStepJourneys = callerParticipation?.let {
				userEventPositionService.getCallerStepJourneys(call.user, event, journeySteps)
			}

			val eventExpenses = callerParticipation?.let {
				expenseService.getEventExpense(it, call.user, event)
			}

			eventParticipationService.getParticipationsPreview(call.user, id.details.id)
				.onSuccess { (participants, participantsCount) ->
					call.respond(
						TEventDetails(
							event,
							callerParticipation,
							journeySteps,
							callerStepJourneys,
							participants,
							participantsCount,
							eventExpenses,
							userEventPositionService.getIsBetterThanForUserJourney(
								callerParticipation?.journey
							)
						)
					)
				}.onFailure {
					eventService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.getEventExpenseReport() {
		get<Events.Id.Expenses.Report> { report ->
			val event = eventService.getEvent(call.user, report.expenses.id.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "L'évènement n'existe pas")
			}

			val callerParticipation = eventParticipationService.getParticipation(call.user, event.id.value).getOrElse {
				return@get eventService.handleEventExceptions(it, call)
			}

			val expenses = expenseService.getEventExpense(callerParticipation, call.user, event) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Les dépenses n'ont pas été trouvé")
			}

			call.respondOutputStream(ContentType.Text.CSV) {
				write("name,description,amount,date\n".toByteArray(Charsets.UTF_8))
				expenses.forEach { e ->
					write("${e.name},\"${e.description ?: ""}\",${e.amount},${e.date}\n".toByteArray(Charsets.UTF_8))
				}
			}
		}
	}

	private fun Route.getEvent() {
		get<Events.Id> { id ->
			val event = eventService.getEvent(call.user, id.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "L'évènement n'a pas été trouvé")

			call.respond(TEvent(event, expenseService.authorizeBudget(call.user, event)))
		}
	}

	private fun Route.createEvent() {
		post<Events> {
			val newEvent = call.receive<TCreateEvent>()

			val association = newEvent.association?.let {
				associationService.getById(call.user, newEvent.association)
			} ?: call.user.association

			eventService.createEvent(
				call.user,
				newEvent.name,
				newEvent.description,
				newEvent.startDate,
				newEvent.endDate,
				association
			).onSuccess {
				call.respond(HttpStatusCode.Created, TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.getJourneySteps() {
		get<Events.Id.JourneySteps> { data ->
			eventService.getEventJourneySteps(call.user, data.steps.id).onSuccess { steps ->
				call.respond(HttpStatusCode.OK, TEventJourneyStepsState(steps))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.addJourneyStepToEvent() {
		post<Events.Id.JourneySteps> { data ->
			val body = call.receive<TCreateEventJourneyStep>()
			eventService.addJourneyStepToEvent(
				call.user,
				data.steps.id,
				body.journeyId,
				body.name,
				body.position
			).onSuccess { steps ->
				call.respond(HttpStatusCode.OK, TEventJourneyStepsState(steps))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.removeJourneyStepFromEvent() {
		delete<Events.Id.JourneySteps.Step> { data ->
			eventService.removeJourneyStepFromEvent(
				call.user,
				data.journeySteps.steps.id,
				data.stepId
			).onSuccess { steps ->
				call.respond(HttpStatusCode.OK, TEventJourneyStepsState(steps))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.renameJourneyStep() {
		patch<Events.Id.JourneySteps.Step> { data ->
			val body = call.receive<TUpdateEventJourneyStep>()
			eventService.renameJourneyStep(
				call.user,
				data.journeySteps.steps.id,
				data.stepId,
				body.name
			).onSuccess { steps ->
				call.respond(HttpStatusCode.OK, TEventJourneyStepsState(steps))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.setCurrentJourneyStep() {
		patch<Events.Id.JourneySteps.Step.Current> { data ->
			eventService.setCurrentJourneyStep(
				call.user,
				data.step.journeySteps.steps.id,
				data.step.stepId
			).onSuccess { steps ->
				call.respond(HttpStatusCode.OK, TEventJourneyStepsState(steps))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.updateEvent() {
		put<Events.Id> { id ->
			val updateEvent = call.receive<TUpdateEvent>()

			eventService.updateEvent(
				call.user,
				id.id,
				updateEvent.name,
				updateEvent.description,
				updateEvent.startDate,
				updateEvent.endDate,
				updateEvent.budget
			).onSuccess {
				call.respond(HttpStatusCode.OK, TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.cancelEvent() {
		patch<Events.Id.Cancel> { id ->
			eventService.updateEventStatus(call.user, id.cancel.id, EEventStatus.Cancelled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.scheduleEvent() {
		patch<Events.Id.Schedule> { id ->
			eventService.updateEventStatus(call.user, id.schedule.id, EEventStatus.Scheduled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.finishEvent() {
		patch<Events.Id.Finish> { id ->
			eventService.updateEventStatus(call.user, id.finish.id, EEventStatus.Finished).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.pendEvent() {
		patch<Events.Id.Pend> { id ->
			eventService.updateEventStatus(call.user, id.pend.id, EEventStatus.Pending).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.uploadEventImage() {
		patch<Events.Id.UploadImage> { data ->
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = checkContentType(image).getOrElse {
				return@patch call.respond(HttpStatusCode.BadRequest, it.message!!)
			}

			eventService.uploadEventImage(
				call.user,
				data.image.id,
				image.provider().toInputStream().readBytes(),
				contentType.toString()
			).onSuccess {
				call.respond(TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.deleteEvent() {
		delete<Events.Id> { id ->
			eventService.deleteEvent(call.user, id.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.getMetaData() {
		get<Events.MetaData>(EUserScope.Admin) {
			call.respond(mapper.getMapperData())
		}
	}

	private fun Route.terminateEventJourney() {
		post<Events.Id.Participations.Me.Journey.Terminate> { it ->
			val event = eventService.getEvent(call.user, it.journey.me.participations.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@post
			}

			userEventPositionService.getUserJourneyFromEvent(call.user, event)?.let {
				call.respond(HttpStatusCode.Conflict, "Trajet déjà terminé")
			} ?: run {
				runCatching {
					userEventPositionService.terminateUserJourney(call.user, event)
				}.onSuccess { journey ->
					val (eventName, stepName) = userEventPositionService.getJourneyEventAndStepNames(journey)
					call.respond(
						HttpStatusCode.Created,
						TUserJourney(
							journey,
							userEventPositionService.getIsBetterThanForUserJourney(journey),
							eventName,
							stepName
						)
					)
				}.onFailure {
					eventService.handleEventExceptions(it, call)
				}
			}
		}
	}

	private fun Route.terminateEventJourneyForStep() {
		post<Events.Id.JourneySteps.Step.Participations.Me.Journey.Terminate> { it ->
			val eventId = it.journey.me.participations.step.journeySteps.steps.id
			val stepId = it.journey.me.participations.step.stepId

			val event = eventService.getEvent(call.user, eventId) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@post
			}

			userEventPositionService.getUserJourneyFromEventStep(call.user, event, stepId)?.let {
				call.respond(HttpStatusCode.Conflict, "Trajet déjà terminé")
			} ?: run {
				runCatching {
					userEventPositionService.terminateUserJourney(call.user, event, stepId)
				}.onSuccess { journey ->
					val (eventName, stepName) = userEventPositionService.getJourneyEventAndStepNames(journey)
					call.respond(
						HttpStatusCode.Created,
						TUserJourney(
							journey,
							userEventPositionService.getIsBetterThanForUserJourney(journey),
							eventName,
							stepName
						)
					)
				}.onFailure {
					eventService.handleEventExceptions(it, call)
				}
			}
		}
	}

	private fun Route.resetEventJourney() {
		patch<Events.Id.Participations.Me.Journey.Reset> {
			val event = eventService.getEvent(call.user, it.journey.me.participations.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@patch
			}

			userEventPositionService.removeUserJourneyFromEvent(call.user, event)

			call.respond(HttpStatusCode.NoContent)
		}
	}

	private fun Route.resetEventJourneyForStep() {
		patch<Events.Id.JourneySteps.Step.Participations.Me.Journey.Reset> {
			val eventId = it.journey.me.participations.step.journeySteps.steps.id
			val stepId = it.journey.me.participations.step.stepId

			val event = eventService.getEvent(call.user, eventId) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@patch
			}

			runCatching {
				userEventPositionService.removeUserJourneyFromEventStep(call.user, event, stepId)
			}.onSuccess {
				call.respond(HttpStatusCode.NoContent)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.getParticipantJourney() {
		get<Events.Id.Participations.User.Journey> {
			val event = eventService.getEvent(call.user, it.user.user.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@get
			}
			val user = userService.getUser(call.user, it.user.userId) ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
				return@get
			}

			val journey = userEventPositionService.getUserJourneyFromEvent(user, event) ?: run {
				call.respond(HttpStatusCode.NotFound, "Trajet non trouvé")
				return@get
			}

			call.respond(
				TUserJourney(
					journey,
					userEventPositionService.getIsBetterThanForUserJourney(journey)
				)
			)
		}
	}
}





