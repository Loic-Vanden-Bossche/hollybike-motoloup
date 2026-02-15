/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useNavigate, useParams,
} from "react-router-dom";
import {
	api, useApi,
} from "../../utils/useApi.ts";
import { TUser } from "../../types/TUser.ts";
import { Card } from "../../components/Card/Card.tsx";
import { useReload } from "../../utils/useReload.ts";
import { Input } from "../../components/Input/Input.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { dummyAssociation } from "../../types/TAssociation.ts";
import { Button } from "../../components/Button/Button.tsx";
import {
	Eye, EyeOff,
} from "lucide-preact";
import { TUserUpdate } from "../../types/TUserUpdate.ts";
import { Select } from "../../components/Select/Select.tsx";
import { toast } from "react-toastify";
import {
	EUserStatus, EUserStatusOptions,
} from "../../types/EUserStatus.ts";
import {
	EUserScope, EUserScopeOptions,
} from "../../types/EUserScope.ts";
import { useUser } from "../useUser.tsx";
import { ListUserJourney } from "./ListUserJourney.tsx";
import { ButtonDanger } from "../../components/Button/ButtonDanger.tsx";
import { completeOnboardingStep } from "../../home/onboardingActions.ts";

const emptyUser: TUser = {
	id: -1,
	username: "",
	email: "",
	status: EUserStatus.Enabled,
	scope: EUserScope.User,
	last_login: new Date(),
	association: dummyAssociation,
};

export function UserDetail() {
	const { id } = useParams();

	const {
		reload, doReload,
	} = useReload();

	const { user: self } = useUser();

	const user = useApi<TUser>(`/users/${ id}`, [reload]);

	const [userData, setUserData] = useState<TUser>(emptyUser);

	const [password, setPassword] = useState("");
	const [passwordVisible, setPasswordVisible] = useState(false);

	const [confirm, setConfirm] = useState(false);

	useEffect(() => {
		if (user.data !== undefined) { setUserData(user.data); }
	}, [user]);

	const navigate = useNavigate();

	return (
		<div className={"grid gap-4 sm:gap-6 grid-cols-1 xl:grid-cols-2"}>
			<Card>
				<div className={"grid gap-4 grid-cols-1 sm:grid-cols-2 items-center"}>
					<p className={"text-sm font-medium text-subtext-1"}>Nom de l'utilisateur</p>
					<Input
						value={userData.username} onInput={e => setUserData(prev => ({
							...prev!,
							username: e.currentTarget.value,
						}))}
					/>
					<p className={"text-sm font-medium text-subtext-1"}>Fonction</p>
					<Input
						placeholder={"Fonction"}
						value={userData.role ?? ""}
						onInput={e => setUserData(prev => ({
							...prev!,
							role: e.currentTarget.value,
						}))}
					/>
					<p className={"text-sm font-medium text-subtext-1"}>Email</p>
					<Input
						value={userData.email} onInput={e => setUserData(prev => ({
							...prev!,
							email: e.currentTarget.value,
						}))}
					/>
					<p className={"text-sm font-medium text-subtext-1"}>Mot de passe</p>
					<Input
						placeholder={"·······"}
						type={passwordVisible ? "text" : "password"}
						value={password} onInput={e => setPassword(e.currentTarget.value) }
						rightIcon={passwordVisible ?
							<EyeOff size={16} className={"cursor-pointer"} onClick={() => setPasswordVisible(false)}/> :
							<Eye size={16} className={"cursor-pointer"} onClick={() => setPasswordVisible(true)}/>}
					/>
					<p className={"text-sm font-medium text-subtext-1"}>Rôle</p>
					<Select
						value={userData.scope}
						onChange={v => setUserData(prev => ({
							...prev,
							scope: (v ?? "User") as EUserScope,
						}))}
						options={EUserScopeOptions.filter(o => self?.scope === EUserScope.Root || o.value !== EUserScope.Root)}
						default={userData.scope}
					/>
					<p className={"text-sm font-medium text-subtext-1"}>Statut</p>
					<Select
						value={userData.status}
						onChange={v => setUserData(prev => ({
							...prev,
							status: (v ?? "Enabled") as EUserStatus,
						}))}
						options={EUserStatusOptions}
						default={userData.status}
					/>
				</div>
				<div className={"flex flex-col sm:flex-row gap-3 sm:justify-between mt-4"}>
					<Button
						className={"w-full sm:w-auto"}
						onClick={() => {
							const data: TUserUpdate = {
								username: userData.username,
								email: userData.email,
								password: password.length !== 0 ? password : undefined,
								status: userData.status,
								scope: userData.scope,
								association: userData.association.id,
								role: userData.role,
							};
							api(`/users/${userData.id}`, {
								method: "PATCH",
								body: data,
							}).then((res) => {
								if (res.status === 200) {
									doReload();
									if (userData.id === self?.id) {
										completeOnboardingStep("update_default_user");
									}
									toast("L'utilisateur à été mis à jour", { type: "success" });
								} else if (res.status === 404) {
									toast(res.message, { type: "warning" });
								} else {
									toast(`Erreur: ${res.message}`, { type: "error" });
								}
							});
						}}
					>
						Sauvegarder
					</Button>
					<ButtonDanger
						className={"w-full sm:w-auto"}
						onClick={() => {
							if (confirm) {
								api(`/users/${user.data?.id}`, {
									method: "DELETE",
									if: user.data !== undefined,
								}).then((res) => {
									if (res.status === 204) {
										toast("Utilisateur supprimé", { type: "success" });
										navigate("/users");
										setConfirm(false);
									} else {
										toast(res.message, { type: "error" });
									}
								});
							} else {
								setConfirm(true);
								setTimeout(() => {
									setConfirm(false);
								}, 5000);
							}
						}}
					>
						{ confirm ? "Confirmer" : "Supprimer l'utilisateur" }
					</ButtonDanger>
				</div>
			</Card>
			<ListUserJourney/>
		</div>
	);
}
