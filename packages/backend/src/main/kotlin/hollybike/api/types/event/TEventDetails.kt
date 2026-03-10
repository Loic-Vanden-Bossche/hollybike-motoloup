/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import hollybike.api.repository.Event
import hollybike.api.repository.EventJourneyStep
import hollybike.api.repository.EventParticipation
import hollybike.api.repository.Expense
import hollybike.api.types.event.participation.TEventCallerParticipation
import hollybike.api.types.event.participation.TEventCallerParticipationStepJourney
import hollybike.api.types.event.participation.TEventParticipation
import hollybike.api.types.expense.TExpense
import hollybike.api.types.journey.TJourneyPartial
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEventDetails(
	val event: TEvent,
	val callerParticipation: TEventCallerParticipation?,
	@SerialName("journey_steps")
	val journeySteps: List<TEventJourneyStep>,
	@SerialName("current_step_id")
	val currentStepId: Int?,
	@SerialName("current_journey")
	val currentJourney: TJourneyPartial?,
	val previewParticipants: List<TEventParticipation>,
	val previewParticipantsCount: Long,
	val expenses: List<TExpense>? = null,
	val totalExpense: Int? = null
) {
	constructor(
		event: Event,
		callerParticipation: EventParticipation?,
		journeySteps: List<EventJourneyStep>,
		callerStepJourneys: List<TEventCallerParticipationStepJourney>?,
		participants: List<EventParticipation>,
		participantsCount: Long,
		expenses: List<Expense>?,
		isBetterThan: Map<String, Double>?
	) : this(
		event = TEvent(event, expenses != null),
		callerParticipation = callerParticipation?.let {
			TEventCallerParticipation(
				it,
				isBetterThan,
				callerStepJourneys ?: emptyList(),
				journeySteps.firstOrNull { step -> step.isCurrent }?.id?.value
			)
		},
		journeySteps = journeySteps.map { TEventJourneyStep(it) },
		currentStepId = journeySteps.firstOrNull { it.isCurrent }?.id?.value,
		currentJourney = journeySteps.firstOrNull { it.isCurrent }?.journey?.let { TJourneyPartial(it) },
		previewParticipants = participants.map { TEventParticipation(it, emptyMap()) },
		previewParticipantsCount = participantsCount,
		expenses = expenses?.map { TExpense(it) },
		totalExpense = expenses?.sumOf { it.amount }
	)
}


