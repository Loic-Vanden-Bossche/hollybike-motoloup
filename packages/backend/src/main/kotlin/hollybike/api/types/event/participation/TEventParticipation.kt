/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.participation

import hollybike.api.repository.EventParticipation
import hollybike.api.types.user.TUserPartial
import kotlin.time.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventParticipation(
	val user: TUserPartial,
	val role: EEventRole,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
	val journey: TUserJourney? = null,
	val stepJourneys: List<TEventCallerParticipationStepJourney> = emptyList()
) {
	constructor(
		entity: EventParticipation,
		isBetterThan: Map<String, Double>?,
		stepJourneys: List<TEventCallerParticipationStepJourney> = emptyList()
	) : this(
		user = TUserPartial(entity.user),
		role = entity.role,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime,
		journey = entity.journey?.let { TUserJourney(it, isBetterThan) },
		stepJourneys = stepJourneys
	)
}



