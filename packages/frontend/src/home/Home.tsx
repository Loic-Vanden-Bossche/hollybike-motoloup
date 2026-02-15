/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { useApi } from "../utils/useApi.ts";
import { TOnboarding } from "../types/TOnboarding.ts";
import { TAssociationInsights } from "../types/TAssociationInsights.ts";
import {
	matchPath,
	useLocation,
	useNavigate,
} from "react-router-dom";
import { useUser } from "../user/useUser.tsx";
import {
	useEffect,
	useMemo, useState,
} from "preact/hooks";
import { EChart } from "../components/Chart/EChart.tsx";
import { EChartsCoreOption } from "echarts/core";
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
import { useTheme } from "../theme/context.tsx";
import { useSystemDarkMode } from "../utils/systemDarkMode.ts";

export function Home() {
	const onboarding = useApi<TOnboarding>("/associations/me/onboarding", []);
	const insights = useApi<TAssociationInsights>("/associations/me/insights", []);
	const onboardingData = onboarding.data;
	const insightsData = insights.data;
	const location = useLocation();
	const navigate = useNavigate();
	const [advancing, setAdvancing] = useState(false);
	const [showOnboardingSummary, setShowOnboardingSummary] = useState(false);
	const user = useUser();
	const theme = useTheme();
	const systemDark = useSystemDarkMode();

	const themeDark = useMemo(
		() => theme.theme === "dark" || theme.theme === "os" && systemDark,
		[theme.theme, systemDark],
	);

	const chartColors = useMemo(() => {
		const fallback = {
			text: themeDark ? "rgb(186, 194, 222)" : "rgb(92, 95, 119)",
			textStrong: themeDark ? "rgb(205, 214, 244)" : "rgb(76, 79, 105)",
			axisLine: themeDark ? "rgba(88, 91, 112, 0.5)" : "rgba(172, 176, 190, 0.5)",
			splitLine: themeDark ? "rgba(88, 91, 112, 0.25)" : "rgba(172, 176, 190, 0.25)",
			tooltipBg: themeDark ? "rgba(24,24,37,0.95)" : "rgba(239,241,245,0.95)",
			tooltipBorder: themeDark ? "rgba(108,112,134,0.5)" : "rgba(172,176,190,0.55)",
			tooltipText: themeDark ? "rgba(205,214,244,1)" : "rgba(76,79,105,1)",
			blue: themeDark ? "rgba(137, 180, 250, 0.95)" : "rgba(30, 102, 245, 0.95)",
			yellow: themeDark ? "rgba(249, 226, 175, 0.95)" : "rgba(223, 142, 29, 0.95)",
			green: themeDark ? "rgba(166, 227, 161, 0.95)" : "rgba(64, 160, 43, 0.95)",
			teal: themeDark ? "rgba(148, 226, 213, 0.95)" : "rgba(23, 146, 153, 0.95)",
			red: themeDark ? "rgba(243, 139, 168, 0.95)" : "rgba(210, 15, 57, 0.95)",
			lavender: themeDark ? "rgba(180, 190, 254, 0.95)" : "rgba(114, 135, 253, 0.95)",
			mauve: themeDark ? "rgba(203, 166, 247, 0.95)" : "rgba(136, 57, 239, 0.95)",
			surface: themeDark ? "rgba(88, 91, 112, 0.9)" : "rgba(172, 176, 190, 0.9)",
		};

		if (typeof window === "undefined") {
			return fallback;
		}

		const root = document.querySelector("main") ?? document.documentElement;
		const styles = window.getComputedStyle(root);
		const read = (name: string, defaultValue: string) => {
			const value = styles.getPropertyValue(name).trim();
			return value.length === 0 ? defaultValue : value;
		};
		const rgb = (name: string, defaultValue: string) => `rgb(${read(name, defaultValue)})`;
		const rgba = (name: string, alpha: number, defaultValue: string) => `rgba(${read(name, defaultValue)}, ${alpha})`;

		return {
			text: rgb("--color-subtext-1", themeDark ? "186, 194, 222" : "92, 95, 119"),
			textStrong: rgb("--color-text", themeDark ? "205, 214, 244" : "76, 79, 105"),
			axisLine: rgba("--color-surface-2", 0.5, themeDark ? "88, 91, 112" : "172, 176, 190"),
			splitLine: rgba("--color-surface-2", 0.25, themeDark ? "88, 91, 112" : "172, 176, 190"),
			tooltipBg: themeDark ? "rgba(24,24,37,0.95)" : "rgba(239,241,245,0.95)",
			tooltipBorder: rgba("--color-overlay-0", 0.5, themeDark ? "108, 112, 134" : "156, 160, 176"),
			tooltipText: rgb("--color-text", themeDark ? "205, 214, 244" : "76, 79, 105"),
			blue: rgba("--color-blue", 0.95, themeDark ? "137, 180, 250" : "30, 102, 245"),
			yellow: rgba("--color-yellow", 0.95, themeDark ? "249, 226, 175" : "223, 142, 29"),
			green: rgba("--color-green", 0.95, themeDark ? "166, 227, 161" : "64, 160, 43"),
			teal: rgba("--color-teal", 0.95, themeDark ? "148, 226, 213" : "23, 146, 153"),
			red: rgba("--color-red", 0.95, themeDark ? "243, 139, 168" : "210, 15, 57"),
			lavender: rgba("--color-lavender", 0.95, themeDark ? "180, 190, 254" : "114, 135, 253"),
			mauve: rgba("--color-mauve", 0.95, themeDark ? "203, 166, 247" : "136, 57, 239"),
			surface: rgba("--color-surface-2", 0.9, themeDark ? "88, 91, 112" : "172, 176, 190"),
		};
	}, [themeDark]);

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

	useEffect(() => {
		if (!complete) {
			setShowOnboardingSummary(false);
			return;
		}

		const shouldShow = sessionStorage.getItem("show_onboarding_summary") === "1";
		if (shouldShow) {
			setShowOnboardingSummary(true);
			sessionStorage.removeItem("show_onboarding_summary");
		} else {
			setShowOnboardingSummary(false);
		}
	}, [complete]);

	const eventsByMonthOption = useMemo<EChartsCoreOption | undefined>(() => {
		if (insightsData === undefined) {
			return undefined;
		}

		const months = Array.from(new Set(insightsData.events_by_month.map(item => `${item.year}-${item.month.toString().padStart(2, "0")}`)))
			.sort();
		const countByMonthAndStatus = new Map<string, number>();
		insightsData.events_by_month.forEach((item) => {
			const monthKey = `${item.year}-${item.month.toString().padStart(2, "0")}`;
			countByMonthAndStatus.set(`${monthKey}-${item.status}`, item.count);
		});
		const statuses = [
			{
				key: "scheduled",
				label: "Planifies",
				color: chartColors.blue,
			},
			{
				key: "pending",
				label: "En attente",
				color: chartColors.yellow,
			},
			{
				key: "now",
				label: "En cours",
				color: chartColors.green,
			},
			{
				key: "finished",
				label: "Termines",
				color: chartColors.teal,
			},
			{
				key: "cancelled",
				label: "Annules",
				color: chartColors.red,
			},
		];

		return {
			tooltip: {
				trigger: "axis",
				backgroundColor: chartColors.tooltipBg,
				borderColor: chartColors.tooltipBorder,
				textStyle: { color: chartColors.tooltipText },
			},
			grid: {
				left: 8,
				right: 8,
				bottom: 0,
				top: 48,
				containLabel: true,
			},
			legend: {
				top: 8,
				textStyle: { color: chartColors.text },
			},
			xAxis: {
				type: "category",
				data: months,
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
			},
			yAxis: {
				type: "value",
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
				splitLine: { lineStyle: { color: chartColors.splitLine } },
			},
			series: statuses.map(status => ({
				name: status.label,
				type: "bar",
				stack: "events",
				barMaxWidth: 30,
				itemStyle: { color: status.color, borderRadius: [
					4,
					4,
					0,
					0,
				] },
				data: months.map(month => countByMonthAndStatus.get(`${month}-${status.key}`) ?? 0),
			})),
		};
	}, [
		insightsData,
		chartColors.axisLine,
		chartColors.splitLine,
		chartColors.text,
		chartColors.tooltipBg,
		chartColors.tooltipBorder,
		chartColors.tooltipText,
	]);

	const invitationFunnelOption = useMemo<EChartsCoreOption | undefined>(() => {
		if (insightsData === undefined) {
			return undefined;
		}

		const labels = [
			"Crees",
			"Actifs",
			"Utilises",
			"Expires",
			"Desactives",
			"Satures",
		];
		const values = [
			insightsData.invitation_funnel.total_created,
			insightsData.invitation_funnel.active_links,
			insightsData.invitation_funnel.used_links,
			insightsData.invitation_funnel.expired_links,
			insightsData.invitation_funnel.disabled_links,
			insightsData.invitation_funnel.saturated_links,
		];

		return {
			tooltip: {
				trigger: "axis",
				axisPointer: { type: "shadow" },
				backgroundColor: chartColors.tooltipBg,
				borderColor: chartColors.tooltipBorder,
				textStyle: { color: chartColors.tooltipText },
			},
			grid: {
				left: 8,
				right: 20,
				bottom: 0,
				top: 12,
				containLabel: true,
			},
			xAxis: {
				type: "value",
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
				splitLine: { lineStyle: { color: chartColors.splitLine } },
			},
			yAxis: {
				type: "category",
				data: labels,
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
			},
			series: [
				{
					type: "bar",
					data: values,
					itemStyle: {
						color: chartColors.lavender,
						borderRadius: 8,
					},
					barWidth: "55%",
				},
			],
		};
	}, [
		insightsData,
		chartColors.axisLine,
		chartColors.splitLine,
		chartColors.text,
		chartColors.tooltipBg,
		chartColors.tooltipBorder,
		chartColors.tooltipText,
	]);

	const journeyAdoptionOption = useMemo<EChartsCoreOption | undefined>(() => {
		if (insightsData === undefined) {
			return undefined;
		}

		const withJourney = insightsData.journey_adoption.total_events_with_journey;
		const withoutJourney = Math.max(0, insightsData.journey_adoption.total_events - withJourney);

		return {
			tooltip: {
				trigger: "item",
				backgroundColor: chartColors.tooltipBg,
				borderColor: chartColors.tooltipBorder,
				textStyle: { color: chartColors.tooltipText },
			},
			title: {
				text: `${insightsData.journey_adoption.adoption_rate_percent.toFixed(1)}%`,
				subtext: "Adoption",
				left: "center",
				top: "38%",
				textStyle: {
					fontSize: 26,
					fontWeight: 800,
					color: chartColors.textStrong,
				},
				subtextStyle: {
					color: chartColors.text,
					fontSize: 12,
				},
			},
			legend: {
				bottom: 0,
				textStyle: { color: chartColors.text },
			},
			series: [
				{
					type: "pie",
					radius: [
						"52%",
						"72%",
					],
					avoidLabelOverlap: true,
					label: { show: false },
					data: [
						{
							value: withJourney,
							name: "Avec trajet",
							itemStyle: { color: chartColors.green },
						},
						{
							value: withoutJourney,
							name: "Sans trajet",
							itemStyle: { color: chartColors.surface },
						},
					],
				},
			],
		};
	}, [
		insightsData,
		chartColors.text,
		chartColors.tooltipBg,
		chartColors.tooltipBorder,
		chartColors.tooltipText,
	]);

	const userStatusOption = useMemo<EChartsCoreOption | undefined>(() => {
		if (insightsData === undefined) {
			return undefined;
		}

		const labelByKey: Record<string, string> = {
			enabled: "Actifs",
			disabled: "Desactives",
		};

		return {
			tooltip: {
				trigger: "item",
				backgroundColor: chartColors.tooltipBg,
				borderColor: chartColors.tooltipBorder,
				textStyle: { color: chartColors.tooltipText },
			},
			legend: {
				bottom: 0,
				textStyle: { color: chartColors.text },
			},
			series: [
				{
					type: "pie",
					radius: "68%",
					center: [
						"50%",
						"45%",
					],
					data: insightsData.users_by_status.map(bucket => ({
						value: bucket.count,
						name: labelByKey[bucket.key] ?? bucket.key,
						itemStyle: {
							color: bucket.key === "enabled" ? chartColors.blue : chartColors.red,
						},
					})),
					label: {
						color: chartColors.textStrong,
						formatter: "{d}%",
					},
				},
			],
		};
	}, [
		insightsData,
		chartColors.text,
		chartColors.tooltipBg,
		chartColors.tooltipBorder,
		chartColors.tooltipText,
	]);

	const lastLoginOption = useMemo<EChartsCoreOption | undefined>(() => {
		if (insightsData === undefined) {
			return undefined;
		}

		const labelByKey: Record<string, string> = {
			"0_7_days": "0-7j",
			"8_30_days": "8-30j",
			"31_90_days": "31-90j",
			"91_plus_days": "91j+",
		};

		return {
			tooltip: {
				trigger: "axis",
				axisPointer: { type: "shadow" },
				backgroundColor: chartColors.tooltipBg,
				borderColor: chartColors.tooltipBorder,
				textStyle: { color: chartColors.tooltipText },
			},
			grid: {
				left: 8,
				right: 8,
				bottom: 0,
				top: 12,
				containLabel: true,
			},
			xAxis: {
				type: "category",
				data: insightsData.user_last_login_buckets.map(bucket => labelByKey[bucket.key] ?? bucket.key),
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
			},
			yAxis: {
				type: "value",
				axisLabel: { color: chartColors.text },
				axisLine: { lineStyle: { color: chartColors.axisLine } },
				splitLine: { lineStyle: { color: chartColors.splitLine } },
			},
			series: [
				{
					type: "bar",
					data: insightsData.user_last_login_buckets.map(bucket => bucket.count),
					barMaxWidth: 40,
					itemStyle: {
						color: chartColors.mauve,
						borderRadius: [
							8,
							8,
							0,
							0,
						],
					},
				},
			],
		};
	}, [
		insightsData,
		chartColors.axisLine,
		chartColors.splitLine,
		chartColors.text,
		chartColors.tooltipBg,
		chartColors.tooltipBorder,
		chartColors.tooltipText,
	]);

	return (
		<div className={"flex flex-col gap-6"}>
			{ onboardingData && showOnboardingSummary &&
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

			<Card>
				<div className={"flex flex-col gap-1 mb-4"}>
					<h2 className={"text-xl font-bold tracking-tight"}>Insights association</h2>
					<p className={"text-sm text-subtext-1"}>
						Vue operationnelle des evenements, invitations, trajets et utilisateurs.
					</p>
				</div>

				{ insights.status === 0 &&
					<p className={"text-sm text-subtext-1"}>Chargement des insights...</p> }

				{ insights.status !== 0 && insights.status !== 200 &&
					<p className={"text-sm text-red"}>
						Impossible de charger les insights ({ insights.message ?? `code ${insights.status}` }).
					</p> }

				{ insights.status === 200 && insightsData && eventsByMonthOption && invitationFunnelOption && journeyAdoptionOption && userStatusOption && lastLoginOption &&
					<div className={"grid grid-cols-1 xl:grid-cols-2 gap-4 sm:gap-6"}>
						<Card className={"bg-surface-0/15"}>
							<h3 className={"text-base font-semibold text-text mb-1"}>Evenements par mois</h3>
							<p className={"text-xs text-subtext-1 mb-3"}>Volume mensuel par statut</p>
							<EChart option={eventsByMonthOption} height={320} />
						</Card>

						<Card className={"bg-surface-0/15"}>
							<h3 className={"text-base font-semibold text-text mb-1"}>Funnel invitations</h3>
							<p className={"text-xs text-subtext-1 mb-3"}>Creation, activite et usure des liens</p>
							<EChart option={invitationFunnelOption} height={320} />
						</Card>

						<Card className={"bg-surface-0/15"}>
							<h3 className={"text-base font-semibold text-text mb-1"}>Adoption des trajets</h3>
							<p className={"text-xs text-subtext-1 mb-3"}>Part des evenements relies a un trajet</p>
							<EChart option={journeyAdoptionOption} height={320} />
						</Card>

						<Card className={"bg-surface-0/15"}>
							<h3 className={"text-base font-semibold text-text mb-1"}>Utilisateurs</h3>
							<p className={"text-xs text-subtext-1 mb-3"}>Statut des comptes et recence de connexion</p>
							<div className={"grid grid-cols-1 gap-4"}>
								<EChart option={userStatusOption} height={250} />
								<EChart option={lastLoginOption} height={230} />
							</div>
						</Card>
					</div> }
			</Card>
		</div>
	);
}
