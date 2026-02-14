/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.auth

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.ConfSecurity
import hollybike.api.exceptions.*
import hollybike.api.database.lower
import hollybike.api.repository.*
import hollybike.api.services.UserService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.auth.*
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.utils.MailSender
import hollybike.api.utils.isValidMail
import hollybike.api.utils.validPassword
import io.ktor.util.*
import kotlinx.datetime.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.or
import org.jetbrains.exposed.sql.transactions.transaction
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.security.SecureRandom
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import kotlin.concurrent.schedule
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlin.time.Duration.Companion.days
import kotlin.time.Duration.Companion.milliseconds

class AuthService(
	private val db: Database,
	private val conf: ConfSecurity,
	private val invitationService: InvitationService,
	private val userService: UserService,
	private val mailSender: MailSender?
) {
	private val key = SecretKeySpec(conf.secret.toByteArray(), "HmacSHA256")
	private val secureRandom = SecureRandom()
	private val refreshTokenInactivity = conf.refreshTokenInactivityMs.coerceAtLeast(1L).milliseconds

	private val timer = Timer()

	init {
		cleanToken()
		scheduleClean()
	}

	private fun scheduleClean() {
		timer.schedule(Date.from((Clock.System.now() + refreshTokenInactivity).toJavaInstant())) {
			cleanToken()
			scheduleClean()
		}
	}

	private fun cleanToken() {
		transaction(db) {
			Token.find { Tokens.lastUse less Clock.System.now() - refreshTokenInactivity }.forEach { it.delete() }
		}
	}

	@OptIn(ExperimentalEncodingApi::class)
	private val encoder = Base64.UrlSafe

	private fun generateJWT(email: String, scope: EUserScope) = JWT.create()
		.withAudience(conf.audience)
		.withIssuer(conf.domain)
		.withClaim("email", email)
		.withClaim("scope", scope.value)
		.withExpiresAt(Date(System.currentTimeMillis() + conf.jwtExpirationMs))
		.sign(Algorithm.HMAC256(conf.secret))

	private fun hmacSha256(value: String): ByteArray {
		val mac = Mac.getInstance("HmacSHA256")
		mac.init(key)
		return mac.doFinal(value.toByteArray(Charsets.UTF_8))
	}

	private fun constantTimeEquals(left: String, right: String): Boolean = MessageDigest.isEqual(
		left.toByteArray(StandardCharsets.UTF_8),
		right.toByteArray(StandardCharsets.UTF_8)
	)

	private fun verifyLinkSignature(
		signature: String,
		host: String,
		role: EUserScope,
		association: Int,
		invitation: Int
	): Boolean = constantTimeEquals(getLinkSignature(host, role, association, invitation), signature)

	@OptIn(ExperimentalEncodingApi::class)
	private fun getLinkSignature(host: String, role: EUserScope, association: Int, invitation: Int): String {
		val value = "$host$role$association$invitation"
		return encoder.encode(hmacSha256(value))
	}

	fun generateLink(host: String, invitation: Invitation): String {
		val sign = getLinkSignature(host, invitation.role, invitation.association.id.value, invitation.id.value)
		return "https://hollybike.chbrx.com/invite?host=$host&role=${invitation.role}&association=${invitation.association.id}&invitation=${invitation.id.value}&verify=$sign"
	}

	fun login(login: TLogin): Result<TAuthInfo> {
		val user = transaction(db) {
			User.find { lower(Users.email) eq lower(login.email) }.singleOrNull()?.load(User::association)
		}
			?: return Result.failure(UserNotFoundException())
		if (!verify(login.password, user.password.decodeBase64Bytes())) {
			return Result.failure(UserWrongPassword())
		}
		if (user.status != EUserStatus.Enabled || user.association.status != EAssociationsStatus.Enabled) {
			return Result.failure(UserDisabled())
		}
		val refresh = generateRefreshToken()
		val refreshHash = hashRefreshToken(refresh)
		val device = normalizeDeviceIdForSession(login.device)
		transaction(db) {
			Token.find { (Tokens.user eq user.id) and (Tokens.device eq device) }.firstOrNull()
				?.apply {
					token = refreshHash
					lastUse = Clock.System.now()
				}
				?: Token.new {
					this.user = user
					this.device = device
					this.token = refreshHash
					this.lastUse = Clock.System.now()
				}
		}
		return Result.success(
			TAuthInfo(
				generateJWT(user.email, user.scope),
				refresh,
				device
			)
		)
	}

	private fun normalizeDeviceIdForSession(deviceId: String?): String {
		if (deviceId.isNullOrBlank() || deviceId.length > 40) {
			return UUID.randomUUID().toString()
		}
		return deviceId
	}

	private fun sanitizeDeviceId(deviceId: String?): String? {
		if (deviceId.isNullOrBlank() || deviceId.length > 40) {
			return null
		}
		return deviceId
	}

	@OptIn(ExperimentalEncodingApi::class)
	private fun generateRefreshToken(): String {
		val bytes = ByteArray(32)
		secureRandom.nextBytes(bytes)
		return encoder.encode(bytes)
	}

	private fun hashRefreshToken(token: String): String {
		val digest = MessageDigest.getInstance("SHA-256").digest(token.toByteArray(StandardCharsets.UTF_8))
		return digest.joinToString("") { "%02x".format(it) }
	}

	fun signup(host: String, signup: TSignup): Result<TAuthInfo> {
		if (!signup.email.isValidMail()) {
			return Result.failure(InvalidMailException())
		}
		if (!verifyLinkSignature(signup.verify, host, signup.role, signup.association, signup.invitation)) {
			return Result.failure(NotAllowedException())
		}

		return userService.createUser(
			signup.email,
			signup.password,
			signup.username,
			signup.association,
			signup.role
		).map {
			transaction(db) {
				invitationService.getValidInvitation(signup.invitation)?.let { i ->
					i.uses += 1
				}
			} ?: run {
				return Result.failure(InvitationNotFoundException())
			}

			val refresh = generateRefreshToken()
			val deviceId = UUID.randomUUID().toString()
			transaction(db) {
				Token.new {
					user = it
					token = hashRefreshToken(refresh)
					device = deviceId
					lastUse = Clock.System.now()
				}
			}
			TAuthInfo(
				generateJWT(it.email, it.scope),
				refresh,
				deviceId
			)
		}.onFailure {
			return Result.failure(it)
		}
	}

	fun refreshAccessToken(refresh: TRefresh): TAuthInfo? {
		val providedDevice = sanitizeDeviceId(refresh.device) ?: return null
		val providedHash = hashRefreshToken(refresh.token)
		val newRefresh = generateRefreshToken()
		val newRefreshHash = hashRefreshToken(newRefresh)
		return transaction(db) {
			Token.find {
				(Tokens.device eq providedDevice) and (
					(Tokens.token eq providedHash) or (Tokens.token eq refresh.token)
				)
			}.firstOrNull()?.let { session ->
				val user = session.user.load(User::association)
				if (user.status != EUserStatus.Enabled || user.association.status != EAssociationsStatus.Enabled) {
					session.delete()
					return@let null
				}
				if (session.lastUse < Clock.System.now() - refreshTokenInactivity) {
					session.delete()
					return@let null
				}
				session.token = newRefreshHash
				session.lastUse = Clock.System.now()
				TAuthInfo(
					generateJWT(user.email, user.scope),
					newRefresh,
					providedDevice
				)
			}
		}
	}

	@OptIn(ExperimentalEncodingApi::class)
	fun sendResetPassword(mail: String): Result<Unit> {
		val user = transaction(db) { User.find { Users.email eq mail }.firstOrNull() } ?: run {
			return Result.failure(UserNotFoundException())
		}
		val expire = Clock.System.now() + 1.days
		val token = encoder.encode(hmacSha256("$mail-${expire.epochSeconds}"))
		val link = "${conf.domain}/change-password?user=$mail&expire=${expire.epochSeconds}&token=$token"
		mailSender?.passwordMail(link, user.username, user.email) ?: run {
			return Result.failure(NoMailSenderException())
		}
		return Result.success(Unit)
	}

	@OptIn(ExperimentalEncodingApi::class)
	fun resetPassword(mail: String, password: TResetPassword): Result<Unit> {
		password.newPassword.validPassword().onFailure {
			return Result.failure(it)
		}
		val user = transaction(db) { User.find { Users.email eq mail }.firstOrNull() } ?: run {
			return Result.failure(UserNotFoundException())
		}
		val verify = encoder.encode(hmacSha256("$mail-${password.expire}"))
		if(!constantTimeEquals(password.token, verify)) {
			return Result.failure(NotAllowedException())
		}
		if(password.newPassword != password.newPasswordConfirmation) {
			return Result.failure(UserDifferentNewPassword())
		}
		if(Instant.fromEpochSeconds(password.expire) < Clock.System.now()) {
			return Result.failure(LinkExpire())
		}
		transaction(db) {
			user.password = hash(password.newPassword).encodeBase64()
			Token.find { Tokens.user eq user.id }.forEach { it.delete() }
		}
		return Result.success(Unit)
	}
}
