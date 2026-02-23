/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';

class EventMyJourney extends StatelessWidget {
  final EventDetails eventDetails;

  const EventMyJourney({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    if (eventDetails.callerParticipation == null ||
        (eventDetails.callerParticipation?.hasRecordedPositions == false &&
            eventDetails.callerParticipation?.journey == null)) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;

    return UserJourneyCard(
      isCurrentEvent: true,
      journey: eventDetails.callerParticipation?.journey,
      color: scheme.secondary.withValues(alpha: 0.18),
    );
  }
}
