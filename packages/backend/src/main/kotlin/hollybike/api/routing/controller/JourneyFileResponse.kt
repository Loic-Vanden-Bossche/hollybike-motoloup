package hollybike.api.routing.controller

import hollybike.api.json
import hollybike.api.types.journey.GeoJson
import hollybike.api.types.journey.toGpx
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.ApplicationCall
import io.ktor.server.request.accept
import io.ktor.server.response.respond
import kotlinx.serialization.encodeToString
import nl.adaptivity.xmlutil.serialization.XML

internal suspend fun ApplicationCall.respondJourneyFileByAccept(data: ByteArray, xml: XML) {
	val geoJson = json.decodeFromString<GeoJson>(data.toString(Charsets.UTF_8))
	if (request.accept()?.contains("geo+json") == true) {
		respond(json.encodeToString(geoJson))
	} else if (request.accept()?.contains("gpx") == true) {
		respond(xml.encodeToString(geoJson.toGpx()))
	} else {
		respond(HttpStatusCode.BadRequest, "Il manque un format de retour")
	}
}
