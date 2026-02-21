/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.isOnPremise
import hollybike.api.routing.resources.Conf
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.get
import hollybike.api.utils.put
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.routing
import io.ktor.server.routing.Route
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.*
import java.io.File

class ConfController(
	application: Application,
	private val confMode: Boolean
) {
	init {
		if (application.isOnPremise) {
			application.routing {
				if (confMode) {
					getConfInConfMode()
					setConfInConfMode()
				} else {
					authenticate {
						getConf()
						setConf()
					}
				}
			}
		}
	}

	@OptIn(ExperimentalSerializationApi::class)
	private val json = Json {
		prettyPrint = true
		prettyPrintIndent = "	"
	}

	private fun Route.getConf() {
		get<Conf>(EUserScope.Admin) {
			val f = File("./app.json")
			val text = if (f.exists()) {
				f.readText()
			} else {
				""
			}
			call.respondText(getConfText(text), ContentType.Application.Json, HttpStatusCode.OK)
		}
	}

	private fun Route.setConf() {
		put<Conf>(EUserScope.Admin) {
			val json = call.receiveText()
			val jsonToWrite = getConfTextWithPassword(json)
			val f = File("./app.json")
			if(!f.exists()) {
				f.createNewFile()
			}
			f.writeText(jsonToWrite)
			call.respondText(getConfText(jsonToWrite), ContentType.Application.Json, HttpStatusCode.OK)
		}
	}

	private fun Route.getConfInConfMode() {
		get<Conf> {
			val f = File("./app.json")
			val text = if (f.exists()) {
				f.readText()
			} else {
				""
			}
			call.respondText(getConfText(text), ContentType.Application.Json, HttpStatusCode.OK)
		}
	}

	private fun Route.setConfInConfMode() {
		put<Conf> {
			val json = call.receiveText()
			val jsonToWrite = getConfTextWithPassword(json)
			val f = File("./app.json")
			if(!f.exists()) {
				f.createNewFile()
			}
			f.writeText(jsonToWrite)
			call.respondText(getConfText(jsonToWrite), ContentType.Application.Json, HttpStatusCode.OK)
		}
	}

	private fun getConfText(conf: String): String {
		return if (conf.isEmpty()) {
					"{}"
				} else {
					val a = json.parseToJsonElement(conf)
					val b = if (a is JsonObject) {
						JsonObject(
							a.mapNotNull { (sectionKey, sectionValue) ->
								val sectionObject = sectionValue as? JsonObject ?: return@mapNotNull null
								sectionKey to JsonObject(
									sectionObject.mapValues { (key, value) ->
										if (isSensitiveKey(key)) JsonPrimitive("******") else value
									}
								)
							}.toMap()
						)
					} else {
						null
					}
					b?.toString() ?: "{}"
				}
			}

	private fun getConfTextWithPassword(text: String): String {
		val f = File("./app.json")
		val ref = if (f.exists()) {
			f.readText().let { conf -> json.parseToJsonElement(conf) }
		} else {
			null
		}
		val a = json.parseToJsonElement(text)
		val b = if (a is JsonObject) {
			JsonObject(
				a.mapNotNull { (sectionKey, sectionValue) ->
					val sectionObject = sectionValue as? JsonObject ?: return@mapNotNull null
					sectionKey to JsonObject(
						sectionObject.mapValues { (key, value) ->
							if (isSensitiveKey(key) && value is JsonPrimitive && value.content == "******") {
								ref?.getValue(sectionKey, key)?.let { JsonPrimitive(it) } ?: value
							} else {
								value
							}
						}
					)
				}.toMap()
			)
		} else {
			null
		}
		return json.encodeToString(b)
	}

	private fun isSensitiveKey(key: String): Boolean {
		val normalized = key.lowercase()
		return "password" in normalized || "secret" in normalized
	}

	private fun JsonElement.getValue(key1: String, key2: String): String? = if (this is JsonObject) {
		this[key1]?.let { o1 ->
			if(o1 is JsonObject) {
				o1[key2]?.let { el ->
					if(el is JsonPrimitive) {
						el.content
					} else {
						null
					}
				}
			} else {
				null
			}
		}
	} else {
		null
	}
}


