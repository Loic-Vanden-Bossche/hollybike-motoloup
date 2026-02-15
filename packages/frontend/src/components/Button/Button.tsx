/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ComponentChildren } from "preact";
import { clsx } from "clsx";
import { useMemo } from "preact/hooks";

export interface ButtonProps {
	onClick: (e: MouseEvent) => void,
	children: ComponentChildren,
	className?: string,
	type?: string,
	loading?: boolean,
	disabled?: boolean
}

export function Button(props: ButtonProps) {
	const disabled = useMemo(() => props.disabled === true || props.loading === true, [props.disabled, props.loading]);
	return (
		<button
			disabled={disabled}
			type={props.type}
			onClick={props.onClick}
			className={
				clsx(
					"flex items-center gap-2 px-6 py-2.5 rounded-2xl font-bold transition-all text-sm",
					props.className,
					disabled
						? "cursor-default bg-surface-1/30 text-subtext-0 border border-surface-2/20"
						: "cursor-pointer bg-blue text-crust shadow-lg shadow-blue/20 hover:brightness-110 active:scale-95",
				)
			}
		>
			{ props.children }
			{ props.loading === true &&
				<div className={"border-2 rounded-full h-4 w-4 animate-spin border-current border-b-transparent"}/> }
		</button>
	);
}
