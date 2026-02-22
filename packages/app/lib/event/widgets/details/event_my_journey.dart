/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

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

    return _buildGlassCard(context);
  }

  Widget _buildGlassCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.secondary.withValues(alpha: 0.10),
                scheme.primary.withValues(alpha: 0.45),
              ],
            ),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.20),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: UserJourneyCard(
            isCurrentEvent: true,
            journey: eventDetails.callerParticipation?.journey,
            color: scheme.secondary,
          ),
        ),
      ),
    );
  }
}
