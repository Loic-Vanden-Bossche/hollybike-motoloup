/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loic Vanden Bossche
*/
package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.auth
import hollybike.api.base.id
import hollybike.api.repository.Notification
import hollybike.api.repository.NotificationDeviceToken
import hollybike.api.repository.NotificationDeviceTokens
import hollybike.api.repository.Notifications
import hollybike.api.stores.EventStore
import hollybike.api.stores.UserStore
import hollybike.api.types.event.participation.TCreateParticipations
import hollybike.api.types.notification.TNotificationDeviceTokenDelete
import hollybike.api.types.notification.TNotificationDeviceTokenUpsert
import io.kotest.matchers.shouldBe
import io.kotest.matchers.string.shouldContain
import io.ktor.client.request.delete
import io.ktor.client.request.get
import io.ktor.client.request.patch
import io.ktor.client.request.post
import io.ktor.client.request.put
import io.ktor.client.request.setBody
import io.ktor.client.statement.bodyAsText
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.http.contentType
import org.jetbrains.exposed.v1.core.SortOrder
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.dao.with
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.jdbc.transactions.transaction

class NotificationTest : IntegrationSpec({
	context("Notifications authentication") {
		test("Should return unauthorized when user is not authenticated") {
			cloudTestApp {
				it.get("/api/notifications").apply {
					status shouldBe HttpStatusCode.Unauthorized
				}
			}
		}
	}

	context("Notification persistence and read routes (cloud)") {
		test("Should persist removed participant notification and expose it to recipient in cloud mode") {
			cloudTestApp {
				it.delete("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user2.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}

				notificationCountForUser(UserStore.user2.id) shouldBe 1
				latestNotificationDataForUser(UserStore.user2.id) shouldContain "RemovedFromEventNotification"

				it.get("/api/notifications") {
					auth(UserStore.user2)
				}.apply {
					status shouldBe HttpStatusCode.OK
					bodyAsText() shouldContain "RemovedFromEventNotification"
				}

				it.get("/api/notifications") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
				notificationCountForUser(UserStore.user1.id) shouldBe 0

				it.get("/api/notifications") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should mark all notifications as seen for current user only in cloud mode") {
			cloudTestApp {
				it.delete("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user2.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.status shouldBe HttpStatusCode.OK

				it.post("/api/events/${EventStore.event2Asso1User1.id}/participations/add-users") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(TCreateParticipations(listOf(UserStore.user2.id)))
				}.status shouldBe HttpStatusCode.OK

				unseenNotificationCountForUser(UserStore.user2.id) shouldBe 2

				it.put("/api/notifications/seen") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}

				unseenNotificationCountForUser(UserStore.user2.id) shouldBe 0
			}
		}

		test("Should mark one notification as seen only when owned by caller in cloud mode") {
			cloudTestApp {
				it.delete("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user2.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.status shouldBe HttpStatusCode.OK

				val notificationId = latestNotificationIdForUser(UserStore.user2.id)
					?: error("Notification should exist")

				it.put("/api/notifications/$notificationId/seen") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}

				isNotificationSeen(notificationId) shouldBe false

				it.put("/api/notifications/$notificationId/seen") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}

				isNotificationSeen(notificationId) shouldBe true
			}
		}
	}

	context("Notification device token routes") {
		test("Should no-op token lifecycle in on-premise mode (push disabled)") {
			onPremiseTestApp {
				val upsertPayload = TNotificationDeviceTokenUpsert(
					deviceId = "device-1",
					platform = "android",
					token = "token-1",
					host = "api.example.com",
				)
				val deletePayload = TNotificationDeviceTokenDelete(
					deviceId = "device-1",
					platform = "android",
					host = "api.example.com",
				)

				it.post("/api/notifications/tokens") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(upsertPayload)
				}.status shouldBe HttpStatusCode.OK

				it.put("/api/notifications/tokens") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(upsertPayload.copy(token = "token-2"))
				}.status shouldBe HttpStatusCode.OK

				it.delete("/api/notifications/tokens") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(deletePayload)
				}.status shouldBe HttpStatusCode.OK

				notificationTokenCountForUser(UserStore.user1.id) shouldBe 0
			}
		}

		test("Should no-op token lifecycle in cloud mode when firebase is not configured") {
			cloudTestApp {
				it.post("/api/notifications/tokens") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TNotificationDeviceTokenUpsert(
							deviceId = "device-2",
							platform = "android",
							token = "token-2",
							host = "api.example.com",
						),
					)
				}.status shouldBe HttpStatusCode.OK

				notificationTokenCountForUser(UserStore.user1.id) shouldBe 0
			}
		}
	}
}) {
	companion object {
		private fun db(): Database = Database.connect(
			url = database.jdbcUrl,
			driver = "org.postgresql.Driver",
			user = database.username,
			password = database.password,
		)

		private fun notificationCountForUser(userId: Int): Long = transaction(db()) {
			Notification.find { Notifications.user eq userId }.count()
		}

		private fun unseenNotificationCountForUser(userId: Int): Long = transaction(db()) {
			Notification.find {
				(Notifications.user eq userId) and (Notifications.seen eq false)
			}.count()
		}

		private fun latestNotificationIdForUser(userId: Int): Int? = transaction(db()) {
			Notification.find { Notifications.user eq userId }
				.with(Notification::user)
				.maxByOrNull { it.id.value }
				?.id
				?.value
		}

		private fun latestNotificationDataForUser(userId: Int): String = transaction(db()) {
			Notification.find { Notifications.user eq userId }
				.with(Notification::user)
				.maxByOrNull { it.id.value }
				?.data
				?: ""
		}

		private fun isNotificationSeen(notificationId: Int): Boolean = transaction(db()) {
			Notification.findById(notificationId)?.seen ?: false
		}

		private fun notificationTokenCountForUser(userId: Int): Long = transaction(db()) {
			NotificationDeviceToken.find { NotificationDeviceTokens.user eq userId }
				.orderBy(NotificationDeviceTokens.id to SortOrder.DESC)
				.count()
		}
	}
}
