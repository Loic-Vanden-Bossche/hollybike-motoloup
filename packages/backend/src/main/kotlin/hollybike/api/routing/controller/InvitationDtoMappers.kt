package hollybike.api.routing.controller

import hollybike.api.services.auth.AuthService
import hollybike.api.repository.Invitation
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.invitation.TInvitation

internal fun Invitation.toInvitationDto(authService: AuthService, host: String): TInvitation =
	if (status == EInvitationStatus.Enabled) {
		TInvitation(this, authService.generateLink(host, this))
	} else {
		TInvitation(this)
	}

internal fun List<Invitation>.toInvitationDtos(authService: AuthService, host: String): List<TInvitation> =
	map { invitation -> invitation.toInvitationDto(authService, host) }
