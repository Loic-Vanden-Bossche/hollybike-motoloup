/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { useApi } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { TAssociationData } from "../types/TAssociationData.ts";

interface AssociationDataProps {
	association?: TAssociation
}

export function AssociationData(props: AssociationDataProps) {
	const data = useApi<TAssociationData>(
		`/associations/${props.association?.id}/data`,
		[props.association?.id],
		{ if: props.association !== undefined },
	);
	return (
		<Card className={"self-start justify-self-start grid grid-cols-[1fr_auto] content-start gap-4"}>
			<p className={"text-sm text-subtext-1"}>Nombre d'utilisateurs</p><p className={"text-sm font-semibold text-text"}>{ data.data?.total_user }</p>
			<p className={"text-sm text-subtext-1"}>Nombre d'évènements</p><p className={"text-sm font-semibold text-text"}>{ data.data?.total_event }</p>
			<p className={"text-sm text-subtext-1"}>Nombre de balades</p><p className={"text-sm font-semibold text-text"}>{ data.data?.total_event_with_journey }</p>
			<p className={"text-sm text-subtext-1"}>Nombre de trajets</p><p className={"text-sm font-semibold text-text"}>{ data.data?.total_journey }</p>
		</Card>
	);
}
