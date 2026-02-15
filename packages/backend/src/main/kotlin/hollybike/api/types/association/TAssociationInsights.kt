/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loic Vanden Bossche
*/
package hollybike.api.types.association

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TAssociationInsights(
	@SerialName("events_by_month")
	val eventsByMonth: List<TEventMonthStatus>,
	@SerialName("invitation_funnel")
	val invitationFunnel: TInvitationFunnel,
	@SerialName("journey_adoption")
	val journeyAdoption: TJourneyAdoption,
	@SerialName("users_by_status")
	val usersByStatus: List<TInsightBucket>,
	@SerialName("user_last_login_buckets")
	val userLastLoginBuckets: List<TInsightBucket>,
)

@Serializable
data class TEventMonthStatus(
	val year: Int,
	val month: Int,
	val status: String,
	val count: Long,
)

@Serializable
data class TInvitationFunnel(
	@SerialName("total_created")
	val totalCreated: Long,
	@SerialName("active_links")
	val activeLinks: Long,
	@SerialName("used_links")
	val usedLinks: Long,
	@SerialName("expired_links")
	val expiredLinks: Long,
	@SerialName("disabled_links")
	val disabledLinks: Long,
	@SerialName("saturated_links")
	val saturatedLinks: Long,
)

@Serializable
data class TJourneyAdoption(
	@SerialName("total_events")
	val totalEvents: Long,
	@SerialName("total_events_with_journey")
	val totalEventsWithJourney: Long,
	@SerialName("total_journeys")
	val totalJourneys: Long,
	@SerialName("adoption_rate_percent")
	val adoptionRatePercent: Double,
)

@Serializable
data class TInsightBucket(
	val key: String,
	val count: Long,
)
