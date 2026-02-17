/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useNavigate, useParams,
} from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import {
	dummyEvent, TEvent,
} from "../types/TEvent.ts";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { EventInfo } from "./EventInfo.tsx";
import { EventJourney } from "./EventJourney.tsx";
import { useReload } from "../utils/useReload.ts";
import { TEventDetail } from "../types/TEventDetail.ts";
import { EventParticipant } from "./EventParticipants.tsx";
import { EventGallery } from "./EventGallery.tsx";
import { clsx } from "clsx";
import { EventExpense } from "./EventExpense.tsx";

export function EventDetail() {
	const {
		reload, doReload,
	} = useReload();
	const { id } = useParams();
	const isEventIdValid = useMemo(() => id !== undefined && /^[0-9]+$/.test(id), [id]);
	const event = useApi<TEvent>(`/events/${id}`, [reload], { if: isEventIdValid });
	const [eventData, setEventData] = useState<TEvent>(dummyEvent);
	const eventDetail = useApi<TEventDetail>(`/events/${id}/details`, [reload], { if: isEventIdValid });
	const navigate = useNavigate();

	useEffect(() => {
		if (event.status === 200 && event.data !== undefined) { setEventData(event.data); }
	}, [event, setEventData]);

	useEffect(() => {
		if (!isEventIdValid) {
			navigate("/not-found", { replace: true });
		}
	}, [isEventIdValid, navigate]);

	useEffect(() => {
		if (event.status === 404 || event.status === 400 || eventDetail.status === 404 || eventDetail.status === 400) {
			navigate("/not-found", { replace: true });
		}
	}, [
		event.status,
		eventDetail.status,
		navigate,
	]);

	if (!isEventIdValid || event.status === 404 || event.status === 400 || eventDetail.status === 404 || eventDetail.status === 400) {
		return null;
	}

	return (
		<div
			className={clsx(
				"grid grid-cols-1 gap-6 w-full",
				"2xl:grid-flow-col 2xl:grid-cols-[700px_1fr] 2xl:grid-rows-2",
			)}
		>
			<EventInfo eventData={eventData} setEventData={setEventData} id={parseInt(id ?? "-1")} doReload={doReload}/>
			<EventJourney eventDetail={eventDetail.data} doReload={doReload}/>
			<EventParticipant event={eventDetail.data?.event ?? dummyEvent}/>
			<div className={"flex gap-6 flex-col 2xl:flex-row"}>
				<EventGallery eventId={eventDetail.data?.event?.id ?? -1}/>
				<EventExpense
					expenses={eventDetail.data?.expenses ?? []}
					eventId={eventDetail?.data?.event?.id ?? -1}
					doReload={doReload}
				/>
			</div>
		</div>
	);
}
