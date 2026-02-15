/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Link,
	useLocation,
} from "react-router-dom";
import { ComponentChildren } from "preact";
import { clsx } from "clsx";
import { useSideBar } from "./useSideBar.tsx";

interface SideBarMenuProps {
	to: string,
	children: ComponentChildren,
	indent?: boolean,
	disabled?: boolean
}

export function SideBarMenu(props: SideBarMenuProps) {
	const { setVisible } = useSideBar();
	const location = useLocation();
	const isActive = location.pathname === props.to;
	const className = clsx(
		"flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm transition-all font-medium",
		isActive ?
			"bg-surface-0/50 text-text border border-surface-2/30" :
			"text-subtext-0 hover:bg-surface-0/40 hover:text-text",
		props.indent === true && "ml-3",
		props.disabled && "opacity-40 grayscale cursor-not-allowed hover:bg-transparent hover:text-subtext-0",
	);

	if (props.disabled) {
		return (
			<div
				className={className}
				aria-disabled={"true"}
			>
				{ props.children }
			</div>
		);
	}

	return (
		<Link
			className={className}
			to={props.to}
			onClick={() => setVisible(false)}
		>
			{ props.children }
		</Link>
	);
}
