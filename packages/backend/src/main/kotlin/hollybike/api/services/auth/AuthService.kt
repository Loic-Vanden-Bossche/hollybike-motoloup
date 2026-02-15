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
import org.jetbrains.exposed.v1.dao.load
import org.jetbrains.exposed.v1.jdbc.Database
import org.jetbrains.exposed.v1.core.and
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.less
import org.jetbrains.exposed.v1.core.or
import org.jetbrains.exposed.v1.jdbc.selectAll
import org.jetbrains.exposed.v1.jdbc.transactions.transaction
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.security.SecureRandom
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import kotlin.concurrent.schedule
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlin.time.Clock
import kotlin.time.Instant
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
		val nextRun = Clock.System.now() + refreshTokenInactivity
		timer.schedule(Date.from(java.time.Instant.ofEpochSecond(nextRun.epochSeconds, nextRun.nanosecondsOfSecond.toLong()))) {
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
		return transaction(db) {
			val userRow = Users.selectAll()
				.where { lower(Users.email) eq lower(login.email) }
				.singleOrNull()
				?: return@transaction Result.failure(UserNotFoundException())

			if (!verify(login.password, userRow[Users.password].decodeBase64Bytes())) {
				return@transaction Result.failure(UserWrongPassword())
			}

			val userStatus = userRow[Users.status]
			val associationId = userRow[Users.association].value
			val associationStatus = Associations
				.selectAll()
				.where { Associations.id eq associationId }
				.single()[Associations.status]

			if (userStatus != EUserStatus.Enabled.value || associationStatus != EAssociationsStatus.Enabled.value) {
				return@transaction Result.failure(UserDisabled())
			}

			val userId = userRow[Users.id]
			val userScope = EUserScope[userRow[Users.scope]]
			val userEmail = userRow[Users.email]
			val refresh = generateRefreshToken()
			val refreshHash = hashRefreshToken(refresh)
			val device = normalizeDeviceIdForSession(login.device)

			Token.find { (Tokens.user eq userId) and (Tokens.device eq device) }.firstOrNull()
				?.apply {
					token = refreshHash
					lastUse = Clock.System.now()
				}
				?: Token.new {
					this.user = User[userId]
					this.device = device
					this.token = refreshHash
					this.lastUse = Clock.System.now()
				}

			Result.success(
				TAuthInfo(
					generateJWT(userEmail, userScope),
					refresh,
					device
				)
			)
		}
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
		val expireSeconds = expire.epochSeconds
		val token = encoder.encode(hmacSha256("$mail-$expireSeconds"))
		val link = "${conf.domain}/change-password?user=$mail&expire=$expireSeconds&token=$token"
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




