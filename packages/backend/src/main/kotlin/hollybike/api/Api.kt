/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.routing.controller.*
import hollybike.api.services.*
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.services.journey.JourneyService
import hollybike.api.services.image.EventImageService
import hollybike.api.services.image.ImageMetadataService
import hollybike.api.services.NotificationService
import hollybike.api.services.storage.StorageService
import hollybike.api.utils.MailSender
import hollybike.api.utils.websocket.AuthVerifier
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.sql.Database
import org.slf4j.event.Level

val json = Json {
	ignoreUnknownKeys = true
}

fun Application.api(storageService: StorageService, db: Database) {
	val conf = attributes.conf

	configureHTTP()
	configureSecurity(db)
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}

	val positionService = PositionService(db, CoroutineScope(Dispatchers.Default))

	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}

	val notificationService = NotificationService(db)
	val associationService = AssociationService(db, storageService)
	val userService = UserService(db, storageService, associationService)
	val invitationService = InvitationService(db)
	val authService = AuthService(db, conf.security, invitationService, userService, mailSender)
	val eventService = EventService(db, storageService, notificationService)
	val eventParticipationService = EventParticipationService(db, eventService, notificationService)
	val imageMetadataService = ImageMetadataService()
	val eventImageService = EventImageService(db, eventService, storageService, imageMetadataService, positionService)
	val journeyService = JourneyService(db, associationService, storageService, conf.mapBox)
	val profileService = ProfileService(db)
	val userEventPositionService = UserEventPositionService(db, CoroutineScope(Dispatchers.Default), storageService)
	val expenseService = ExpenseService(db, eventService, storageService)
	val authVerifier = AuthVerifier(conf.security, db, log)

	ApiController(this, mailSender, true)
	AuthenticationController(this, authService)
	UserController(this, userService, storageService, authService)
	AssociationController(this, associationService, invitationService, authService, expenseService)
	InvitationController(this, authService, invitationService, mailSender)
	EventController(this, eventService, eventParticipationService, associationService, userService, userEventPositionService, expenseService, storageService)
	EventParticipationController(this, eventParticipationService, userEventPositionService)
	EventImageController(this, eventImageService)
	JourneyController(this, journeyService, positionService, storageService)
	UserJourneyController(this, userEventPositionService, storageService)
	ProfileController(this, profileService)
	WebSocketController(this, authVerifier, notificationService, userEventPositionService)
	NotificationController(this, notificationService)
	ExpenseController(this, expenseService)

	if (isOnPremise || conf.security.cfKeyPairId == null || conf.security.cfPrivateKeySecret == null) {
		log.info("Running in on-premise mode or not using cloudfront, using storage controller")
		StorageController(this, storageService)
	}

	if (isOnPremise) {
		ConfController(this, false)
	}
}