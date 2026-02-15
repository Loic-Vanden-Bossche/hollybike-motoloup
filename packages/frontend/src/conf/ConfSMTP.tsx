/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ConfProps } from "./Conf.tsx";
import {
	Trash2, Eye, EyeOff,
} from "lucide-preact";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { useState } from "preact/hooks";

export function ConfSMTP(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between items-center mb-4"}>
				<h2 className={"text-xl font-bold tracking-tight"}>SMTP</h2>
				<Trash2
					size={16} className={"cursor-pointer text-red hover:text-red/80 transition-colors"}
					onClick={() => setConf(prev => ({
						...prev,
						smtp: undefined,
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-4 items-center"}>
				<p className={"text-sm font-medium text-subtext-1"}>URL</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							url: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.url ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Port</p><Input
					type={"number"}
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							port: e.currentTarget.value.length > 0 ? parseInt(e.currentTarget.value) : undefined,
						},
					}))} value={conf?.smtp?.port?.toString() ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Envoyeur</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							sender: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.sender ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Utilisateur</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							username: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.username ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Mot de passe</p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							password: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.password ?? ""}
					onFocusIn={(e) => {
						if (e.currentTarget.value === "******") {
							setConf(prev => (
								{
									...prev,
									security: {
										...prev?.security,
										secret: "",
									},
								}
							));
						}
					}}
					onFocusOut={(e) => {
						if (e.currentTarget.value === "" && props.baseConf?.db?.password === "******") {
							setConf(prev => (
								{
									...prev,
									security: {
										...prev?.security,
										secret: "******",
									},
								}
							));
						}
					}}
					rightIcon={visiblePassword ?
						<EyeOff size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Eye size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
