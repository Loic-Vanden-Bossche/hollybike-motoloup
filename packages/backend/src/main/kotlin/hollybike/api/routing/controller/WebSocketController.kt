/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.services.UserEventPositionService
import hollybike.api.types.websocket.*
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*

class WebSocketController(
	application: Application,
	private val authVerifier: AuthVerifier,
	private val userEventPositionService: UserEventPositionService
) {
	init {
		application.apply {
			webSocket("/api/connect") {
				this.authVerifier = this@WebSocketController.authVerifier
				this.logger = application.log
				routing {
					userEventPosition()
				}
			}
		}
	}

	private fun WebSocketRouter.userEventPosition() {
		var user: User? = null
		request("/event/{id}") {
			onSubscribe {
				user = it
				userEventPositionService.lastPosition[parameters["id"]!!.toInt()]?.forEach { entry ->
					respond(UserReceivePosition(entry.value))
				}
				userEventPositionService.getSendChannel(parameters["id"]!!.toInt()).collect { position ->
					respond(position)
				}
			}
			onUnsubscribe {
				user = null
			}
			logger.debug("Receive message")
			when(this.body) {
				is UserSendPosition -> {
					logger.debug("Receive user position")
					user?.let {
						logger.debug("Send position to service")
						userEventPositionService.getReceiveChannel(parameters["id"]!!.toInt(), it.id.value).send(this.body)
					}
				}
				is StopUserSendPosition -> {
					user?.let {
						userEventPositionService.getReceiveChannel(parameters["id"]!!.toInt(), it.id.value).send(this.body)
					}
				}
				else -> {}
			}
		}
	}
}


