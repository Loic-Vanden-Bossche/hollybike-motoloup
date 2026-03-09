/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card_display_context.dart';

class EventMyJourney extends StatelessWidget {
  final EventDetails eventDetails;

  const EventMyJourney({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    final caller = eventDetails.callerParticipation;
    if (caller == null) {
      return const SizedBox.shrink();
    }

    final steps = caller.stepJourneys;
    if (steps.isEmpty) {
      if (!caller.hasRecordedPositions && caller.journey == null) {
        return const SizedBox.shrink();
      }

      final scheme = Theme.of(context).colorScheme;
      return UserJourneyCard(
        isCurrentEvent: true,
        journey: caller.journey,
        color: scheme.secondary.withValues(alpha: 0.18),
        displayContext: UserJourneyCardDisplayContext.event,
      );
    }

    return StepUserJourneyList(
      stepJourneys: steps,
      journeySteps: eventDetails.journeySteps,
      currentStepId: eventDetails.currentStepId,
      onTerminateStep:
          (stepId) => context.read<EventDetailsBloc>().add(
            TerminateUserJourney(stepId: stepId),
          ),
    );
  }
}
