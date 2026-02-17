/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { Button } from "../components/Button/Button.tsx";
import { ButtonDanger } from "../components/Button/ButtonDanger.tsx";
import {
	useMemo,
	useState,
} from "preact/hooks";
import { Input } from "../components/Input/Input.tsx";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";
import { useAuth } from "../auth/context.tsx";
import { useNavigate } from "react-router-dom";
import { useUser } from "../user/useUser.tsx";

const DELETE_CONFIRMATION_KEYWORD = "SUPPRIMER";

export function DeleteAccount() {
	const auth = useAuth();
	const { user } = useUser();
	const navigate = useNavigate();

	const [acknowledged, setAcknowledged] = useState(false);
	const [confirmationText, setConfirmationText] = useState("");
	const [confirmDelete, setConfirmDelete] = useState(false);
	const [loading, setLoading] = useState(false);

	const canDelete = useMemo(
		() => acknowledged && confirmationText.trim().toUpperCase() === DELETE_CONFIRMATION_KEYWORD,
		[acknowledged, confirmationText],
	);

	return (
		<div className={"max-w-3xl"}>
			<Card className={"border-red/30"}>
				<div className={"space-y-5"}>
					<div>
						<p className={"text-xs uppercase tracking-[0.16em] text-red font-bold"}>Zone de danger</p>
						<h2 className={"text-2xl font-bold mt-2"}>Supprimer mon compte</h2>
						<p className={"text-sm text-subtext-1 mt-2"}>
							Cette action est definitive et irrevisible.
						</p>
					</div>

					<div className={"rounded-xl border border-red/30 bg-red/10 p-4"}>
						<p className={"font-semibold text-red text-sm"}>Avant de continuer</p>
						<ul className={"list-disc pl-5 mt-2 text-sm text-subtext-1 space-y-1"}>
							<li>Votre compte ({ user?.email ?? "utilisateur" }) sera supprime.</li>
							<li>Vos images et vos trajets personnels seront supprimes.</li>
							<li>Vous serez deconnecte immediatement.</li>
						</ul>
					</div>

					<label className={"flex items-start gap-3 text-sm text-subtext-0"}>
						<input
							type={"checkbox"}
							className={"mt-0.5"}
							checked={acknowledged}
							onChange={e => setAcknowledged(e.currentTarget.checked)}
						/>
						Je comprends que cette suppression est definitive.
					</label>

					<div className={"space-y-2"}>
						<p className={"text-sm text-subtext-1"}>
							Tapez <span className={"font-bold text-red"}>{ DELETE_CONFIRMATION_KEYWORD }</span> pour confirmer.
						</p>
						<Input
							value={confirmationText}
							onInput={e => setConfirmationText(e.currentTarget.value)}
							placeholder={DELETE_CONFIRMATION_KEYWORD}
						/>
					</div>

					<div className={"flex flex-col sm:flex-row gap-3 sm:justify-end"}>
						<Button
							className={"w-full sm:w-auto"}
							onClick={() => navigate("/")}
							disabled={loading}
						>
							Annuler
						</Button>
						<ButtonDanger
							className={"w-full sm:w-auto"}
							loading={loading}
							disabled={!canDelete}
							onClick={() => {
								if (!canDelete || loading) {
									return;
								}

								if (!confirmDelete) {
									setConfirmDelete(true);
									toast("Cliquez une seconde fois pour confirmer la suppression", { type: "warning" });
									setTimeout(() => {
										setConfirmDelete(false);
									}, 5000);
									return;
								}

								setLoading(true);
								api("/users/me", { method: "DELETE" }).then((res) => {
									if (res.status === 204) {
										toast("Compte supprime", { type: "success" });
										auth.disconnect();
									} else {
										toast(res.message ?? "Erreur inconnue", { type: "error" });
										setLoading(false);
										setConfirmDelete(false);
									}
								});
							}}
						>
							{ confirmDelete ? "Confirmer la suppression" : "Supprimer mon compte" }
						</ButtonDanger>
					</div>
				</div>
			</Card>
		</div>
	);
}
