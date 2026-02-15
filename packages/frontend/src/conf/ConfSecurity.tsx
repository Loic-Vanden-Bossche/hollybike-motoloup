/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ConfProps } from "./Conf.tsx";
import {
	Trash2, Eye, EyeOff,
} from "lucide-preact";
import { Card } from "../components/Card/Card.tsx";
import { useState } from "preact/hooks";
import { Input } from "../components/Input/Input.tsx";
import { RedStar } from "../components/RedStar/RedStar.tsx";

export function ConfSecurity(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between items-center mb-4"}>
				<h2 className={"text-xl font-bold tracking-tight"}>Sécurité (obligatoire)</h2>
				<Trash2
					size={16} className={"cursor-pointer text-red hover:text-red/80 transition-colors"}
					onClick={() => setConf(prev => ({
						...prev,
						security: {},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-4 items-center"}>
				<p className={"text-sm font-medium text-subtext-1"}>Audience <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							audience: e.currentTarget.value,
						},
					}))} value={conf?.security?.audience ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Domaine <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							domain: e.currentTarget.value,
						},
					}))} value={conf?.security?.domain ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Realm <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							realm: e.currentTarget.value,
						},
					}))} value={conf?.security?.realm ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Secret <RedStar/></p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							security: {
								...prev?.security,
								secret: e.currentTarget.value,
							},
						}
					))}
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
					value={conf?.security?.secret ?? ""}
					rightIcon={visiblePassword ?
						<EyeOff size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Eye size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
