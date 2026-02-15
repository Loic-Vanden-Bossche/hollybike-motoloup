/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { clsx } from "clsx";
import { ComponentChildren } from "preact";
import { Card } from "../Card/Card.tsx";
import { X } from "lucide-preact";

interface ModalProps {
	width?: string,
	children: ComponentChildren,
	visible: boolean,
	setVisible: (visible: boolean | ((prev: boolean) => boolean)) => void,
	title?: string
}

export function Modal(props: ModalProps) {
	return (
		<div
			onClick={() => props.setVisible(false)}
			className={
				clsx(
					"fixed inset-0 flex items-end sm:items-center justify-center",
					"transition-all duration-200 cursor-pointer",
					props.visible ?
						"bg-crust/40 backdrop-blur-sm pointer-events-auto" :
						"bg-transparent backdrop-blur-0 pointer-events-none",
				)
			}
			style={{ zIndex: 10_000 }}
		>
			<Card
				className={clsx(
					props.width ?? "max-w-lg w-full mx-2 sm:mx-4",
					"!p-4 sm:!p-8 cursor-auto max-h-[85dvh] overflow-y-auto",
					"transition-all duration-200",
					props.visible ?
						"translate-y-0 opacity-100 scale-100 pointer-events-auto" :
						"translate-y-8 opacity-0 scale-95 pointer-events-none",
				)} onClick={(e) => {
					e.stopPropagation();
				}}
			>
				<div className={"flex gap-4 justify-between items-start mb-6"}>
					<h1 className={"text-xl font-bold"}>{ props.title }</h1>
					<button
						className={clsx(
							"p-2 rounded-xl",
							"hover:bg-surface-0/40 text-subtext-1 hover:text-text",
							"transition-all",
						)}
						onClick={() => props.setVisible(false)}
					>
						<X size={18} />
					</button>
				</div>
				{ props.children }
			</Card>
		</div>
	);
}
