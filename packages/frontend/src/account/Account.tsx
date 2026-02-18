/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { ButtonDanger } from "../components/Button/ButtonDanger.tsx";
import { useNavigate } from "react-router-dom";
import { useUser } from "../user/useUser.tsx";

export function Account() {
	const navigate = useNavigate();
	const { user } = useUser();

	return (
		<div className={"max-w-3xl space-y-4"}>
			<Card>
				<div className={"space-y-5"}>
					<div>
						<p className={"text-xs uppercase tracking-[0.16em] text-blue font-bold"}>Mon espace</p>
						<h2 className={"text-2xl font-bold mt-2"}>Mon compte</h2>
						<p className={"text-sm text-subtext-1 mt-2"}>
							Consultez les informations de votre compte et les actions disponibles.
						</p>
					</div>

					<div className={"rounded-xl border border-surface-2 bg-surface-0/40 p-4 space-y-1"}>
						<p className={"text-sm text-subtext-1"}>Nom d'utilisateur</p>
						<p className={"font-semibold"}>{ user?.username ?? "-" }</p>
						<p className={"text-sm text-subtext-1 pt-3"}>Email</p>
						<p className={"font-semibold"}>{ user?.email ?? "-" }</p>
					</div>
				</div>
			</Card>

			<Card className={"border-red/30"}>
				<div className={"space-y-3"}>
					<p className={"text-xs uppercase tracking-[0.16em] text-red font-bold"}>Zone de danger</p>
					<p className={"text-sm text-subtext-1"}>
						La suppression du compte est definitive et irrevisible.
					</p>
					<div className={"flex justify-end"}>
						<ButtonDanger onClick={() => navigate("/account/delete")}>
							Supprimer mon compte
						</ButtonDanger>
					</div>
				</div>
			</Card>
		</div>
	);
}
