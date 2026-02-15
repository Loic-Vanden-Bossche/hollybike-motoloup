/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ComponentChildren } from "preact";
import { clsx } from "clsx";
import {
	ChevronDown, ChevronUp,
} from "lucide-preact";
import { useCallback } from "preact/hooks";

export interface Sort {
	column: string,
	order: "asc" | "desc" | "none"
}

interface HeadProps {
	children: ComponentChildren,
	key?: string | number
	className?: string,
	sortable?: boolean,
	sort?: Sort,
	setSortOrder?: (order: "asc" | "desc" | "none") => void,
	width?: string
}

export function Head(props: HeadProps) {
	const onClick = useCallback(() => {
		if (props.sortable && props.setSortOrder) {
			if (props.sort?.order === "asc") {
				props.setSortOrder("desc");
			} else if (props.sort?.order === "desc") {
				props.setSortOrder("none");
			} else {
				props.setSortOrder("asc");
			}
		}
	}, [
		props.setSortOrder,
		props.sort,
		props.sortable,
	]);
	return (
		<th
			className={clsx(
				"px-6 py-5 font-semibold text-left",
				"text-xs uppercase tracking-widest text-subtext-1",
				"whitespace-nowrap",
				props.sortable && props.sort && props.setSortOrder && "cursor-pointer hover:text-text transition-colors",
			)} onClick={onClick}
			style={{ width: props.width ?? "auto" }}
		>
			<span className={"inline-flex items-center gap-1"}>
				{ props.children }
				{ props.sortable &&
					( props.sort?.order === "asc" ?
						<ChevronUp size={14} /> :
						props.sort?.order === "desc" && <ChevronDown size={14} /> ) }
			</span>
		</th>
	);
}
