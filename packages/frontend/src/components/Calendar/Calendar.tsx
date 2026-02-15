/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Day, useLilius,
} from "use-lilius";
import {
	ChevronLeft, ChevronRight,
} from "lucide-preact";
import { clsx } from "clsx";
import {
	Dispatch, StateUpdater, useEffect,
} from "preact/hooks";

export interface CalendarProps {
	time?: boolean,
	seconds?: boolean
	value?: Date,
	setValue?: Dispatch<StateUpdater<Date | undefined>>
}

export function Calendar(props: CalendarProps) {
	const {
		calendar, viewPreviousMonth, viewNextMonth, viewing, setViewing,
	} = useLilius({
		weekStartsOn: Day.MONDAY,
		viewing: props.value,
	});

	useEffect(() => {
		if (props.value) {
			setViewing(props.value);
		}
	}, [props.value, setViewing]);

	const today = new Date();
	return (
		<div className={"w-68"}>
			{ calendar.map(m =>
				<div>
					<div className={"flex justify-between items-center mb-3"}>
						<button
							className={"p-1.5 rounded-xl hover:bg-surface-0/40 text-subtext-1 hover:text-text transition-all"}
							onClick={() => viewPreviousMonth()}
						>
							<ChevronLeft size={18} />
						</button>
						<span className={"text-sm font-bold"}>{ monthName[viewing.getMonth()] }</span>
						<button
							className={"p-1.5 rounded-xl hover:bg-surface-0/40 text-subtext-1 hover:text-text transition-all"}
							onClick={() => viewNextMonth()}
						>
							<ChevronRight size={18} />
						</button>
					</div>
					{ m.map(w =>
						<div className={"flex gap-1"}>
							{ w.map(d =>
								<p
									className={clsx(
										"w-10 h-10 rounded-xl flex justify-center items-center text-sm",
										"hover:bg-surface-0/40 transition-colors cursor-pointer",
										sameDay(d, props.value) && "bg-blue text-crust",
										!sameDay(d, props.value) && sameDay(d, today) && "border border-blue/30",
									)}
									onClick={() => {
										if (props.setValue !== undefined) {
											const time = props.value ?? new Date();
											const tmp = new Date(d);
											tmp.setHours(time.getHours());
											tmp.setMinutes(time.getMinutes());
											tmp.setSeconds(time.getSeconds());
											props.setValue(tmp);
										}
									}}
								>
									{ d.getDate() }
								</p>) }
						</div>) }
					{ props.time === true &&
						<div className={"flex justify-center mt-3 gap-1 text-sm"}>
							<input
								className={"bg-surface-1/30 text-center w-8 rounded-lg py-1 focus:outline-none focus:ring-2 focus:ring-blue/30 border border-surface-2/30"}
								value={props.value?.getHours()}
								onInput={(e) => {
									if (validHour(trim0Start(e.currentTarget.value)) && props.setValue !== undefined) {
										props.setValue((prev) => {
											if (prev) {
												const tmp = new Date(prev);
												if (e.currentTarget.value === "") {
													tmp.setHours(0);
												} else {
													tmp.setHours(parseInt(e.currentTarget.value));
												}
												return tmp;
											} else {
												return prev;
											}
										});
									}
								}}
							/>
							<span className={"text-subtext-1"}>:</span>
							<input
								className={"bg-surface-1/30 text-center w-8 rounded-lg py-1 focus:outline-none focus:ring-2 focus:ring-blue/30 border border-surface-2/30"}
								value={formatDateTimeComponent(props.value?.getMinutes())}
								onInput={(e) => {
									if (validMinSec(trim0Start(e.currentTarget.value)) && props.setValue) {
										props.setValue((prev) => {
											if (prev === undefined) {
												return undefined;
											}

											const tmp = new Date(prev);
											if (e.currentTarget.value === "") {
												tmp.setMinutes(0);
											} else {
												tmp.setMinutes(parseInt(e.currentTarget.value));
											}
											return tmp;
										});
									}
								}}
							/>
							{ props.seconds === true &&
								<>
									<span className={"text-subtext-1"}>:</span>
									<input
										className={"bg-surface-1/30 text-center w-8 rounded-lg py-1 focus:outline-none focus:ring-2 focus:ring-blue/30 border border-surface-2/30"}
										value={formatDateTimeComponent(props.value?.getSeconds())}
										onInput={(e) => {
											if (validMinSec(trim0Start(e.currentTarget.value)) && props.setValue) {
												props.setValue((prev) => {
													if (prev === undefined) { return prev; }
													const tmp = new Date(prev);
													if (e.currentTarget.value === "") {
														tmp.setSeconds(0);
													} else {
														tmp.setSeconds(parseInt(e.currentTarget.value));
													}
													return tmp;
												});
											}
										}}
									/>
								</> }
						</div> }
				</div>) }
		</div>
	);
}

const monthName = [
	"Janvier",
	"Février",
	"Mars",
	"Avril",
	"Mai",
	"Juin",
	"Juillet",
	"Aout",
	"Septembre",
	"Octobre",
	"Novembre",
	"Décembre",
];

function sameDay(a: Date, b: Date | undefined) {
	return b !== undefined &&
		a.getFullYear() === b.getFullYear() &&
		a.getMonth() === b.getMonth() &&
		a.getDate() === b.getDate();
}

export function formatDateTimeComponent(value: number | undefined): string {
	if (value === undefined) {
		return "";
	}
	if (value >= 10) {
		return value.toString();
	} else {
		return `0${value}`;
	}
}

function max2Digit(value: string): boolean {
	return value.length <= 2 && (!isNaN(parseInt(value)) || value === "");
}

function validHour(value: string): boolean {
	return max2Digit(value) && (parseInt(value) < 24 || value === "");
}

function validMinSec(value: string): boolean {
	return max2Digit(value) && (parseInt(value) < 60 || value === "");
}

function trim0Start(s: string) {
	while (s.charAt(0) === "0") {
		s = s.substring(1);
	}
	return s;
}
