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

interface SideBarMenuProps {
	to: string,
	children: ComponentChildren,
	indent?: boolean
}

export function SideBarMenu(props: SideBarMenuProps) {
	const location = useLocation();
	const isActive = location.pathname === props.to;

	return (
		<Link
			className={clsx(
				"flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm transition-all",
				isActive
					? "bg-surface-0/50 text-text border border-surface-2/20"
					: "text-subtext-0 hover:bg-surface-0/40 hover:text-text",
				props.indent === true && "ml-3",
			)}
			to={props.to}
		>
			{ props.children }
		</Link>
	);
}
