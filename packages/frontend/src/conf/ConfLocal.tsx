/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ConfProps } from "./Conf.tsx";
import { Trash2 } from "lucide-preact";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";

export function ConfLocal(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>Local</h1>
				<Trash2
					size={18}
					className={"cursor-pointer text-subtext-1 hover:text-red transition-colors"}
					onClick={() => setConf(prev => ({
						...prev,
						storage: {
							...prev?.storage,
							localPath: undefined,
						},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-2 items-center"}>
				<p>Chemin local:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								localPath: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.localPath ?? ""}
				/>
			</div>
		</Card>
	);
}
