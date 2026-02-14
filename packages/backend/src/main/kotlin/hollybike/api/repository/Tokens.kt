/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import hollybike.api.database.now
import org.jetbrains.exposed.v1.dao.IntEntity
import org.jetbrains.exposed.v1.dao.IntEntityClass
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import org.jetbrains.exposed.v1.core.dao.id.IntIdTable
import org.jetbrains.exposed.v1.datetime.timestamp

object Tokens: IntIdTable("tokens", "id_token") {
	val token = varchar("token", 128)
	val user = reference("user", Users)
	val device = varchar("device", 40)
	val lastUse = timestamp("last_use").defaultExpression(now())
}

class Token(id: EntityID<Int>) : IntEntity(id) {
	var token by Tokens.token
	var user by User referencedOn Tokens.user
	var device by Tokens.device
	var lastUse by Tokens.lastUse

	companion object: IntEntityClass<Token>(Tokens)
}



