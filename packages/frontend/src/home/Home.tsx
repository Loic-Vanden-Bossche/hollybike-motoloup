/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { useApi } from "../utils/useApi.ts";
import { TOnboarding } from "../types/TOnboarding.ts";
import {
	matchPath,
	useLocation,
	useNavigate,
} from "react-router-dom";
import { useUser } from "../user/useUser.tsx";
import {
	useMemo, useState,
} from "preact/hooks";
import {
	getNextOnboardingStep,
	getOnboardingSteps,
	isOnboardingComplete,
} from "./onboardingFlow.ts";
import {
	CheckCircle2,
	CircleDashed,
} from "lucide-preact";
import { completeOnboardingStep } from "./onboardingActions.ts";

export function Home() {
	const onboarding = useApi<TOnboarding>("/associations/me/onboarding", []);
	const onboardingData = onboarding.data;
	const location = useLocation();
	const navigate = useNavigate();
	const [advancing, setAdvancing] = useState(false);
	const user = useUser();

	const steps = useMemo(() => getOnboardingSteps({
		userId: user.user?.id,
		associationId: user.user?.association?.id,
	}), [user.user?.id, user.user?.association?.id]);

	const nextStep = useMemo(() => getNextOnboardingStep(onboardingData, steps), [onboardingData, steps]);
	const activeStepIndex = useMemo(() => {
		const byPath = steps.findIndex(step =>
			step.allowedPathPatterns.some(pattern => matchPath({
				path: pattern,
				end: true,
			}, location.pathname) !== null));
		if (byPath !== -1) {
			return byPath;
		}
		if (nextStep === undefined) {
			return -1;
		}
		return steps.findIndex(step => step.key === nextStep.key);
	}, [
		location.pathname,
		nextStep,
		steps,
	]);
	const activeStep = useMemo(() => {
		if (activeStepIndex < 0 || activeStepIndex >= steps.length) {
			return undefined;
		}
		return steps[activeStepIndex];
	}, [activeStepIndex, steps]);
	const previousStep = useMemo(() => {
		if (activeStepIndex <= 0) {
			return undefined;
		}
		return steps[activeStepIndex - 1];
	}, [activeStepIndex, steps]);
	const followingStep = useMemo(() => {
		if (activeStepIndex < 0 || activeStepIndex + 1 >= steps.length) {
			return undefined;
		}
		return steps[activeStepIndex + 1];
	}, [activeStepIndex, steps]);
	const completedSteps = useMemo(() => {
		if (onboardingData === undefined) {
			return 0;
		}
		return steps.filter(step => onboardingData[step.key]).length;
	}, [onboardingData, steps]);
	const complete = isOnboardingComplete(onboardingData);

	return (
		<div className={"flex flex-col gap-6"}>
			{ onboardingData &&
				<Card>
					<h2 className={"text-xl font-bold tracking-tight mb-2"}>Onboarding</h2>
					<p className={"text-sm text-subtext-1 mb-6"}>
						{ complete ? "Configuration terminee." : `${completedSteps}/${steps.length} etapes completees` }
					</p>

					<div className={"flex flex-col gap-4"}>
						{ steps.map((step, index) =>
							<div key={step.key} className={"flex items-start gap-3 p-3 rounded-xl border border-surface-2/20 bg-surface-0/20"}>
								{ onboardingData[step.key] ?
									<CheckCircle2 className={"text-green mt-0.5"} size={18} /> :
									<CircleDashed className={"text-blue mt-0.5"} size={18} /> }
								<div className={"flex flex-col gap-0.5 min-w-0"}>
									<p className={"text-sm font-semibold text-text"}>{ index + 1 }. { step.title }</p>
									<p className={"text-sm text-subtext-1"}>{ step.description }</p>
								</div>
							</div>) }
					</div>

					{ !complete && activeStep?.entryPath &&
						<div className={"mt-6 pt-4 border-t border-surface-2/20"}>
							<div className={"flex items-center gap-3"}>
								<button
									className={"text-sm font-semibold text-subtext-1 hover:text-text transition-all disabled:opacity-40 disabled:cursor-default"}
									disabled={advancing || previousStep?.entryPath === undefined}
									onClick={() => {
										if (previousStep?.entryPath !== undefined) {
											navigate(previousStep.entryPath);
										}
									}}
								>
									Precedent
								</button>
								<button
									className={"text-sm font-semibold text-blue hover:brightness-110 transition-all disabled:opacity-60 disabled:cursor-default"}
									disabled={advancing}
									onClick={async () => {
										if (onboardingData === undefined || activeStep === undefined || advancing) {
											return;
										}
										setAdvancing(true);
										if (onboardingData[activeStep.key] === false) {
											await completeOnboardingStep(activeStep.key);
										}
										if (followingStep?.entryPath !== undefined) {
											navigate(followingStep.entryPath);
										} else {
											navigate("/");
										}
										setAdvancing(false);
									}}
								>
									{ followingStep === undefined ? "Terminer" : `Continuer: ${followingStep.title}` }
								</button>
							</div>
						</div> }
				</Card> }
		</div>
	);
}
