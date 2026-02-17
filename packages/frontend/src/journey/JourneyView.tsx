/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import Map, {
	Layer, LngLatBoundsLike, MapRef, Source,
} from "react-map-gl/mapbox";
import { useApi } from "../utils/useApi.ts";
import {
	useNavigate, useParams,
} from "react-router-dom";

import { TJourney } from "../types/TJourney.ts";
import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { useRef } from "react";
import { ArrowLeft } from "lucide-preact";
import { ViewStateChangeEvent } from "@vis.gl/react-mapbox";

const accessToken = import.meta.env.VITE_MAPBOX_KEY;

const layerStyle = {
	id: "point",
	type: "line",
	layout: {
		"line-join": "round",
		"line-cap": "round",
	},
	paint: {
		"line-color": "#3457D5",
		"line-width": 5,
		"line-opacity": 1,
	},
} as const;

export function JourneyView() {
	const { id } = useParams();
	const isJourneyIdValid = useMemo(() => id !== undefined && /^[0-9]+$/.test(id), [id]);
	const journey = useApi<TJourney>(`/journeys/${id}`, undefined, { if: isJourneyIdValid });
	const [data, setData] = useState<any>();
	const navigate = useNavigate();

	useEffect(() => {
		if (journey.data && journey.data.file) {
			fetch(journey.data.file).then( async (res) => {
				const data: any = await res.json();
				if (data.bbox?.length === 6) {
					data.bbox = [
						data.bbox[0],
						data.bbox[1],
						data.bbox[3],
						data.bbox[4],
					];
				}
				setData(data);
			});
		}
	}, [journey, setData]);

	useEffect(() => {
		if (!isJourneyIdValid) {
			navigate("/not-found", { replace: true });
		}
	}, [isJourneyIdValid, navigate]);

	useEffect(() => {
		if (journey.status === 404 || journey.status === 400) {
			navigate("/not-found", { replace: true });
		}
	}, [journey.status, navigate]);

	if (!isJourneyIdValid || journey.status === 404 || journey.status === 400) {
		return null;
	}

	const mapRef = useRef<MapRef>(null);

	useEffect(() => {
		if (data && data.bbox && mapRef.current) {
			mapRef.current.fitBounds(data.bbox as LngLatBoundsLike, { padding: 40 });
		}
	}, [data, mapRef]);

	const [viewState, setViewState] = useState({
		longitude: 1.2084545,
		latitude: 44.3392763,
		zoom: 4,
	});

	const onLoad = useCallback(() => {
		if (mapRef.current !== null) {
			mapRef.current.getMap().getStyle().layers.filter((l: { id: string }) => l.id.includes("label")).forEach((l: { id: string }) => {
				mapRef.current?.getMap().setLayoutProperty(l.id, "text-field", ["get", "name_fr"]);
			});
		}
	}, [mapRef, mapRef.current]);

	return (
		<div className={"grow flex flex-col gap-4 overflow-hidden h-full"}>
			<div>
				<button
					className={"flex items-center gap-2 px-4 py-2 rounded-xl bg-surface-0/40 border border-surface-2/30 text-sm hover:bg-surface-0/60 transition-all"}
					onClick={() => navigate(-1)}
				>
					<ArrowLeft size={16} />
					Retour
				</button>
			</div>
			<div className={"grow rounded-2xl overflow-hidden flex flex-col"}>
				<Map
					{...viewState}
					style={{ flexGrow: "1" }}
					mapLib={import("mapbox-gl")}
					mapStyle={"mapbox://styles/mapbox/navigation-night-v1"}
					mapboxAccessToken={accessToken}
					onMove={(evt: ViewStateChangeEvent) => setViewState(evt.viewState)}
					ref={mapRef}
					onLoad={onLoad}
				>
					<Source id="tracks" type="geojson" data={data}>
						<Layer {...layerStyle}/>
					</Source>
				</Map>
			</div>
		</div>
	);
}
