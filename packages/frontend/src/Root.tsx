/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Header } from "./header/Header.tsx";
import { useTheme } from "./theme/context.tsx";
import {
	matchPath, Outlet, useLocation, useNavigate,
} from "react-router-dom";
import { SideBar } from "./sidebar/SideBar.tsx";
import { clsx } from "clsx";
import {
	useCallback, useEffect, useMemo, useState,
} from "preact/hooks";
import { useUser } from "./user/useUser.tsx";
import { TOnboarding } from "./types/TOnboarding.ts";
import { api } from "./utils/useApi.ts";
import {
	getNextOnboardingStep,
	getOnboardingSteps,
	isOnboardingComplete,
} from "./home/onboardingFlow.ts";
import { OnboardingModeContext } from "./home/OnboardingModeContext.tsx";
import {
	completeOnboardingStep,
	ONBOARDING_REFRESH_EVENT,
} from "./home/onboardingActions.ts";

export function Root() {
	const theme = useTheme();
	const { user } = useUser();
	const location = useLocation();
	const navigate = useNavigate();
	const [onboarding, setOnboarding] = useState<TOnboarding | undefined>(undefined);
	const [onboardingLoading, setOnboardingLoading] = useState(false);
	const [advancing, setAdvancing] = useState(false);

	const onboardingSteps = useMemo(
		() => getOnboardingSteps({
			userId: user?.id,
			associationId: user?.association?.id,
		}),
		[user?.id, user?.association?.id],
	);

	const refreshOnboarding = useCallback(async () => {
		if (user?.id === undefined || user?.association?.id === undefined) {
			setOnboarding(undefined);
			return;
		}

		setOnboardingLoading(true);
		const res = await api<TOnboarding>("/associations/me/onboarding");
		if (res.status === 200 && res.data !== undefined) {
			setOnboarding(res.data);
		} else {
			setOnboarding(undefined);
		}
		setOnboardingLoading(false);
	}, [user?.id, user?.association?.id]);

	useEffect(() => {
		refreshOnboarding();
	}, [refreshOnboarding, location.pathname]);

	useEffect(() => {
		const onRefresh = () => {
			refreshOnboarding();
		};

		window.addEventListener(ONBOARDING_REFRESH_EVENT, onRefresh);
		return () => {
			window.removeEventListener(ONBOARDING_REFRESH_EVENT, onRefresh);
		};
	}, [refreshOnboarding]);

	useEffect(() => {
		if (onboardingLoading) {
			return;
		}

		const nextStep = getNextOnboardingStep(onboarding, onboardingSteps);
		if (nextStep === undefined) {
			return;
		}

		const isAllowed = onboardingSteps.some(step =>
			step.allowedPathPatterns.some(pattern => matchPath({
				path: pattern,
				end: true,
			}, location.pathname) !== null));
		if (!isAllowed && nextStep.entryPath !== undefined && location.pathname !== nextStep.entryPath) {
			navigate(nextStep.entryPath);
		}
	}, [
		location.pathname,
		navigate,
		onboarding,
		onboardingLoading,
		onboardingSteps,
	]);

	const nextStep = useMemo(() => getNextOnboardingStep(onboarding, onboardingSteps), [onboarding, onboardingSteps]);
	const activeStepIndex = useMemo(() => {
		const byPath = onboardingSteps.findIndex(step =>
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
		return onboardingSteps.findIndex(step => step.key === nextStep.key);
	}, [
		location.pathname,
		nextStep,
		onboardingSteps,
	]);
	const activeStep = useMemo(() => {
		if (activeStepIndex < 0 || activeStepIndex >= onboardingSteps.length) {
			return undefined;
		}
		return onboardingSteps[activeStepIndex];
	}, [activeStepIndex, onboardingSteps]);
	const previousStep = useMemo(() => {
		if (activeStepIndex <= 0) {
			return undefined;
		}
		return onboardingSteps[activeStepIndex - 1];
	}, [activeStepIndex, onboardingSteps]);
	const followingStep = useMemo(() => {
		if (activeStepIndex < 0 || activeStepIndex + 1 >= onboardingSteps.length) {
			return undefined;
		}
		return onboardingSteps[activeStepIndex + 1];
	}, [activeStepIndex, onboardingSteps]);
	const onboardingMode = useMemo(
		() => !onboardingLoading && !isOnboardingComplete(onboarding) && nextStep !== undefined,
		[
			onboarding,
			onboardingLoading,
			nextStep,
		],
	);

	return (
		<OnboardingModeContext.Provider
			value={{
				loading: onboardingLoading,
				onboardingMode,
				onboarding,
				nextStep,
			}}
		>
			<div
				className={clsx(
					"bg-mantle overflow-hidden min-h-full p-4 md:p-8",
					"flex flex-col gap-6 md:pl-60",
					"transition-all duration-200 relative",
				)}
			>
				{ /* Background blobs for glassmorphism ambient depth */ }
				<div className="fixed top-[-10%] left-[-10%] w-[40%] h-[40%] bg-mauve/10 blur-[120px] rounded-full pointer-events-none" />
				<div className="fixed bottom-[0%] right-[-5%] w-[35%] h-[35%] bg-blue/10 blur-[120px] rounded-full pointer-events-none" />
				<div className="fixed top-[20%] right-[10%] w-[25%] h-[25%] bg-pink/5 blur-[100px] rounded-full pointer-events-none" />

				<Header setTheme={theme.set}/>
				{ onboardingMode &&
					<div className={"ui-glass-panel border-blue/30 bg-blue/10 px-5 py-4 flex flex-col md:flex-row md:items-center md:justify-between gap-3"}>
						<div className={"min-w-0"}>
							<h2 className={"text-base md:text-lg font-bold tracking-tight text-blue"}>
								Mode onboarding actif
							</h2>
							<p className={"text-sm text-subtext-1"}>
								{ activeStep?.title !== undefined && activeStep?.description !== undefined ?
									`Etape en cours: ${activeStep.title}. ${activeStep.description} Quand c'est valide, cliquez sur Continuer pour passer a l'etape suivante.` :
									"Suivez les etapes d'onboarding pour finaliser la configuration." }
							</p>
						</div>
						{ activeStep &&
							<div className={"flex items-center gap-2"}>
								<button
									className={"ui-trigger px-4 py-2 font-semibold text-subtext-1 border-surface-2/40 hover:border-surface-2/60 whitespace-nowrap disabled:opacity-40 disabled:cursor-default"}
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
									className={"ui-trigger px-4 py-2 font-semibold text-blue border-blue/40 hover:border-blue/50 whitespace-nowrap disabled:opacity-60 disabled:cursor-default"}
									disabled={advancing}
									onClick={async () => {
										if (onboarding === undefined || activeStep === undefined || advancing) {
											return;
										}
										setAdvancing(true);
										if (onboarding[activeStep.key] === false) {
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
							</div> }
					</div> }
				<Outlet/>
			</div>
			<SideBar/>
		</OnboardingModeContext.Provider>
	);
}
