/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import hollybike.api.repository.EventJourneyStep
import hollybike.api.types.journey.TJourneyPartial
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEventJourneyStep(
	val id: Int,
	@SerialName("journey_id")
	val journeyId: Int,
	val name: String?,
	val position: Int,
	@SerialName("is_current")
	val isCurrent: Boolean,
	val journey: TJourneyPartial,
) {
	constructor(entity: EventJourneyStep) : this(
		id = entity.id.value,
		journeyId = entity.journey.id.value,
		name = entity.name,
		position = entity.position,
		isCurrent = entity.isCurrent,
		journey = TJourneyPartial(entity.journey),
	)
}

@Serializable
data class TEventJourneyStepsState(
	@SerialName("journey_steps")
	val journeySteps: List<TEventJourneyStep>,
	@SerialName("current_step_id")
	val currentStepId: Int?,
	@SerialName("current_journey")
	val currentJourney: TJourneyPartial?,
) {
	constructor(steps: List<EventJourneyStep>) : this(
		journeySteps = steps.map { TEventJourneyStep(it) },
		currentStepId = steps.firstOrNull { it.isCurrent }?.id?.value,
		currentJourney = steps.firstOrNull { it.isCurrent }?.journey?.let { TJourneyPartial(it) },
	)
}
