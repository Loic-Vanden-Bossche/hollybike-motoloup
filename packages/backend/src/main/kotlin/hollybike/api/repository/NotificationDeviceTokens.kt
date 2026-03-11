/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and LoÃ¯c Vanden Bossche
*/
package hollybike.api.repository

import hollybike.api.database.now
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import org.jetbrains.exposed.v1.core.dao.id.IntIdTable
import org.jetbrains.exposed.v1.dao.IntEntity
import org.jetbrains.exposed.v1.dao.IntEntityClass
import org.jetbrains.exposed.v1.datetime.timestamp

object NotificationDeviceTokens : IntIdTable("notification_device_tokens", "id_notification_device_token") {
	val user = reference("user", Users)
	val deviceId = varchar("device_id", 128)
	val platform = varchar("platform", 32)
	val token = varchar("token", 512)
	val host = varchar("host", 512).nullable().default(null)
	val active = bool("active").default(true)
	val createdAt = timestamp("created_at").defaultExpression(now())
	val updatedAt = timestamp("updated_at").defaultExpression(now())
}

class NotificationDeviceToken(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn NotificationDeviceTokens.user
	var deviceId by NotificationDeviceTokens.deviceId
	var platform by NotificationDeviceTokens.platform
	var token by NotificationDeviceTokens.token
	var host by NotificationDeviceTokens.host
	var active by NotificationDeviceTokens.active
	var createdAt by NotificationDeviceTokens.createdAt
	var updatedAt by NotificationDeviceTokens.updatedAt

	companion object : IntEntityClass<NotificationDeviceToken>(NotificationDeviceTokens)
}
