/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	ComponentChildren, JSX,
} from "preact";
import { clsx } from "clsx";
import {
	ForwardedRef,
	forwardRef,
} from "react";

interface InputProps {
	onInput?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	onFocusIn?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	onFocusOut?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	value: string,
	type?: string,
	placeholder?: string,
	className?: string,
	leftIcon?: ComponentChildren
	rightIcon?: ComponentChildren,
	disabled?: boolean
}

export const Input = forwardRef((props: InputProps, ref: ForwardedRef<HTMLDivElement>) =>
	<div
		ref={ref}
		className={clsx("flex items-stretch", props.className)}
	>
		{ props.leftIcon &&
			<i className={"ui-control flex items-center rounded-r-none border-r-0 px-2.5"}>
				{ props.leftIcon }
			</i> }
		<input
			disabled={props.disabled === true}
			onFocusIn={props.onFocusIn} onFocusOut={props.onFocusOut}
			value={props.value} onInput={props.onInput} type={props.type} placeholder={props.placeholder}
			className={clsx(
				"ui-control w-full px-3 py-2.5",
				"disabled:border-surface-2/20 disabled:bg-surface-1/20 disabled:text-subtext-0 disabled:cursor-not-allowed",
				props.leftIcon && "border-l-0 rounded-l-none",
				props.rightIcon && "border-r-0 rounded-r-none",
			)}
		/>
		{ props.rightIcon &&
			<i className={"ui-control flex items-center rounded-l-none border-l-0 px-2.5"}>
				{ props.rightIcon }
			</i> }
	</div>);
