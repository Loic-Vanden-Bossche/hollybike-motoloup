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
				className={clsx("ui-trigger flex items-center gap-2 px-4 py-2")}
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
						"ui-popover-panel",
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
			className={clsx("ui-menu-item")}
			onClick={onClick}
		>
			{ children }
		</button>
	);
}
