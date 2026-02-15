export interface TAssociationInsights {
	events_by_month: TEventMonthStatus[];
	invitation_funnel: TInvitationFunnel;
	journey_adoption: TJourneyAdoption;
	users_by_status: TInsightBucket[];
	user_last_login_buckets: TInsightBucket[];
}

export interface TEventMonthStatus {
	year: number;
	month: number;
	status: string;
	count: number;
}

export interface TInvitationFunnel {
	total_created: number;
	active_links: number;
	used_links: number;
	expired_links: number;
	disabled_links: number;
	saturated_links: number;
}

export interface TJourneyAdoption {
	total_events: number;
	total_events_with_journey: number;
	total_journeys: number;
	adoption_rate_percent: number;
}

export interface TInsightBucket {
	key: string;
	count: number;
}

