/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.plugins

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.conf
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.user.EUserStatus
import io.ktor.http.auth.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.util.*
import org.jetbrains.exposed.v1.dao.with
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.jdbc.transactions.transaction

private val userAttributeKey = AttributeKey<User>("user")
private val objectPathAttributeKey = AttributeKey<String>("objectPath")

val ApplicationCall.user: User get() = attributes[userAttributeKey]
val ApplicationCall.objectPath: String get() = attributes[objectPathAttributeKey]

fun Application.configureSecurity(db: Database) {
	log.info("Configuring Security")
	val jwtAudience = attributes.conf.security.audience
	val jwtDomain = attributes.conf.security.domain
	val jwtRealm = attributes.conf.security.realm
	val jwtSecret = attributes.conf.security.secret
	authentication {
		jwt {
			realm = jwtRealm
			verifier(
				JWT
					.require(Algorithm.HMAC256(jwtSecret))
					.withAudience(jwtAudience)
					.withIssuer(jwtDomain)
					.build(),
			)
			validate { credential ->
				try {
					if (credential.payload.audience.contains(jwtAudience)) {
						val user = transaction(db) {
							User.find {
								(Users.email eq credential.payload.getClaim("email")
									.asString()) and (Users.status eq EUserStatus.Enabled.value)
							}.with(User::association).singleOrNull()?.takeIf {
								it.association.status == EAssociationsStatus.Enabled
							}
						} ?: run {
							return@validate null
						}
						this.attributes.put(userAttributeKey, user)
						JWTPrincipal(credential.payload)
					} else {
						null
					}
				} catch (_: Exception) {
					null
				}
			}
		}

		jwt("signed-image") {
			realm = jwtRealm
			verifier(
				JWT
					.require(Algorithm.HMAC256(jwtSecret + "image-signer"))
					.withAudience(jwtAudience)
					.withIssuer(jwtDomain)
					.build(),
			)
			validate { credential ->
				if (credential.payload.audience.contains(jwtAudience)) {
					this.attributes.put(objectPathAttributeKey, credential.payload.getClaim("objectPath").asString())
					JWTPrincipal(credential.payload)
				} else {
					null
				}
			}
			authHeader { call ->
				try {
					HttpAuthHeader.Single("Bearer", call.parameters["signature"] ?: "")
				} catch (e: Throwable) {
					null
				}
			}
		}
	}
}



