/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.participation

import kotlinx.serialization.Serializable

@Serializable
data class TEventCallerParticipationStepJourney(
	val stepId: Int,
	val journey: TUserJourney?,
	val hasRecordedPositions: Boolean
)
