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

object EventJourneySteps : IntIdTable("event_journey_steps", "id_event_journey_step") {
	val event = reference("event", Events)
	val journey = reference("journey", Journeys)
	val name = varchar("name", 255).nullable().default(null)
	val position = integer("position")
	val isCurrent = bool("is_current").default(false)
	val createDateTime = timestamp("create_date_time").clientDefault { Clock.System.now() }
	val updateDateTime = timestamp("update_date_time").clientDefault { Clock.System.now() }
}

class EventJourneyStep(id: EntityID<Int>) : IntEntity(id) {
	var event by Event referencedOn EventJourneySteps.event
	var journey by Journey referencedOn EventJourneySteps.journey
	var name by EventJourneySteps.name
	var position by EventJourneySteps.position
	var isCurrent by EventJourneySteps.isCurrent
	var createDateTime by EventJourneySteps.createDateTime
	var updateDateTime by EventJourneySteps.updateDateTime

	companion object : IntEntityClass<EventJourneyStep>(EventJourneySteps)
}
