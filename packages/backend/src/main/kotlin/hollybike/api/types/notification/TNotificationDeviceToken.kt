/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and LoÃ¯c Vanden Bossche
*/
package hollybike.api.types.notification

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TNotificationDeviceTokenUpsert(
	@SerialName("device_id")
	val deviceId: String,
	val platform: String,
	val token: String,
	val host: String? = null,
)

@Serializable
data class TNotificationDeviceTokenDelete(
	@SerialName("device_id")
	val deviceId: String,
	val platform: String,
	val host: String? = null,
)
