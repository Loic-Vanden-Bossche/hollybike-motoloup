/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { clsx } from "clsx";
import { Check } from "lucide-preact";

interface CheckBoxProps {
	checked?: boolean
	toggle?: () => void
}

export function CheckBox(props: CheckBoxProps) {
	return (
		<div
			className={clsx(
				"cursor-pointer flex items-center justify-center transition-all",
				props.checked === true ?
					"w-5 h-5 rounded-lg bg-blue border-2 border-blue text-crust" :
					"w-5 h-5 rounded-lg border-2 border-surface-2 bg-surface-1/30 hover:border-blue/50",
			)}
			onClick={props.toggle}
		>
			{ props.checked === true && <Check size={14} /> }
			<input type={"checkbox"} className={"hidden"} checked={props.checked}/>
		</div>
	);
}
