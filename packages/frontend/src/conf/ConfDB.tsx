/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Input } from "../components/Input/Input.tsx";
import { Card } from "../components/Card/Card.tsx";
import { ConfProps } from "./Conf.tsx";
import { useState } from "preact/hooks";
import {
	Trash2,
	Eye, EyeOff,
} from "lucide-preact";
import { RedStar } from "../components/RedStar/RedStar.tsx";

export function ConfDB(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between items-center mb-4"}>
				<h2 className={"text-xl font-bold tracking-tight"}>Base de données (obligatoire)</h2>
				<Trash2
					size={16} className={"cursor-pointer text-red hover:text-red/80 transition-colors"}
					onClick={() => setConf(prev => ({
						...prev,
						db: {},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-4 items-center"}>
				<p className={"text-sm font-medium text-subtext-1"}>URL <RedStar/></p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								url: e.currentTarget.value,
							},
						}
					))}
					value={conf?.db?.url ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Nom d'utilisateur <RedStar/></p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								username: e.currentTarget.value,
							},
						}
					))}
					value={conf?.db?.username ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Mot de passe <RedStar/></p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								password: e.currentTarget.value,
							},
						}
					))}
					onFocusIn={(e) => {
						if (e.currentTarget.value === "******") {
							setConf(prev => (
								{
									...prev,
									db: {
										...prev?.db,
										password: "",
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
									db: {
										...prev?.db,
										password: "******",
									},
								}
							));
						}
					}}
					value={conf?.db?.password ?? ""}
					rightIcon={visiblePassword ?
						<EyeOff size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Eye size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
