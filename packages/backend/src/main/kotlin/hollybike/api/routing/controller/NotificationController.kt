/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and LoÃ¯c Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.notificationMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Notifications
import hollybike.api.services.NotificationService
import hollybike.api.types.lists.TLists
import hollybike.api.types.notification.TNotificationDeviceTokenDelete
import hollybike.api.types.notification.TNotificationDeviceTokenUpsert
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.TNotification
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.Application
import io.ktor.server.auth.authenticate
import io.ktor.server.request.receive
import io.ktor.server.resources.delete
import io.ktor.server.resources.get
import io.ktor.server.resources.post
import io.ktor.server.resources.put
import io.ktor.server.response.respond
import io.ktor.server.routing.Route
import io.ktor.server.routing.routing

class NotificationController(
	application: Application,
	private val notificationService: NotificationService,
) {
	init {
		application.routing {
			authenticate {
				getAll()
				getMetaData()
				seenAll()
				seenNotification()
				registerDeviceToken()
				updateDeviceToken()
				unregisterDeviceToken()
			}
		}
	}

	private fun Route.getAll() {
		get<Notifications> {
			val mapper = if (call.user.scope == EUserScope.Root) {
				notificationMapper + userMapper
			} else {
				notificationMapper
			}
			val searchParam = call.request.queryParameters.getSearchParam(mapper)
			val list = notificationService.getAll(call.user, searchParam)
			val count = notificationService.getAllCount(call.user, searchParam)
			call.respond(TLists(list.map { TNotification(it) }, searchParam, count))
		}
	}

	private fun Route.getMetaData() {
		get<Notifications.MetaData> {
			val mapper = if (call.user.scope == EUserScope.Root) {
				notificationMapper + userMapper
			} else {
				notificationMapper
			}
			call.respond(mapper.getMapperData())
		}
	}

	private fun Route.seenAll() {
		put<Notifications.Seen> {
			notificationService.setAllRead(call.user)
			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.seenNotification() {
		put<Notifications.Id.Seen> {
			val notification = notificationService.getNotificationById(call.user, it.id.id)
				?: return@put call.respond(HttpStatusCode.NotFound, "Aucune notification trouvee")
			notificationService.setNotificationSeen(notification, true)
			call.respond(TNotification(notification))
		}
	}

	private fun Route.registerDeviceToken() {
		post<Notifications.Tokens> {
			val payload = call.receive<TNotificationDeviceTokenUpsert>()
			runCatching {
				notificationService.registerDeviceToken(call.user, payload)
			}.onFailure { error ->
				error.printStackTrace()
				return@post call.respond(HttpStatusCode.BadRequest, error.message ?: "Invalid payload")
			}
			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.updateDeviceToken() {
		put<Notifications.Tokens> {
			val payload = call.receive<TNotificationDeviceTokenUpsert>()
			runCatching {
				notificationService.registerDeviceToken(call.user, payload)
			}.onFailure { error ->
				return@put call.respond(HttpStatusCode.BadRequest, error.message ?: "Invalid payload")
			}
			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.unregisterDeviceToken() {
		delete<Notifications.Tokens> {
			val payload = call.receive<TNotificationDeviceTokenDelete>()
			runCatching {
				notificationService.unregisterDeviceToken(
					user = call.user,
					deviceId = payload.deviceId,
					platform = payload.platform,
					host = payload.host,
				)
			}.onFailure { error ->
				return@delete call.respond(HttpStatusCode.BadRequest, error.message ?: "Invalid payload")
			}
			call.respond(HttpStatusCode.OK)
		}
	}
}
