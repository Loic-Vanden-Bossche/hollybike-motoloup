/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import kotlinx.serialization.Serializable

@Serializable
data class TDeleteEventImages(
	val imageIds: List<Int>
)
