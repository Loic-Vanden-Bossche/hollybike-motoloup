/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and LoÃ¯c Vanden Bossche
*/
package hollybike.api.services

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingException
import com.google.firebase.messaging.Message
import com.google.firebase.messaging.MessagingErrorCode
import com.google.firebase.messaging.Notification as FirebaseNotification
import hollybike.api.json
import hollybike.api.repository.Notification
import hollybike.api.repository.NotificationDeviceToken
import hollybike.api.repository.NotificationDeviceTokens
import hollybike.api.repository.Notifications
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.notification.TNotificationDeviceTokenUpsert
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.websocket.AddedToEventNotification
import hollybike.api.types.websocket.DeleteEventNotification
import hollybike.api.types.websocket.EventStatusUpdateNotification
import hollybike.api.types.websocket.NewEventNotification
import hollybike.api.types.websocket.NotificationBody
import hollybike.api.types.websocket.RemovedFromEventNotification
import hollybike.api.types.websocket.UpdateEventNotification
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import org.jetbrains.exposed.v1.core.Op
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.isNull
import org.jetbrains.exposed.v1.core.neq
import org.jetbrains.exposed.v1.dao.load
import org.jetbrains.exposed.v1.dao.with
import org.jetbrains.exposed.v1.exceptions.ExposedSQLException
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.jdbc.andWhere
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import org.jetbrains.exposed.v1.jdbc.update
import org.slf4j.Logger
import java.io.ByteArrayInputStream
import kotlin.time.Clock

