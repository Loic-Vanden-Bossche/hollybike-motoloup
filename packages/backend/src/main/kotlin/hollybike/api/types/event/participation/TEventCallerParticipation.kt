/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.participation

import hollybike.api.repository.EventParticipation
import kotlin.time.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventCallerParticipation(
	val role: EEventRole,
	val userId: Int,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
	val journey: TUserJourney? = null,
	val hasRecordedPositions: Boolean,
	val stepJourneys: List<TEventCallerParticipationStepJourney> = emptyList()
) {
	constructor(
		entity: EventParticipation,
		isBetterThan: Map<String, Double>?,
		stepJourneys: List<TEventCallerParticipationStepJourney> = emptyList(),
		currentStepId: Int? = null
	) : this(
		role = entity.role,
		userId = entity.user.id.value,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime,
		journey = if (stepJourneys.isNotEmpty()) {
			stepJourneys.firstOrNull { it.stepId == currentStepId }?.journey
		} else {
			entity.journey?.let { TUserJourney(it, isBetterThan) }
		},
		hasRecordedPositions = if (stepJourneys.isNotEmpty()) {
			stepJourneys.firstOrNull { it.stepId == currentStepId }?.hasRecordedPositions == true
		} else {
			entity.hasRecordedPositions
		},
		stepJourneys = stepJourneys
	)
}



