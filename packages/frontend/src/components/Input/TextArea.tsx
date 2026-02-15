/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	ComponentChildren, JSX,
} from "preact";

interface TextAreaProps {
	children?: ComponentChildren
	value?: string,
	onInput?: (e: JSX.TargetedEvent<HTMLTextAreaElement>) => void,
	placeHolder?: string
}

export function TextArea(props: TextAreaProps) {
	return (
		<textarea
			className={
				"rounded-xl border border-surface-2/30 bg-surface-1/30 p-4 text-sm " +
				"focus:outline-none focus:ring-2 focus:ring-blue/30 focus:border-blue/50 " +
				"transition-all placeholder:text-subtext-1/60"
			}
			value={props.value} onInput={props.onInput}
			placeholder={props.placeHolder}
		>
			{ props.children }
		</textarea>
	);
}
