/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import {
	ArrowLeft,
	Compass,
	Home,
} from "lucide-preact";
import {
	Link,
	useLocation,
	useNavigate,
} from "react-router-dom";

export function NotFound() {
	const navigate = useNavigate();
	const location = useLocation();

	return (
		<section className={"w-full flex items-center justify-center py-2 sm:py-4"}>
			<Card className={"w-full max-w-3xl relative"}>
				<div className={"absolute top-[-24px] right-[-20px] h-36 w-36 rounded-full bg-mauve/10 blur-3xl pointer-events-none"} />
				<div className={"absolute bottom-[-40px] left-[-30px] h-40 w-40 rounded-full bg-blue/10 blur-3xl pointer-events-none"} />

				<div className={"relative z-10 flex flex-col gap-6 sm:gap-8"}>
					<div className={"inline-flex w-fit items-center gap-2 px-3 py-1 rounded-lg bg-mauve/10 border border-mauve/20 text-mauve text-[10px] font-bold uppercase tracking-[0.2em]"}>
						<Compass size={12} />
						Erreur 404
					</div>
					<div className={"space-y-3"}>
						<h2 className={"text-3xl sm:text-4xl font-bold tracking-tight text-text"}>
							Page introuvable
						</h2>
						<p className={"text-subtext-0 max-w-2xl"}>
							La route <span className={"font-semibold text-text"}>{ location.pathname }</span> n&apos;existe pas dans le back-office.
							Utilisez les actions ci-dessous pour revenir a un ecran valide.
						</p>
					</div>
					<div className={"flex flex-col sm:flex-row gap-3"}>
						<button
							type={"button"}
							onClick={() => navigate(-1)}
							className={"flex items-center justify-center gap-2 px-5 py-2.5 rounded-2xl bg-surface-0/40 backdrop-blur-md border border-surface-2/30 text-text font-medium transition-all hover:bg-surface-0/60 active:scale-95"}
						>
							<ArrowLeft size={16} />
							Retour
						</button>
						<Link
							to={"/"}
							className={"flex items-center justify-center gap-2 px-6 py-2.5 rounded-2xl bg-blue text-crust font-bold shadow-lg shadow-blue/20 transition-all hover:brightness-110 active:scale-95"}
						>
							<Home size={16} />
							Tableau de bord
						</Link>
					</div>
				</div>
			</Card>
		</section>
	);
}
