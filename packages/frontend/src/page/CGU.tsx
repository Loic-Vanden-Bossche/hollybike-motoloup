
/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";
import {
	Building2,
	ChevronDown,
	Copy,
	FileText,
	Mail,
	Scale,
	ShieldCheck,
	ArrowUp, Search, X,
} from "lucide-preact";
import { useRef } from "react";

interface PolicySection {
	id: string;
	title: string;
	paragraphs: string[];
}

const LAST_UPDATE = "17/02/2026";

const sections: PolicySection[] = [
	{
		id: "introduction",
		title: "1. Objet",
		paragraphs: ["La présente page décrit (i) les conditions générales d’utilisation de HollyBike et (ii) la politique de confidentialité applicable au site https://hollybike.chbrx.com et à l’application mobile HollyBike.", "En utilisant HollyBike, vous acceptez les présentes conditions. Si vous n’acceptez pas tout ou partie de ces conditions, vous devez cesser d’utiliser le service."],
	},
	{
		id: "responsable-traitement",
		title: "2. Responsable du traitement et contact",
		paragraphs: ["Le responsable du traitement des données personnelles est Loïc Vanden Bossche (personne physique), domicilié à Paris (75012), France.", "Contact (exercice des droits / questions) : vandenbosscheloic4@gmail.com."],
	},
	{
		id: "services",
		title: "3. Services proposés",
		paragraphs: ["HollyBike permet notamment : la création de compte, l’enregistrement de trajets, la visualisation de trajets, la participation à des événements, et le partage (optionnel) de position avec d’autres utilisateurs.", "Certaines fonctionnalités peuvent nécessiter l’activation de permissions (ex. localisation, caméra/photos, calendrier)."],
	},
	{
		id: "donnees-collectees",
		title: "4. Données collectées",
		paragraphs: [
			"Données de compte : email, mot de passe (stocké de manière chiffrée), pseudonyme.",
			"Données de trajet : points GPS, vitesse, altitude, horodatages, distance, durée. Ces données permettent de reconstituer et afficher le trajet (ex. type Strava).",
			"Données techniques : adresse IP et logs techniques, utilisés pour la sécurité et le bon fonctionnement du service.",
			"HollyBike n’utilise pas d’analytics publicitaires ni de profilage à des fins marketing.",
		],
	},
	{
		id: "localisation",
		title: "5. Localisation (y compris en arrière-plan) — Information importante",
		paragraphs: [
			"HollyBike peut accéder à votre localisation précise (ACCESS_FINE_LOCATION) et, si vous l’autorisez, à votre localisation en arrière-plan (ACCESS_BACKGROUND_LOCATION).",
			"La localisation est optionnelle : vous pouvez utiliser HollyBike sans activer la fonctionnalité de suivi/enregistrement de trajet.",
			"La localisation en arrière-plan est utilisée uniquement lorsque vous déclenchez explicitement un enregistrement de trajet et pendant la durée de cet enregistrement. Elle n’est jamais collectée en arrière-plan sans action volontaire de votre part.",
			"Finalités : enregistrer un trajet, afficher votre progression, et (si vous l’activez) partager votre position en temps réel avec des amis / participants à un événement.",
			"Vous pouvez désactiver à tout moment la collecte : en arrêtant l’enregistrement de trajet et/ou en retirant la permission de localisation dans les paramètres Android.",
		],
	},
	{
		id: "partage-visibilite",
		title: "6. Partage et visibilité des trajets / position",
		paragraphs: ["Les trajets et la position sont liés à votre compte. Vous choisissez la visibilité (public / privé) selon les options disponibles dans l’application.", "Si vous activez le partage (ex. événement), votre position et/ou vos trajets peuvent être visibles par d’autres utilisateurs. Vous pouvez modifier vos choix et désactiver le partage à tout moment."],
	},
	{
		id: "permissions-optionnelles",
		title: "7. Permissions optionnelles",
		paragraphs: ["Caméra / Photos : permet d’ajouter des images aux trajets. Permission facultative.", "Calendrier : permet d’ajouter des événements à votre calendrier. Permission facultative."],
	},
	{
		id: "base-legale",
		title: "8. Bases légales (RGPD)",
		paragraphs: [
			"Exécution du contrat : fourniture du service (création de compte, enregistrement et affichage des trajets, gestion des événements).",
			"Consentement : utilisation de la localisation (notamment en arrière-plan) et partage volontaire avec d’autres utilisateurs ; vous pouvez retirer votre consentement à tout moment via les paramètres de l’application/du système.",
			"Intérêt légitime : sécurité, prévention des abus, maintien en conditions opérationnelles, et protection du service (logs techniques).",
		],
	},
	{
		id: "tiers",
		title: "9. Prestataires et services tiers",
		paragraphs: [
			"Mapbox : utilisé pour l’affichage des cartes (SDK Android et appels HTTP). Mapbox peut traiter des données techniques (ex. IP) et, selon l’usage, des données de localisation nécessaires au rendu cartographique.",
			"Nominatim (OpenStreetMap) : utilisé côté serveur pour le reverse geocoding (conversion coordonnées → adresse).",
			"En dehors de ces prestataires, HollyBike ne vend pas vos données et ne les partage pas à des fins publicitaires.",
		],
	},
	{
		id: "hebergement",
		title: "10. Hébergement et transferts",
		paragraphs: ["Les données sont hébergées sur un serveur situé en France.", "Si un prestataire tiers traite certaines données (ex. Mapbox), il peut appliquer ses propres politiques de traitement. HollyBike limite ces usages aux besoins strictement nécessaires aux fonctionnalités (cartographie)."],
	},
	{
		id: "conservation",
		title: "11. Durée de conservation",
		paragraphs: [
			"Compte utilisateur : conservé jusqu’à suppression du compte par l’utilisateur.",
			"Trajets : conservés tant que l’utilisateur souhaite les garder dans sa bibliothèque ; suppression possible à tout moment.",
			"Conversion / points GPS : les données de position collectées pendant un trajet sont converties en fichier GPX. Les trajets peuvent être supprimés à tout moment par l’utilisateur.",
			"Suppression de compte : suppression immédiate des données actives. Les sauvegardes (backups) sont purgées sous 30 jours maximum.",
		],
	},
	{
		id: "securite",
		title: "12. Sécurité",
		paragraphs: [
			"Les échanges sont protégés via HTTPS.",
			"L’accès aux serveurs est restreint et protégé (mesures techniques et organisationnelles).",
			"Aucun système n’étant infaillible, HollyBike met en œuvre des mesures raisonnables pour protéger les données contre l’accès non autorisé, l’altération ou la destruction.",
		],
	},
	{
		id: "droits",
		title: "13. Vos droits (RGPD)",
		paragraphs: [
			"Vous disposez des droits : accès, rectification, suppression, limitation, opposition, et portabilité.",
			"Vous pouvez exporter vos données depuis les fonctionnalités disponibles et/ou faire une demande par email.",
			"Vous pouvez supprimer vos trajets et votre compte à tout moment. Pour toute demande : vandenbosscheloic4@gmail.com.",
			"Vous pouvez retirer votre consentement (ex. localisation) à tout moment via les paramètres Android et/ou l’application.",
		],
	},
	{
		id: "mineurs",
		title: "14. Mineurs",
		paragraphs: ["HollyBike est destiné aux utilisateurs âgés d’au moins 16 ans. Les mineurs de moins de 16 ans ne doivent pas utiliser le service."],
	},
	{
		id: "cgu",
		title: "15. Conditions générales d’utilisation (CGU) — Règles essentielles",
		paragraphs: [
			"Vous êtes responsable de la confidentialité de vos identifiants. Toute activité réalisée depuis votre compte est réputée effectuée par vous.",
			"Vous vous engagez à utiliser HollyBike de manière licite et à ne pas publier/partager de contenu illicite ou portant atteinte aux droits de tiers.",
			"En cas d’abus ou de non-respect des présentes conditions, un administrateur peut intervenir (modération, suppression de contenu, suspension de compte).",
		],
	},
	{
		id: "responsabilite",
		title: "16. Responsabilité",
		paragraphs: [
			"HollyBike fournit un service d’enregistrement et d’affichage de trajets. Les informations sont fournies à titre indicatif.",
			"Vous êtes seul responsable de votre conduite, de votre sécurité et du respect du code de la route. HollyBike ne saurait être tenu responsable d’accidents, dommages, ou infractions commises lors de l’utilisation du service.",
			"Le service peut être interrompu pour maintenance, mise à jour ou raisons techniques. HollyBike ne garantit pas une disponibilité continue.",
		],
	},
	{
		id: "droit-applicable",
		title: "17. Droit applicable",
		paragraphs: ["Les présentes conditions sont soumises au droit français. En cas de litige et à défaut de résolution amiable, les juridictions françaises sont compétentes."],
	},
];
function cn(...classes: Array<string | false | null | undefined>) {
	return classes.filter(Boolean).join(" ");
}