class NotificationService(
	private val db: Database,
	private val logger: Logger,
	isCloud: Boolean,
	firebaseAdminCredentialsJson: String?,
) {
	private val pushTransport = createTransport(isCloud, firebaseAdminCredentialsJson)

	private fun createTransport(
		isCloud: Boolean,
		credentialsJson: String?,
	): NotificationPushTransport {
		if (!isCloud) {
			logger.info("Push notifications disabled: running in on-premise mode")
			return NoopPushTransport
		}

		if (credentialsJson.isNullOrBlank()) {
			logger.warn("Push notifications disabled: FIREBASE_ADMIN_CREDENTIALS_JSON is missing")
			return NoopPushTransport
		}

		val messaging = runCatching {
			createFirebaseMessaging(credentialsJson)
		}.onFailure {
			logger.warn("Push notifications disabled: unable to initialize Firebase Admin", it)
		}.getOrNull()

		return if (messaging == null) {
			NoopPushTransport
		} else {
			logger.info("Push notifications enabled with Firebase Admin")
			FcmPushTransport(messaging, logger)
		}
	}

	private fun createFirebaseMessaging(credentialsJson: String): FirebaseMessaging {
		val app = synchronized(firebaseLock) {
			FirebaseApp.getApps().firstOrNull { it.name == firebaseAppName } ?: run {
				val credentials = GoogleCredentials.fromStream(
					ByteArrayInputStream(credentialsJson.toByteArray()),
				)
				FirebaseApp.initializeApp(
					FirebaseOptions.builder().setCredentials(credentials).build(),
					firebaseAppName,
				)
			}
		}
		return FirebaseMessaging.getInstance(app)
	}

	fun send(user: User, notification: NotificationBody) {
		val payload = mapNotification(notification)
		val entity = transaction(db) {
			Notification.new {
				this.user = user
				this.data = json.encodeToString(notification)
			}
		}
		notification.notificationId = entity.id.value

		sendPushToUser(
			userId = user.id.value,
			notificationId = entity.id.value,
			payload = payload,
		)
	}

	fun send(users: List<User>, notification: NotificationBody, caller: User) {
		users.forEach {
			if (caller.id != it.id) {
				send(it, notification)
			}
		}
	}

	fun sendToAssociation(associationId: Int, notification: NotificationBody, caller: User) {
		val users = transaction(db) {
			User.find { (Users.association eq associationId) and (Users.status neq EUserStatus.Disabled.value) }.toList()
		}
		send(users, notification, caller)
	}

	private fun authorizeGet(caller: User, target: Notification): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> target.user.id == caller.id
		EUserScope.User -> target.user.id == caller.id
	}

	private infix fun Notification?.getIfAllowed(caller: User): Notification? =
		this?.let { if (authorizeGet(caller, it)) this else null }

	fun getAll(caller: User, searchParam: SearchParam): List<Notification> = transaction(db) {
		val condition = when (caller.scope) {
			EUserScope.Root -> Op.nullOp()
			EUserScope.Admin -> Notifications.user eq caller.id
			EUserScope.User -> Notifications.user eq caller.id
		}
		Notification.wrapRows(
			Notifications.selectAll().applyParam(searchParam).andWhere { condition },
		).with(Notification::user).toList()
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long = transaction(db) {
		val condition = when (caller.scope) {
			EUserScope.Root -> Op.nullOp()
			EUserScope.Admin -> Notifications.user eq caller.id
			EUserScope.User -> Notifications.user eq caller.id
		}
		Notifications.selectAll().applyParam(searchParam, false).andWhere { condition }.count()
	}

	fun setAllRead(caller: User) {
		transaction(db) {
			Notifications.update({ (Notifications.seen eq false) and (Notifications.user eq caller.id) }) {
				it[Notifications.seen] = true
			}
		}
	}

	fun setNotificationSeen(notification: Notification, seen: Boolean): Notification = transaction(db) {
		notification.apply {
			this.seen = seen
		}
	}

	fun getNotificationById(caller: User, notificationId: Int) = transaction(db) {
		Notification.findById(notificationId)?.load(Notification::user, User::association) getIfAllowed caller
	}

	fun registerDeviceToken(user: User, payload: TNotificationDeviceTokenUpsert) {
		if (!pushTransport.isEnabled) {
			return
		}

		validateTokenPayload(payload)
		val now = Clock.System.now()
		val deviceId = payload.deviceId.trim()
		val platform = payload.platform.trim().lowercase()
		val token = payload.token.trim()
		val host = payload.host?.trim()?.takeIf { it.isNotEmpty() }

		try {
			transaction(db) {
				if (!updateDeviceTokenRow(user, deviceId, platform, host, token, now)) {
					NotificationDeviceToken.new {
						this.user = user
						this.deviceId = deviceId
						this.platform = platform
						this.token = token
						this.host = host
						this.active = true
						this.createdAt = now
						this.updatedAt = now
					}
				}
			}
		} catch (e: ExposedSQLException) {
			if (!isDuplicateKeyViolation(e)) {
				throw e
			}
			// Concurrent register for same token row: retry as update.
			transaction(db) {
				updateDeviceTokenRow(user, deviceId, platform, host, token, now)
			}
		}
	}

	fun unregisterDeviceToken(user: User, deviceId: String, platform: String, host: String?) {
		if (!pushTransport.isEnabled) {
			return
		}

		val normalizedDeviceId = deviceId.trim()
		val normalizedPlatform = platform.trim().lowercase()
		val normalizedHost = host?.trim()?.takeIf { it.isNotEmpty() }
		if (normalizedDeviceId.isEmpty() || normalizedPlatform.isEmpty()) {
			throw IllegalArgumentException("device_id and platform are required")
		}

		val now = Clock.System.now()
		transaction(db) {
			NotificationDeviceToken.find { NotificationDeviceTokens.user eq user.id }
				.filter {
					it.deviceId == normalizedDeviceId &&
						it.platform == normalizedPlatform &&
						it.host == normalizedHost
				}
				.forEach {
					it.active = false
					it.updatedAt = now
				}
		}
	}

	private fun validateTokenPayload(payload: TNotificationDeviceTokenUpsert) {
		if (payload.deviceId.isBlank() || payload.platform.isBlank() || payload.token.isBlank()) {
			throw IllegalArgumentException("device_id, platform and token are required")
		}
	}

	private fun updateDeviceTokenRow(
		user: User,
		deviceId: String,
		platform: String,
		host: String?,
		token: String,
		now: kotlin.time.Instant,
	): Boolean {
		val hostCondition = host?.let { NotificationDeviceTokens.host eq it } ?: NotificationDeviceTokens.host.isNull()

		val updated = NotificationDeviceTokens.update({
			(NotificationDeviceTokens.user eq user.id) and
				(NotificationDeviceTokens.deviceId eq deviceId) and
				(NotificationDeviceTokens.platform eq platform) and
				hostCondition
		}) {
			it[NotificationDeviceTokens.token] = token
			it[NotificationDeviceTokens.active] = true
			it[NotificationDeviceTokens.updatedAt] = now
		}

		return updated > 0
	}

	private fun isDuplicateKeyViolation(error: ExposedSQLException): Boolean {
		val message = error.cause?.message ?: error.message ?: ""
		return message.contains("duplicate key value violates unique constraint", ignoreCase = true)
	}

	private fun sendPushToUser(userId: Int, notificationId: Int, payload: PushPayload) {
		if (!pushTransport.isEnabled) {
			return
		}

		val tokens = transaction(db) {
			NotificationDeviceToken.find {
				(NotificationDeviceTokens.user eq userId) and
					(NotificationDeviceTokens.active eq true)
			}.toList()
		}
		if (tokens.isEmpty()) {
			return
		}

		val invalidTokenIds = mutableListOf<Int>()
		tokens.forEach { deviceToken ->
			when (
				pushTransport.send(
					token = deviceToken.token,
					notificationId = notificationId,
					payload = payload,
				)
			) {
				PushSendResult.InvalidToken -> invalidTokenIds.add(deviceToken.id.value)
				PushSendResult.Success -> {}
				PushSendResult.Failure -> {}
			}
		}

		if (invalidTokenIds.isNotEmpty()) {
			val now = Clock.System.now()
			transaction(db) {
				invalidTokenIds.forEach { invalidTokenId ->
					NotificationDeviceToken.findById(invalidTokenId)?.apply {
						active = false
						updatedAt = now
					}
				}
			}
		}
	}

	private fun mapNotification(notification: NotificationBody): PushPayload = when (notification) {
		is EventStatusUpdateNotification -> PushPayload(
			type = "EventStatusUpdateNotification",
			title = notification.name,
			body = "Le statut de l evenement ${notification.name} a ete mis a jour",
			eventId = notification.id,
			target = "event_details",
		)
		is AddedToEventNotification -> PushPayload(
			type = "AddedToEventNotification",
			title = notification.name,
			body = "Vous avez ete ajoute a l evenement ${notification.name}",
			eventId = notification.id,
			target = "event_details",
		)
		is RemovedFromEventNotification -> PushPayload(
			type = "RemovedFromEventNotification",
			title = notification.name,
			body = "Vous avez ete retire de l evenement ${notification.name}",
			eventId = notification.id,
			target = "event_details",
		)
		is DeleteEventNotification -> PushPayload(
			type = "DeleteEventNotification",
			title = notification.name,
			body = "L evenement ${notification.name} a ete supprime",
			eventId = null,
			target = "notifications_inbox",
		)
		is UpdateEventNotification -> PushPayload(
			type = "UpdateEventNotification",
			title = notification.name,
			body = "L evenement ${notification.name} a ete mis a jour",
			eventId = notification.id,
			target = "event_details",
		)
		is NewEventNotification -> PushPayload(
			type = "NewEventNotification",
			title = notification.name,
			body = "Nouvel evenement ${notification.name}",
			eventId = notification.id,
			target = "event_details",
		)
	}

	private data class PushPayload(
		val type: String,
		val title: String,
		val body: String,
		val eventId: Int?,
		val target: String,
	)

	private interface NotificationPushTransport {
		val isEnabled: Boolean
		fun send(token: String, notificationId: Int, payload: PushPayload): PushSendResult
	}

	private object NoopPushTransport : NotificationPushTransport {
		override val isEnabled: Boolean = false
		override fun send(token: String, notificationId: Int, payload: PushPayload): PushSendResult = PushSendResult.Success
	}

	private class FcmPushTransport(
		private val firebaseMessaging: FirebaseMessaging,
		private val logger: Logger,
	) : NotificationPushTransport {
		override val isEnabled: Boolean = true

		override fun send(token: String, notificationId: Int, payload: PushPayload): PushSendResult {
			return try {
				val message = Message.builder()
					.setToken(token)
					.putData("type", payload.type)
					.putData("notification_id", notificationId.toString())
					.putData("title", payload.title)
					.putData("body", payload.body)
					.putData("target", payload.target)
					.apply {
						payload.eventId?.let { putData("event_id", it.toString()) }
					}
					.setNotification(
						FirebaseNotification.builder()
							.setTitle(payload.title)
							.setBody(payload.body)
							.build(),
					)
					.build()
				firebaseMessaging.send(message)
				PushSendResult.Success
			} catch (e: FirebaseMessagingException) {
				if (
					e.messagingErrorCode == MessagingErrorCode.UNREGISTERED ||
					e.messagingErrorCode == MessagingErrorCode.INVALID_ARGUMENT
				) {
					PushSendResult.InvalidToken
				} else {
					logger.warn("Unable to send notification $notificationId via FCM", e)
					PushSendResult.Failure
				}
			} catch (e: Exception) {
				logger.warn("Unable to send notification $notificationId via FCM", e)
				PushSendResult.Failure
			}
		}
	}

	private enum class PushSendResult {
		Success,
		InvalidToken,
		Failure,
	}

	companion object {
		private const val firebaseAppName = "hollybike-notifications"
		private val firebaseLock = Any()
	}
}
