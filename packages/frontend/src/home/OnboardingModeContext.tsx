/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { createContext } from "preact";
import { useContext } from "preact/hooks";
import { TOnboarding } from "../types/TOnboarding.ts";
import { OnboardingStep } from "./onboardingFlow.ts";

interface OnboardingModeState {
	loading: boolean,
	onboardingMode: boolean,
	onboarding?: TOnboarding,
	nextStep?: OnboardingStep
}

const defaultValue: OnboardingModeState = {
	loading: false,
	onboardingMode: false,
	onboarding: undefined,
	nextStep: undefined,
};

export const OnboardingModeContext = createContext<OnboardingModeState>(defaultValue);

export function useOnboardingMode() {
	return useContext(OnboardingModeContext);
}
