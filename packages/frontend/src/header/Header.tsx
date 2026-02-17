/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Theme } from "../theme/context.tsx";
import {
	DropDown,
	DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import { useUser } from "../user/useUser.tsx";
import { useAuth } from "../auth/context.tsx";
import { useMemo } from "preact/hooks";
import {
	Sun, Moon, Monitor, Menu,
} from "lucide-preact";
import { ReactElement } from "react";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import "./Header.css";
import { clsx } from "clsx";
import {
	matchPath, useLocation, useNavigate,
} from "react-router-dom";
import { useOnboardingMode } from "../home/OnboardingModeContext.tsx";

interface HeaderProps { setTheme: (theme: Theme) => void }

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	const { user } = useUser();
	const { disconnect } = useAuth();
	const { setVisible } = useSideBar();
	const { onboardingMode } = useOnboardingMode();
	const location = useLocation();
	const navigate = useNavigate();

	const pageMeta = useMemo(() => {
		const { pathname } = location;

		const rules: {
			pattern: string,
			title: string,
			subtitle: string
		}[] = [
			{
				pattern: "/",
				title: "Tableau de bord",
				subtitle: "Vue d'ensemble de votre espace",
			},
			{
				pattern: "/associations",
				title: "Associations",
				subtitle: "Gérez les organisations et leurs paramètres",
			},
			{
				pattern: "/associations/new",
				title: "Nouvelle association",
				subtitle: "Créez une nouvelle structure",
			},
			{
				pattern: "/associations/:id/invitations",
				title: "Invitations",
				subtitle: "Suivez et gérez les invitations",
			},
			{
				pattern: "/associations/:id/users",
				title: "Utilisateurs",
				subtitle: "Administrez les comptes membres",
			},
			{
				pattern: "/associations/:id/events",
				title: "Événements",
				subtitle: "Planifiez et suivez les événements",
			},
			{
				pattern: "/associations/:id/journeys",
				title: "Bibliothèque de trajets",
				subtitle: "Organisez les itinéraires de l'association",
			},
			{
				pattern: "/associations/:id",
				title: "Association",
				subtitle: "Détails et configuration de l'association",
			},
			{
				pattern: "/users",
				title: "Utilisateurs",
				subtitle: "Administrez les comptes et accès",
			},
			{
				pattern: "/users/:id",
				title: "Profil utilisateur",
				subtitle: "Consultez et modifiez les informations du compte",
			},
			{
				pattern: "/invitations",
				title: "Invitations",
				subtitle: "Gérez les invitations en cours",
			},
			{
				pattern: "/invitations/new",
				title: "Nouvelle invitation",
				subtitle: "Créez une invitation membre",
			},
			{
				pattern: "/events",
				title: "Événements",
				subtitle: "Liste et statut des événements",
			},
			{
				pattern: "/events/new",
				title: "Créer un événement",
				subtitle: "Préparez un nouvel événement",
			},
			{
				pattern: "/events/:id",
				title: "Détail de l'événement",
				subtitle: "Informations, participants et suivi",
			},
			{
				pattern: "/user-journey/:id",
				title: "Parcours utilisateur",
				subtitle: "Visualisez les données de trajet",
			},
			{
				pattern: "/journeys",
				title: "Bibliothèque de trajets",
				subtitle: "Gérez vos fichiers GPX et GeoJSON",
			},
			{
				pattern: "/journeys/new",
				title: "Nouveau trajet",
				subtitle: "Importez un nouvel itinéraire",
			},
			{
				pattern: "/journeys/view/:id",
				title: "Détail du trajet",
				subtitle: "Consultez les informations du parcours",
			},
			{
				pattern: "/conf",
				title: "Configuration",
				subtitle: "Paramètres techniques de l'application",
			},

			{
				pattern: "/account/delete",
				title: "Suppression du compte",
				subtitle: "Supprimez votre compte de maniere definitive",
			},
		];

		const match = rules.find(rule => matchPath({
			path: rule.pattern,
			end: true,
		}, pathname));
		if (match) {
			return {
				title: match.title,
				subtitle: match.subtitle,
			};
		}

		return {
			title: "Administration",
			subtitle: "Gestion de votre plateforme",
		};
	}, [location.pathname]);

	const dropdownOptions = useMemo<[Theme, ReactElement, string][]>(
		() => [
			[
				"light",
				<Sun size={16} />,
				"Clair",
			],
			[
				"dark",
				<Moon size={16} />,
				"Sombre",
			],
			[
				"os",
				<Monitor size={16} />,
				"Système",
			],
		],
		[],
	);

	return (
		<header className={"flex flex-col sm:flex-row sm:items-center justify-between gap-3 sm:gap-4 relative z-10"}>
			<div className={"flex items-center gap-3 min-w-0 w-full sm:w-auto"}>
				<button
					className={clsx(
						"md:!hidden",
						"flex items-center gap-2 px-4 py-2 rounded-xl",
						"ui-trigger",
						"text-text hover:bg-surface-0/60 transition-all",
					)}
					onClick={() => setVisible(true)}
				>
					<Menu size={18} />
					<span className={"text-sm"}>Menu</span>
				</button>
				<div className={"min-w-0"}>
					<h1 className={"text-lg md:text-2xl font-bold tracking-tight leading-tight truncate"}>
						{ pageMeta.title }
					</h1>
					<p className={"hidden sm:block text-sm text-subtext-1 truncate"}>
						{ pageMeta.subtitle }
					</p>
				</div>
			</div>
			<div className={"flex items-center gap-2 sm:gap-3 w-full sm:w-auto justify-end"}>
				{ onboardingMode &&
					<span className={"inline-flex text-xs px-2.5 sm:px-3 py-2 rounded-xl border border-blue/30 bg-blue/10 text-blue font-semibold whitespace-nowrap"}>
						Onboarding requis
					</span> }
				<DropDown text={"Theme"}>
					{ dropdownOptions.map(([
						theme,
						icon,
						text,
					]) =>
						<DropDownElement
							onClick={(e) => {
								e.stopPropagation();
								setTheme(theme);
							}}
						>
							{ icon }
							{ text }
						</DropDownElement>) }
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={() => navigate("/account/delete")}>Supprimer mon compte</DropDownElement>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
