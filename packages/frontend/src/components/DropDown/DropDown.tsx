/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ComponentChildren } from "preact";
import {
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";
import { ChevronDown } from "lucide-preact";
import { clsx } from "clsx";

interface DropDownProps {
	children: ComponentChildren,
	text: ComponentChildren
}

export function DropDown({
	text, children,
}: DropDownProps) {
	const [visible, setVisible] = useState(false);
	const dropdown = useRef<HTMLDivElement>(null);

	useEffect(() => {
		const handleOut = (e: MouseEvent) => {
			if (
				dropdown.current &&
				!dropdown.current.contains(e.target as Node)
			) {
				setVisible(false);
			}
		};

		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, []);

	return (
		<section
			ref={dropdown}
			className={"relative"}
			style={{ zIndex: 7_500 }}
		>
			<button
				className={clsx(
					"flex items-center gap-2 px-4 py-2 rounded-xl",
					"bg-surface-0/40 backdrop-blur-md border border-surface-2/30",
					"hover:bg-surface-0/60 transition-all text-sm",
				)}
				onClick={() => setVisible(prev => !prev)}
			>
				<span>{ text }</span>
				<ChevronDown
					size={16}
					className={clsx("transition-transform duration-200", visible && "rotate-180")}
				/>
			</button>
			{ visible &&
				<div
					className={clsx(
						"absolute top-full right-0 mt-2 min-w-[200px]",
						"bg-surface-0/60 backdrop-blur-xl",
						"border border-surface-2/30 rounded-2xl",
						"shadow-[0_8px_32px_0_rgba(0,0,0,0.2)]",
						"overflow-hidden",
						"animate-[fadeIn_0.15s_ease-out]",
					)}
				>
					{ children }
				</div> }
		</section>
	);
}

interface DropDownElementProps {
	children: ComponentChildren,
	animationOrder?: number,
	onClick?: (e: MouseEvent) => void,
}

export function DropDownElement({
	onClick, children,
}: DropDownElementProps) {
	return (
		<button
			className={clsx(
				"w-full px-4 py-2.5 hover:bg-surface-0/40",
				"transition-colors flex items-center gap-2 text-sm text-left",
			)}
			onClick={onClick}
		>
			{ children }
		</button>
	);
}
