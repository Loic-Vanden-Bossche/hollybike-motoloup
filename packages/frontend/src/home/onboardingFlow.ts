/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { TOnboarding } from "../types/TOnboarding.ts";

export interface OnboardingContext {
	userId?: number,
	associationId?: number
}

export interface OnboardingStep {
	key: keyof TOnboarding,
	title: string,
	description: string,
	entryPath?: string,
	allowedPathPatterns: string[]
}

export function getOnboardingSteps(context: OnboardingContext): OnboardingStep[] {
	return [
		{
			key: "update_default_user",
			title: "Mettre a jour l'utilisateur",
			description: "Completez le profil du compte principal.",
			entryPath: context.userId !== undefined ? `/users/${context.userId}` : undefined,
			allowedPathPatterns: ["/users/:id"],
		},
		{
			key: "update_association",
			title: "Personnaliser l'association",
			description: "Renseignez les informations de votre association.",
			entryPath: context.associationId !== undefined ? `/associations/${context.associationId}` : undefined,
			allowedPathPatterns: ["/associations/:id"],
		},
		{
			key: "create_invitation",
			title: "Creer une invitation",
			description: "Invitez votre premiere personne dans la plateforme.",
			entryPath: context.associationId !== undefined ? `/associations/${context.associationId}/invitations` : undefined,
			allowedPathPatterns: ["/associations/:id/invitations", "/invitations/new"],
		},
	];
}

export function getNextOnboardingStep(
	onboarding: TOnboarding | undefined,
	steps: OnboardingStep[],
): OnboardingStep | undefined {
	if (onboarding === undefined) {
		return undefined;
	}
	return steps.find(step => onboarding[step.key] === false && step.entryPath !== undefined);
}

export function isOnboardingComplete(onboarding: TOnboarding | undefined): boolean {
	if (onboarding === undefined) {
		return true;
	}
	return onboarding.update_default_user && onboarding.update_association && onboarding.create_invitation;
}
