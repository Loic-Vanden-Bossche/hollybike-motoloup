/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Input } from "../components/Input/Input.tsx";
import { TextArea } from "../components/Input/TextArea.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import { api } from "../utils/useApi.ts";
import { TEvent } from "../types/TEvent.ts";
import { toast } from "react-toastify";
import { Card } from "../components/Card/Card.tsx";
import {
	Dispatch, StateUpdater, useEffect, useRef, useState,
} from "preact/hooks";
import { ButtonDanger } from "../components/Button/ButtonDanger.tsx";
import { useNavigate } from "react-router-dom";
import { EEventStatus } from "../types/EEventStatus.ts";
import { DoReload } from "../utils/useReload.ts";


interface EventInfoProps {
	eventData: TEvent,
	setEventData: Dispatch<StateUpdater<TEvent>>,
	id: number,
	doReload: DoReload
}

export function EventInfo(props: EventInfoProps) {
	const navigate = useNavigate();
	const [confirm, setConfirm] = useState(false);
	const {
		eventData, setEventData, id,
	} = props;
	const [budgetText, setBudgetText] = useState("");
	const initialDates = useRef<{
		start: number,
		end: number | null
	}>({
		start: eventData.start_date_time.getTime(),
		end: eventData.end_date_time?.getTime() ?? null,
	});
	useEffect(() => {
		setBudgetText(eventData.budget ? (eventData.budget / 100).toFixed(2) : "");
	}, [eventData.budget]);
	useEffect(() => {
		initialDates.current = {
			start: eventData.start_date_time.getTime(),
			end: eventData.end_date_time?.getTime() ?? null,
		};
	}, [eventData.id, eventData.update_date_time]);
	return (
		<Card className={"grid grid-cols-1 sm:grid-cols-2 gap-4 items-center 2xl:overflow-auto"}>
			<p className={"text-sm font-medium text-subtext-1"}>Nom</p>
			<Input
				value={eventData.name} onInput={e => setEventData(prev => ({
					...prev,
					name: e.currentTarget.value,
				}))}
			/>
			<p className={"text-sm font-medium text-subtext-1"}>Description</p>
			<TextArea
				value={eventData.description} onInput={e => setEventData(prev => (
					{
						...prev,
						description: e.currentTarget.value,
					}
				))}
			/>
			<p className={"text-sm font-medium text-subtext-1"}>Date de début</p>
			<InputCalendar
				value={eventData.start_date_time} setValue={(d) => {
					if (d !== undefined) {
						if (typeof d === "function") {
							setEventData(prev => ({
								...prev,
								start_date_time: d(prev.start_date_time)!,
							}));
						} else {
							setEventData(prev => ({
								...prev,
								start_date_time: d,
							}));
						}
					}
				}}
				time
			/>
			<p className={"text-sm font-medium text-subtext-1"}>Date de fin</p>
			<InputCalendar
				value={eventData.end_date_time} setValue={(d) => {
					if (typeof d === "function") {
						setEventData(prev => ({
							...prev,
							end_date_time: d(prev.end_date_time),
						}));
					} else {
						setEventData(prev => ({
							...prev,
							end_date_time: d,
						}));
					}
				}}
				time
			/>
			<p className={"text-sm font-medium text-subtext-1"}>Budget</p>
			<Input
				value={budgetText}
				type={"number"}
				onInput={e => setBudgetText(e.currentTarget.value)}
			/>
			<p className={"text-sm font-medium text-subtext-1"}>Statut</p>
			<EventStatus status={eventData.status} id={eventData.id} doReload={props.doReload}/>
			<Button
				className={"w-full sm:w-auto justify-self-stretch sm:justify-self-start"}
				onClick={() => {
					const start = eventData.start_date_time.getTime();
					const end = eventData.end_date_time?.getTime() ?? null;
					const hasDateChanges = start !== initialDates.current.start || end !== initialDates.current.end;
					const isTerminated = eventData.status === EEventStatus.Finished || eventData.status === EEventStatus.Cancelled;
					if (hasDateChanges && eventData.status === EEventStatus.Now) {
						toast("Impossible de modifier les dates d'un événement en cours.", { type: "warning" });
						return;
					}
					if (hasDateChanges && isTerminated) {
						const now = Date.now();
						if (start < now || end !== null && end < now) {
							toast("Pour un événement terminé, les dates modifiées ne peuvent pas être dans le passé.", { type: "warning" });
							return;
						}
					}
					api<TEvent>(`/events/${id}`, {
						method: "PUT",
						body: {
							name: eventData.name,
							description: eventData.description,
							start_date: eventData.start_date_time,
							end_date: eventData.end_date_time,
							budget: budgetText !== "" ? parseFloat(budgetText) * 100 : undefined,
						},
					}).then((res) => {
						if (res.status === 200 && res.data !== undefined) {
							setEventData(res.data);
							initialDates.current = {
								start: res.data.start_date_time.getTime(),
								end: res.data.end_date_time?.getTime() ?? null,
							};
							toast("Évènement mis à jour", { type: "success" });
						} else if (res.status === 404 || res.status === 400) {
							toast(res.message, { type: "warning" });
						}
					});
				}}
			>
				Sauvegarder
			</Button>
			<ButtonDanger
				className={"w-full sm:w-auto justify-self-stretch sm:justify-self-end"}
				onClick={() => {
					if (eventData.status === EEventStatus.Now) {
						toast("Impossible de supprimer un événement en cours.", { type: "warning" });
						return;
					}
					if (confirm) {
						api(`/events/${eventData.id}`, { method: "DELETE" }).then((res) => {
							if (res.status === 200) {
								navigate("/events");
								toast("Évènement supprimé", { type: "success" });
							} else {
								toast(res.message, { type: "error" });
							}
						});
					} else {
						setConfirm(true);
						setTimeout(() => {
							setConfirm(false);
						}, 5000);
					}
				}}
			>
				{ confirm ? "Êtes vous sur ?" : "Supprimer l'évènement" }
			</ButtonDanger>
		</Card>
	);
}

interface EventStatusProps {
	status: EEventStatus,
	id: number,
	doReload: DoReload
}

function EventStatus(props: EventStatusProps) {
	if (props.status === EEventStatus.Pending) {
		return (
			<Button
				onClick={async () => {
					const resp = await api(`/events/${props.id}/schedule`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement publié", { type: "success" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Publier
			</Button>
		);
	}
	if (props.status === EEventStatus.Scheduled) {
		return (
			<ButtonDanger
				onClick={async () => {
					const resp = await api(`/events/${props.id}/cancel`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement annulé", { type: "warning" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Annuler
			</ButtonDanger>
		);
	}
	if (props.status === EEventStatus.Cancelled) {
		return (
			<Button
				onClick={async () => {
					const resp = await api(`/events/${props.id}/pend`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement rétabli", { type: "success" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Rétablir
			</Button>
		);
	}

	if (props.status === EEventStatus.Now) {
		return (
			<ButtonDanger
				onClick={async () => {
					const resp = await api(`/events/${props.id}/finish`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement terminé", { type: "success" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Terminer
			</ButtonDanger>
		);
	}

	if (props.status === EEventStatus.Finished) {
		return <span className={"inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-surface-1/40 text-subtext-0 border border-surface-2/20"}>Terminé</span>;
	}

	return null;
}
