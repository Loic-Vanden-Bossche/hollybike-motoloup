/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import hollybike.api.repository.EventImage
import hollybike.api.types.position.TPosition
import kotlin.time.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TGeolocatedEventImage(
	val id: Int,
	val url: String,
	val key: String,
	val width: Int,
	val height: Int,
	@SerialName("taken_date_time") val takenDateTime: Instant?,
	val position: TPosition,
) {
	constructor(entity: EventImage) : this(
		id = entity.id.value,
		url = entity.signedPath,
		key = entity.path,
		width = entity.width,
		height = entity.height,
		takenDateTime = entity.takenDateTime,
		position = TPosition(entity.position!!),
	)
}
