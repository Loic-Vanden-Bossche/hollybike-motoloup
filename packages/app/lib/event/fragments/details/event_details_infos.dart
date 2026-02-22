/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_details_description.dart';
import 'package:hollybike/event/widgets/details/event_my_journey.dart';
import 'package:hollybike/event/widgets/expenses/expenses_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card.dart';
import 'package:hollybike/weather/widgets/weather_forecast_card.dart';

import '../../../app/app_router.gr.dart';
import '../../../journey/service/journey_repository.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../services/event/event_repository.dart';
import '../../types/event_details.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';
import '../../widgets/details/event_join_button.dart';
import '../../widgets/details/event_participations_preview.dart';
import '../../widgets/details/status/event_status_feed.dart';

class EventDetailsInfos extends StatelessWidget {
  final EventDetails eventDetails;
  final void Function() onViewOnMap;

  const EventDetailsInfos({
    super.key,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final event = eventDetails.event;
    final previewParticipants = eventDetails.previewParticipants;
    final previewParticipantsCount = eventDetails.previewParticipantsCount;

    return EventDetailsTabScrollWrapper(
      scrollViewKey: 'event_details_infos_${event.id}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content with consistent horizontal padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventStatusFeed(eventDetails: eventDetails),
                const SizedBox(height: 16),

                // ── PARTICIPANTS ─────────────────────────────────────
                _sectionLabel(context, 'PARTICIPANTS'),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: EventParticipationsPreview(
                        event: event,
                        previewParticipants: previewParticipants,
                        previewParticipantsCount: previewParticipantsCount,
                        onTap: () {
                          Timer(const Duration(milliseconds: 100), () {
                            context.router.push(
                              EventParticipationsRoute(
                                eventDetails: eventDetails,
                                participationPreview: previewParticipants,
                                eventDetailsBloc:
                                    context.read<EventDetailsBloc>(),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    EventJoinButton(
                      isJoined: eventDetails.isParticipating,
                      canJoin: eventDetails.canJoin,
                      onJoin: _onJoin,
                    ),
                  ],
                ),

                // Description (self-explanatory, no section label)
                const SizedBox(height: 12),
                EventDetailsDescription(description: event.description),

                // ── ITINÉRAIRE ───────────────────────────────────────
                if (eventDetails.journey != null ||
                    eventDetails.canEditJourney) ...[
                  const SizedBox(height: 20),
                  _sectionLabel(context, 'ITINÉRAIRE'),
                  const SizedBox(height: 8),
                  BlocProvider<EventJourneyBloc>(
                    create:
                        (context) => EventJourneyBloc(
                          journeyRepository:
                              RepositoryProvider.of<JourneyRepository>(context),
                          eventRepository:
                              RepositoryProvider.of<EventRepository>(context),
                        ),
                    child: JourneyPreviewCard(
                      canAddJourney: eventDetails.canEditJourney,
                      journey: eventDetails.journey,
                      eventDetails: eventDetails,
                      onViewOnMap: onViewOnMap,
                    ),
                  ),
                  const SizedBox(height: 12),
                  EventMyJourney(eventDetails: eventDetails),
                ] else ...[
                  EventMyJourney(eventDetails: eventDetails),
                ],

                // ── MÉTÉO ────────────────────────────────────────────
                if (eventDetails.journey?.destination != null) ...[
                  const SizedBox(height: 20),
                  _sectionLabel(context, 'MÉTÉO'),
                  const SizedBox(height: 8),
                  WeatherForecastCard(eventDetails: eventDetails),
                ],

                // ── DÉPENSES ─────────────────────────────────────────
                if (eventDetails.expenses != null ||
                    eventDetails.totalExpense != null) ...[
                  const SizedBox(height: 20),
                  _sectionLabel(context, 'DÉPENSES'),
                  const SizedBox(height: 8),
                  ExpensesPreviewCard(eventDetails: eventDetails),
                ],

                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: scheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: scheme.secondary.withValues(alpha: 0.8),
            fontSize: 10,
            fontVariations: const [FontVariation.weight(700)],
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  void _onJoin(BuildContext context) {
    context.read<EventDetailsBloc>().add(JoinEvent());
  }
}