function escapeRegExp(input: string) {
	return input.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function highlightText(text: string, query: string) {
	const q = query.trim();
	if (!q) { return text; }

	const re = new RegExp(`(${escapeRegExp(q)})`, "ig");
	const parts = text.split(re);
	// If no split happened, return plain text
	if (parts.length === 1) { return text; }

	return parts.map((part, i) => {
		// Matched chunk (case-insensitive)
		if (re.test(part)) {
			// reset regex state for safety
			re.lastIndex = 0;
			return (
				<mark
					key={i}
					className="rounded-[6px] px-1 py-0.5 bg-blue/15 border border-blue/20 text-text"
				>
					{ part }
				</mark>
			);
		}
		return <span key={i}>{ part }</span>;
	});
}

function useReducedMotion() {
	const [reduced, setReduced] = useState(false);
	useEffect(() => {
		const mq = window.matchMedia?.("(prefers-reduced-motion: reduce)");
		if (!mq) { return; }
		const onChange = () => setReduced(!!mq.matches);
		onChange();
		mq.addEventListener?.("change", onChange);
		return () => mq.removeEventListener?.("change", onChange);
	}, []);
	return reduced;
}

export function CGU() {
	const reducedMotion = useReducedMotion();

	// Scroll container (ton <section> est scrollable)
	const containerRef = useRef<HTMLElement | null>(null);

	const [activeId, setActiveId] = useState<string>(sections?.[0]?.id ?? "");
	const [showTop, setShowTop] = useState(false);
	const [showProgressBar, setShowProgressBar] = useState(false);
	const [mobileTocOpen, setMobileTocOpen] = useState(false);
	const [copiedId, setCopiedId] = useState<string | null>(null);

	// Progress + Search
	const [progress, setProgress] = useState(0); // 0..1
	const [query, setQuery] = useState("");

	const tocItems = useMemo(
		() =>
			sections.map(s => ({
				id: s.id,
				title: s.title,
			})),
		[],
	);

	// Search index: compute which sections match query
	const matchedSectionIds = useMemo(() => {
		const q = query.trim().toLowerCase();
		if (!q) { return null; } // no filtering
		const ids = new Set<string>();

		for (const s of sections) {
			const inTitle = s.title.toLowerCase().includes(q);
			const inBody = s.paragraphs.some(p => p.toLowerCase().includes(q));
			if (inTitle || inBody) { ids.add(s.id); }
		}
		return ids;
	}, [query]);

	const filteredToc = useMemo(() => {
		if (!matchedSectionIds) { return tocItems; }
		return tocItems.filter(t => matchedSectionIds.has(t.id));
	}, [matchedSectionIds, tocItems]);

	const filteredSections = useMemo(() => {
		if (!matchedSectionIds) { return sections; }
		return sections.filter(s => matchedSectionIds.has(s.id));
	}, [matchedSectionIds]);

	// Scroll handler for progress + back-to-top (based on container scroll)
	useEffect(() => {
		const el = containerRef.current;
		if (!el) { return; }

		const onScroll = () => {
			const max = Math.max(1, el.scrollHeight - el.clientHeight);
			const p = Math.min(1, Math.max(0, el.scrollTop / max));
			setProgress(p);
			setShowProgressBar(el.scrollTop > 40);
			setShowTop(el.scrollTop > 600);
		};

		el.addEventListener("scroll", onScroll, { passive: true });
		onScroll();
		return () => el.removeEventListener("scroll", onScroll);
	}, []);

	// Active section observer (root = scroll container)
	useEffect(() => {
		const root = containerRef.current;
		const ids = new Set(sections.map(s => s.id));
		const headings = Array.from(document.querySelectorAll<HTMLElement>("[data-policy-section]")).filter(el => ids.has(el.id));

		if (!root || !("IntersectionObserver" in window) || headings.length === 0) { return; }

		const obs = new IntersectionObserver(
			(entries) => {
				const [visible] = entries
					.filter(e => e.isIntersecting)
					.sort((a, b) => (b.intersectionRatio ?? 0) - (a.intersectionRatio ?? 0));
				if (visible?.target?.id) { setActiveId(visible.target.id); }
			},
			{
				root,
				rootMargin: "-20% 0px -70% 0px",
				threshold: [
					0.05,
					0.1,
					0.2,
					0.35,
					0.5,
				],
			},
		);

		headings.forEach(h => obs.observe(h));
		return () => obs.disconnect();
	}, []);

	const scrollToId = (id: string) => {
		const el = document.getElementById(id);
		if (!el) { return; }

		setMobileTocOpen(false);

		el.scrollIntoView({
			behavior: reducedMotion ? "auto" : "smooth",
			block: "start",
		});

		try {
			history.replaceState(null, "", `#${id}`);
		} catch {
			// ignore
		}
	};

	const copyLink = async (id: string) => {
		const url = `${window.location.origin}${window.location.pathname}#${id}`;
		try {
			await navigator.clipboard.writeText(url);
			setCopiedId(id);
			window.setTimeout(() => setCopiedId(cur => cur === id ? null : cur), 1200);
		} catch {
			try {
				const ta = document.createElement("textarea");
				ta.value = url;
				document.body.appendChild(ta);
				ta.select();
				document.execCommand("copy");
				document.body.removeChild(ta);
				setCopiedId(id);
				window.setTimeout(() => setCopiedId(cur => cur === id ? null : cur), 1200);
			} catch {
				// ignore
			}
		}
	};

	const scrollToTop = () => {
		const el = containerRef.current;
		if (!el) { return; }
		el.scrollTo({
			top: 0,
			behavior: reducedMotion ? "auto" : "smooth",
		});
	};

	return (
		<section
			ref={node => containerRef.current = node}
			className="relative bg-mantle w-full h-full overflow-y-auto overflow-x-hidden p-4 sm:p-6 md:p-8"
		>
			{ /* Progress bar (top) */ }
			<div
				className={cn(
					"sticky top-0 z-30 -mx-4 sm:-mx-6 md:-mx-8 transition-all duration-300",
					showProgressBar ? "opacity-100 translate-y-0" : "opacity-0 -translate-y-2 pointer-events-none",
				)}
			>
				<div className="h-0.75 w-full bg-surface-0/30 backdrop-blur">
					<div
						className="h-0.75 bg-blue/60 transition-[width] duration-150 ease-out"
						style={{ width: `${progress * 100}%` }}
						aria-hidden="true"
					/>
				</div>
			</div>

			{ /* Background blobs */ }
			<div className="absolute top-[-12%] left-[-8%] w-[38%] h-[38%] bg-mauve/10 blur-[120px] rounded-full pointer-events-none" />
			<div className="absolute bottom-[-8%] right-[-6%] w-[34%] h-[34%] bg-blue/10 blur-[120px] rounded-full pointer-events-none" />
			<div className="absolute top-[24%] right-[14%] w-[22%] h-[22%] bg-pink/5 blur-[100px] rounded-full pointer-events-none" />

			<div className="relative z-10 max-w-6xl mx-auto flex flex-col gap-4 sm:gap-6">
				{ /* HERO */ }
				<Card className="p-6 sm:p-8">
					<div className="flex flex-col gap-4">
						<div className="flex flex-wrap items-center justify-between gap-3">
							<div className="inline-flex items-center gap-2 px-3 py-1 rounded-lg bg-blue/10 border border-blue/20 text-blue text-[10px] font-bold uppercase tracking-[0.2em]">
								<ShieldCheck size={12} />
								Politique de confidentialité & CGU
							</div>

							<div className="inline-flex items-center gap-2 rounded-xl border border-surface-2/30 bg-surface-0/30 px-3 py-2 text-xs text-subtext-1">
								<FileText size={14} />
								Dernière mise à jour : { LAST_UPDATE }
							</div>
						</div>

						<div className="space-y-2">
							<h1 className="text-3xl sm:text-4xl font-bold tracking-tight text-text">
								Politique de confidentialité et Conditions générales d’utilisation
							</h1>
							<p className="text-subtext-0 max-w-3xl">
								Retrouvez ici les règles d’utilisation de HollyBike et la description transparente des traitements de données personnelles
								(dont la localisation en arrière-plan sur demande).
							</p>
						</div>

						{ /* Quick actions */ }
						<div className="flex flex-wrap gap-2">
							<button
								type="button"
								onClick={() => scrollToId((filteredToc[0] ?? tocItems[0])?.id)}
								className={cn(
									"px-4 py-2 rounded-2xl bg-blue text-crust font-semibold shadow-lg shadow-blue/20",
									"transition-all hover:brightness-110 active:scale-95",
									"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
								)}
								aria-label="Aller au début du document"
							>
								Commencer la lecture
							</button>

							<button
								type="button"
								onClick={() => setMobileTocOpen(v => !v)}
								className={cn(
									"ui-trigger px-3 py-2 text-sm font-medium xl:hidden",
									"border-surface-2/40 hover:border-surface-2/60",
									"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
									"inline-flex items-center gap-2",
								)}
								aria-expanded={mobileTocOpen}
								aria-controls="toc-mobile"
							>
								Sommaire
								<ChevronDown size={16} className={cn("transition-transform", mobileTocOpen && "rotate-180")} />
							</button>
						</div>

						{ /* Mobile TOC */ }
						<div
							id="toc-mobile"
							className={cn(
								"xl:hidden overflow-hidden rounded-2xl border border-surface-2/30 bg-surface-0/30",
								mobileTocOpen ? "max-h-130" : "max-h-0",
							)}
						>
							<div className="p-3 grid grid-cols-1 gap-1">
								{ filteredToc.map(item =>
									<button
										key={item.id}
										type="button"
										onClick={() => scrollToId(item.id)}
										className={cn(
											"text-left px-3 py-2 rounded-xl text-subtext-0 border border-transparent transition-all",
											"hover:bg-surface-0/40 hover:text-text",
											"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
											activeId === item.id && "border-surface-2/30 bg-surface-0/50 text-text",
										)}
									>
										<span className="text-sm font-medium">{ item.title }</span>
									</button>) }
								{ matchedSectionIds && filteredToc.length === 0 &&
									<div className="px-3 py-2 text-sm text-subtext-1">
										Aucun résultat.
									</div> }
							</div>
						</div>
					</div>
				</Card>

				{ /* Layout: aside sticky TOC + content */ }
				<div className="grid grid-cols-1 xl:grid-cols-[320px_1fr] gap-4 sm:gap-6">
					{ /* Sticky TOC (desktop) */ }
					<aside className="hidden xl:block">
						<Card className="p-5 sm:p-6 sticky top-6">
							<h2 className="text-xl font-bold tracking-tight text-text mb-3">Table des matières</h2>
							<div className="flex flex-col gap-1">
								{ filteredToc.map(item =>
									<button
										key={item.id}
										type="button"
										onClick={() => scrollToId(item.id)}
										className={cn(
											"text-left px-3 py-2 rounded-xl text-subtext-0 border border-transparent transition-all",
											"hover:bg-surface-0/40 hover:text-text",
											"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
											activeId === item.id && "border-surface-2/30 bg-surface-0/50 text-text",
										)}
										aria-current={activeId === item.id ? "true" : "false"}
									>
										<span className="text-sm font-medium">{ item.title }</span>
									</button>) }
								{ matchedSectionIds && filteredToc.length === 0 &&
									<div className="px-3 py-2 text-sm text-subtext-1">
										Aucun résultat.
									</div> }
							</div>

							<div className="mt-5 pt-5 border-t border-surface-2/30">
								<h3 className="text-sm font-semibold text-text mb-3">Informations légales</h3>
								<div className="space-y-3 text-sm">
									<div className="flex items-start gap-3">
										<Scale size={16} className="text-mauve mt-0.5" />
										<p className="text-subtext-0">Juridiction compétente : France</p>
									</div>
									<div className="flex items-start gap-3">
										<Mail size={16} className="text-blue mt-0.5" />
										<p className="text-subtext-0">Contact : vandenbosscheloic4@gmail.com</p>
									</div>
									<div className="flex items-start gap-3">
										<Building2 size={16} className="text-teal mt-0.5" />
										<p className="text-subtext-0">Hébergement : Serveur situé en France</p>
									</div>
								</div>
							</div>
						</Card>
					</aside>

					{ /* Content */ }
					<div className="flex flex-col gap-4 sm:gap-5 pb-4">
						{ /* Sticky search */ }
						<div className="sticky top-3 z-20">
							<Card className="p-4 sm:p-5">
								<div className="flex flex-col gap-3">
									<div className="flex items-center gap-3">
										<div className="inline-flex items-center gap-2 text-sm font-semibold text-text">
											<Search size={16} className="text-blue" />
											Rechercher dans la page
										</div>

										<div className="ml-auto text-xs text-subtext-1">
											{ matchedSectionIds ?
												`${filteredSections.length} section(s) trouvée(s)` :
												`${sections.length} section(s)` }
										</div>
									</div>

									<div className="relative">
										<input
											value={query}
											onInput={e => setQuery((e.currentTarget as HTMLInputElement).value)}
											placeholder="Ex. localisation, Mapbox, suppression, mineurs…"
											className={cn(
												"ui-control w-full rounded-2xl",
												"px-4 py-3 pr-10 placeholder:text-subtext-1",
												"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
											)}
											aria-label="Rechercher dans la page"
										/>
										{ query.trim() ?
											<button
												type="button"
												onClick={() => setQuery("")}
												className={cn(
													"absolute right-2 top-1/2 -translate-y-1/2",
													"p-2 rounded-xl border border-transparent",
													"hover:bg-surface-0/40 hover:text-text",
													"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
												)}
												aria-label="Effacer la recherche"
												title="Effacer"
											>
												<X size={16} />
											</button> :
											null }
									</div>

									{ matchedSectionIds && filteredSections.length === 0 &&
										<div className="text-sm text-subtext-1">
											Aucun résultat. Essayez un autre mot-clé.
										</div> }
								</div>
							</Card>
						</div>

						{ filteredSections.map(section =>
							<div
								id={section.id}
								key={section.id}
								data-policy-section
								className="scroll-mt-28"
							>
								<Card className="p-5 sm:p-6">
									<div className="flex items-start justify-between gap-3">
										<h3 className="text-xl font-bold tracking-tight text-text">
											{ highlightText(section.title, query) }
										</h3>

										<div className="flex items-center gap-2 shrink-0">
											<button
												type="button"
												onClick={() => copyLink(section.id)}
												className={cn(
													"ui-trigger px-2.5 py-2 text-sm font-medium",
													"border-surface-2/40 hover:border-surface-2/60",
													"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
													"inline-flex items-center gap-2",
												)}
												aria-label={`Copier le lien vers ${section.title}`}
												title="Copier le lien"
											>
												<Copy size={16} />
												<span className="hidden sm:inline">
													{ copiedId === section.id ? "Copié" : "Copier le lien" }
												</span>
											</button>
										</div>
									</div>

									<div className="mt-3 flex flex-col gap-3">
										{ section.paragraphs.map((paragraph, idx) =>
											<p
												key={`${section.id}-${idx}`}
												className="text-sm sm:text-[15px] leading-relaxed text-subtext-0 max-w-[72ch]"
											>
												{ highlightText(paragraph, query) }
											</p>) }
									</div>
								</Card>
							</div>) }
					</div>
				</div>
			</div>

			{ /* Back to top */ }
			<button
				type="button"
				onClick={scrollToTop}
				className={cn(
					"fixed bottom-5 right-5 z-30",
					"ui-trigger rounded-2xl border-surface-2/40",
					"shadow-lg px-3 py-2 text-sm font-semibold",
					"hover:border-surface-2/60 hover:bg-surface-0/60",
					"focus:outline-none focus-visible:ring-2 focus-visible:ring-blue/40",
					"transition-all",
					showTop ? "opacity-100 translate-y-0" : "opacity-0 translate-y-2 pointer-events-none",
				)}
				aria-label="Retour en haut"
			>
				<span className="inline-flex items-center gap-2">
					<ArrowUp size={16} />
					Haut
				</span>
			</button>
		</section>
	);
}
