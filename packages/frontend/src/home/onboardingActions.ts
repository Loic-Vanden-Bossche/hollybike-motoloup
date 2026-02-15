/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { api } from "../utils/useApi.ts";
import { TOnboarding } from "../types/TOnboarding.ts";

export const ONBOARDING_REFRESH_EVENT = "hollybike:onboarding-refresh";

export function notifyOnboardingRefresh() {
	window.dispatchEvent(new CustomEvent(ONBOARDING_REFRESH_EVENT));
}

export async function completeOnboardingStep(step: keyof TOnboarding) {
	const current = await api<TOnboarding>("/associations/me/onboarding");

	if (current.status === 200 && current.data !== undefined && current.data[step] === false) {
		await api<TOnboarding>("/associations/me/onboarding", {
			method: "PATCH",
			body: {
				...current.data,
				[step]: true,
			},
		});
	}

	notifyOnboardingRefresh();
}
