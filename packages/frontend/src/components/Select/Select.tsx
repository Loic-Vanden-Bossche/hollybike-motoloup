/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { ChevronDown } from "lucide-preact";
import { clsx } from "clsx";
import { useRef } from "react";
import {
	decInputCount, inputCount,
} from "../InputCount.ts";

export interface Option {
	value: string | number,
	name: string
}

interface SelectProps {
	options: Option[],
	placeholder?: string,
	default?: string | number,
	value?: string | number,
	onChange?: (value: string | number | undefined) => void,
	disabled?: boolean,
	searchable?: boolean,
	searchPlaceHolder?: string
}

export function Select(props: SelectProps) {
	const id = useMemo(() => {
		const tmp = inputCount;
		decInputCount();
		return tmp;
	}, []);
	const [text, setText] = useState(props.placeholder);

	const [visible, setVisible] = useState(false);

	const [search, setSearch] = useState("");

	const container = useRef<HTMLDivElement>(null);

	const input = useRef<HTMLInputElement>(null);

	const handleOut = useCallback((e: MouseEvent) => {
		if (
			container.current &&
			!container.current.contains(e.target as Node) &&
			(
				input.current &&
				!input.current.contains(e.target as Node) ||
				input.current === null
			)
		) {
			setVisible(false);
		}
	}, [
		container,
		input,
		setVisible,
	]);

	useEffect(() => {
		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, [handleOut]);

	useEffect(() => {
		if (props.default !== undefined) {
			const opt = props.options.find(o => o.value == props.default);
			setText(opt?.name ?? props.placeholder);
		}
	}, [
		props.default,
		props.options,
		props.default,
		props.value,
	]);

	const filteredOptions = useMemo(() => {
		if (props.searchable) {
			return props.options.filter(o => o.name.toLowerCase().includes(search.toLowerCase()));
		} else {
			return props.options;
		}
	}, [
		props.options,
		search,
		props.searchable,
	]);

	return (
		<div
			className={clsx(
				"rounded-xl flex items-center justify-between px-4 py-2.5 relative text-sm",
				"transition-all",
				visible && "rounded-b-none",
				props.disabled === true ?
					"border border-surface-2/20 bg-surface-1/20 text-subtext-0 cursor-default" :
					"bg-surface-1/30 border border-surface-2/30 cursor-pointer hover:border-surface-2/50",
			)}
			onClick={(e) => {
				if (input.current?.contains(e.target as Node) !== true && props.disabled !== true) {
					setVisible(prev => !prev);
				}
			}} ref={container}
			style={`z-index: ${id}`}
		>
			<p className={text === props.placeholder ? "text-subtext-1/60" : ""}>{ text }</p>
			<ChevronDown size={16} className={clsx("transition-transform duration-200", visible && "rotate-180")}/>
			{ visible &&
                <div
                	className={clsx(
                		"absolute top-full -left-px w-[calc(100%+2px)]",
                		"bg-surface-0/60 backdrop-blur-xl",
                		"border border-surface-2/30 border-t-0 rounded-b-xl",
                		"overflow-hidden",
                		"shadow-[0_8px_32px_0_rgba(0,0,0,0.2)]",
                	)}
                >
                	{ props.searchable &&
                        <input
                        	className={clsx(
                        		"bg-surface-1/30 m-2 p-2 text-sm",
                        		"border border-surface-2/30 rounded-lg",
                        		"focus:outline-none focus:ring-2 focus:ring-blue/30",
                        		"w-[calc(100%-1rem)]",
                        	)}
                        	ref={input} value={search}
                        	onInput={e => setSearch(e.currentTarget.value)}
                        /> }
                	{ filteredOptions.map(o =>
                		<p
                			className={"px-4 py-2.5 cursor-pointer hover:bg-surface-0/40 transition-colors"}
                			onClick={(e) => {
                				props.onChange && props.onChange(o.value);
                				setVisible(false);
                				setText(o.name);
                				e.preventDefault();
                				e.stopPropagation();
                			}}
                		>
                			{ o.name }
                		</p>) }
                </div> }
			<select disabled={props.disabled} className={"hidden"} value={props.value}>
				<option default={props.default === undefined}></option>
				{ props.options.map((o, i) =>
					<option default={props.default === o.value} key={i} value={o.value}>{ o.name }</option>) }
			</select>
		</div>
	);
}
