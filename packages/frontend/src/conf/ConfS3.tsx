/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ConfProps } from "./Conf.tsx";
import {
	Trash2, Eye, EyeOff,
} from "lucide-preact";
import { useState } from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";

export function ConfS3(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between items-center mb-4"}>
				<h2 className={"text-xl font-bold tracking-tight"}>S3</h2>
				<Trash2
					size={16} className={"cursor-pointer text-red hover:text-red/80 transition-colors"}
					onClick={() => setConf(prev => ({
						...prev,
						storage: {
							...prev?.storage,
							s3Url: undefined,
							s3Bucket: undefined,
							s3Region: undefined,
							s3Username: undefined,
							s3Password: undefined,
						},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-4 items-center"}>
				<p className={"text-sm font-medium text-subtext-1"}>URL</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Url: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Url ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Bucket</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Bucket: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Bucket ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Region</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Region: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Region ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Utilisateur</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Username: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Username ?? ""}
				/>
				<p className={"text-sm font-medium text-subtext-1"}>Mot de passe</p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Password: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Password ?? ""}
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
					rightIcon={visiblePassword ?
						<EyeOff size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Eye size={16} className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
