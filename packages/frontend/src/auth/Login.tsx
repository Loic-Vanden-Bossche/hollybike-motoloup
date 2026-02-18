/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useCallback, useEffect, useState,
} from "preact/hooks";
import { useAuth } from "./context.tsx";
import {
	Link,
	useLocation,
	useNavigate,
} from "react-router-dom";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { Card } from "../components/Card/Card.tsx";
import { Modal } from "../components/Modal/Modal.tsx";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";
import success = toast.success;

export default function () {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [visible, setVisible] = useState(false);
	const [forgotMail, setForgotMail] = useState("");

	const auth = useAuth();
	const location = useLocation();

	const login = useCallback(() => {
		auth.login({
			email: email,
			password: password,
		});
	}, [
		email,
		password,
		auth,
	]);

	const navigate = useNavigate();
	const redirectPath = useCallback(() => {
		const params = new URLSearchParams(location.search);
		const redirect = params.get("redirect");

		if (redirect === null || !redirect.startsWith("/")) {
			return "/";
		}

		return redirect;
	}, [location.search]);

	useEffect(() => {
		if (auth.isLoggedIn) {
			navigate(redirectPath(), { replace: true });
		}
	}, [
		auth.isLoggedIn,
		navigate,
		redirectPath,
	]);

	return (
		<div className={"w-full h-full flex justify-center items-center bg-mantle relative overflow-hidden"}>
			{ /* Background blobs */ }
			<div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-mauve/10 blur-[120px] rounded-full pointer-events-none" />
			<div className="absolute bottom-[0%] right-[-5%] w-[35%] h-[35%] bg-blue/10 blur-[120px] rounded-full pointer-events-none" />
			<div className="absolute top-[20%] right-[10%] w-[25%] h-[25%] bg-pink/5 blur-[100px] rounded-full pointer-events-none" />

			<form onSubmit={e => e.preventDefault()} className={"relative z-10 w-full max-w-md mx-4"}>
				<Card className={"flex flex-col items-center gap-6 !p-10"}>
					{ /* Logo */ }
					<div className={"w-full h-20 rounded-2xl overflow-hidden bg-logo flex items-center justify-center border border-surface-2/20 mb-2"}>
						<img alt={"HOLLYBIKE"} src={"/icon.png"} />
					</div>

					<div className={"text-center"}>
						<h1 className={"text-2xl font-bold tracking-tight"}>Bienvenue</h1>
						<p className={"text-subtext-0 text-sm mt-1"}>Connectez-vous à votre espace de gestion</p>
					</div>

					<div className={"flex flex-col gap-4 w-full"}>
						<div className={"flex flex-col gap-1.5"}>
							<label className={"text-sm font-medium text-subtext-1"}>Email</label>
							<Input
								type={"email"}
								placeholder="votre@email.fr"
								value={email}
								onInput={e => setEmail(e.currentTarget.value)}
							/>
						</div>
						<div className={"flex flex-col gap-1.5"}>
							<label className={"text-sm font-medium text-subtext-1"}>Mot de passe</label>
							<Input
								type={"password"}
								placeholder="Votre mot de passe"
								value={password}
								onInput={e => setPassword(e.currentTarget.value)}
							/>
						</div>
					</div>

					<Button
						className={"w-full justify-center"}
						onClick={() => {
							login();
						}}
					>
						Se connecter
					</Button>

					<button
						className={"text-sm text-subtext-0 hover:text-blue transition-colors"}
						onClick={() => setVisible(true)}
					>
						Mot de passe oublié ?
					</button>
					<Link
						className={"text-[11px] text-subtext-1/80 hover:text-subtext-0 transition-colors"}
						to={"/privacy-policy"}
					>
						CGU et confidentialite
					</Link>
				</Card>
			</form>

			<Modal visible={visible} setVisible={setVisible} title={"Mot de passe oublié"}>
				<div className={"flex flex-col gap-6"}>
					<p className={"text-sm text-subtext-0"}>
						Entrez votre adresse email pour recevoir un lien de réinitialisation.
					</p>
					<div className={"flex flex-col gap-1.5"}>
						<label className={"text-sm font-medium text-subtext-1"}>Email</label>
						<Input value={forgotMail} onInput={e => setForgotMail(e.currentTarget.value)} placeholder={"votre@email.fr"}/>
					</div>
					<Button
						className={"w-full justify-center"}
						onClick={
							() => api(`/users/password/${forgotMail}/send`, { method: "POST" }).then((res) => {
								if (res.status === 200) {
									success("Mail envoyé");
									setVisible(false);
								} else {
									toast(res.message, { type: "error" });
								}
							})
						}
						disabled={forgotMail === ""}
					>
						Envoyer le mail
					</Button>
				</div>
			</Modal>
		</div>
	);
}
