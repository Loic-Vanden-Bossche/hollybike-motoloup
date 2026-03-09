/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import kotlin.time.Clock
import org.jetbrains.exposed.v1.dao.IntEntity
import org.jetbrains.exposed.v1.dao.IntEntityClass
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import org.jetbrains.exposed.v1.core.dao.id.IntIdTable
import org.jetbrains.exposed.v1.datetime.timestamp

object EventParticipationStepJourneys : IntIdTable(
	"event_participation_step_journeys",
	"id_event_participation_step_journey"
) {
	val participation = reference("event_participation", EventParticipations)
	val step = reference("event_journey_step", EventJourneySteps)
	val journey = reference("journey", UsersJourneys)
	val createDateTime = timestamp("create_date_time").clientDefault { Clock.System.now() }
	val updateDateTime = timestamp("update_date_time").clientDefault { Clock.System.now() }
}

class EventParticipationStepJourney(id: EntityID<Int>) : IntEntity(id) {
	var participation by EventParticipation referencedOn EventParticipationStepJourneys.participation
	var step by EventJourneyStep referencedOn EventParticipationStepJourneys.step
	var journey by UserJourney referencedOn EventParticipationStepJourneys.journey
	var createDateTime by EventParticipationStepJourneys.createDateTime
	var updateDateTime by EventParticipationStepJourneys.updateDateTime

	companion object : IntEntityClass<EventParticipationStepJourney>(EventParticipationStepJourneys)
}
