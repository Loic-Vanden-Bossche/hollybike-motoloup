/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import hollybike.api.database.now
import hollybike.api.repository.Invitations.defaultExpression
import hollybike.api.utils.search.Mapper
import kotlin.time.Clock
import org.jetbrains.exposed.v1.dao.IntEntity
import org.jetbrains.exposed.v1.dao.IntEntityClass
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import org.jetbrains.exposed.v1.core.dao.id.IntIdTable
import org.jetbrains.exposed.v1.datetime.timestamp

object Notifications: IntIdTable("notifications", "id_notification") {
	val user = reference("user", Users)
	val data = text("data")
	val creation = timestamp("creation").defaultExpression(now())
	val seen = bool("seen").default(false)
}

class Notification(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn Notifications.user
	var data by Notifications.data
	var creation by Notifications.creation
	var seen by Notifications.seen

	companion object: IntEntityClass<Notification>(Notifications)
}

val notificationMapper: Mapper = mapOf(
	"id_notification" to Notifications.id,
	"creation" to Notifications.creation,
	"seen" to Notifications.seen,
)




