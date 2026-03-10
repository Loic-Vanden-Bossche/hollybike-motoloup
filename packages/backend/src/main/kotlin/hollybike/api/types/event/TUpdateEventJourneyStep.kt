/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import kotlinx.serialization.Serializable

@Serializable
data class TUpdateEventJourneyStep(
	val name: String? = null,
)
