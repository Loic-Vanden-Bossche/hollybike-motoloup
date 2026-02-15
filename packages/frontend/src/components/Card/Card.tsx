/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface CardProps {
	children: ComponentChildren,
	className?: string,
	onClick?: (e: MouseEvent) => void,
	hover?: boolean
}

export function Card(props: CardProps) {
	return (
		<div
			onClick={props.onClick}
			className={clsx(
				"relative overflow-hidden",
				"ui-glass-panel",
				"p-4 sm:p-6 transition-all",
				props.hover && "duration-500 hover:bg-surface-0/50 hover:border-surface-2/50 hover:-translate-y-1 hover:shadow-2xl",
				props.className,
			)}
		>
			{ props.children }
		</div>
	);
}
