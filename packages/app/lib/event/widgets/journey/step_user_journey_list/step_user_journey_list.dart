/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/participant_row.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/step_entry.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class StepUserJourneyList extends StatelessWidget {
  final List<EventCallerParticipationStepJourney> stepJourneys;
  final List<EventJourneyStep> journeySteps;
  final int? currentStepId;
  final MinimalUser? user;
  final bool isCurrentEvent;
  final void Function(int stepId)? onTerminateStep;

  const StepUserJourneyList({
    super.key,
    required this.stepJourneys,
    required this.journeySteps,
    required this.currentStepId,
    this.user,
    this.isCurrentEvent = true,
    this.onTerminateStep,
  });

  @override
  Widget build(BuildContext context) {
    final stepById = {for (final step in journeySteps) step.id: step};
    final stepJourneyByStepId = {
      for (final sj in stepJourneys) sj.stepId: sj,
    };
    final currentStepPosition =
        currentStepId == null ? null : stepById[currentStepId]?.position;

    final entries = <StepEntry>[];

    if (journeySteps.isNotEmpty) {
      // Primary path: iterate event steps sorted by position, look up user journey.
      final sortedSteps = [...journeySteps]
        ..sort((a, b) => a.position - b.position);
      for (final step in sortedSteps) {
        final stepJourney = stepJourneyByStepId[step.id];
        final isCurrent = currentStepId == step.id;
        final isPast = !isCurrent &&
            currentStepPosition != null &&
            step.position < currentStepPosition;
        final isFuture = !isCurrent &&
            currentStepPosition != null &&
            step.position > currentStepPosition;

        // Hide future steps that have no recorded journey.
        if (isFuture && (stepJourney == null || stepJourney.journey == null)) {
          continue;
        }

        final stepState = isCurrent
            ? TimelineStepState.current
            : isFuture
                ? TimelineStepState.future
                : TimelineStepState.past;

        final title = step.name?.trim().isNotEmpty == true
            ? step.name!
            : 'Étape ${step.position}';

        entries.add(StepEntry(
          stepJourney: stepJourney,
          step: step,
          stepState: stepState,
          isCurrent: isCurrent,
          isPast: isPast,
          isFuture: isFuture,
          title: title,
        ));
      }
    } else {
      // Fallback: no event step data — iterate recorded step journeys directly.
      for (final stepJourney in stepJourneys) {
        final step = stepById[stepJourney.stepId];
        final isCurrent = currentStepId == stepJourney.stepId;
        final isPast = !isCurrent &&
            step != null &&
            currentStepPosition != null &&
            step.position < currentStepPosition;
        final isFuture = !isCurrent &&
            step != null &&
            currentStepPosition != null &&
            step.position > currentStepPosition;

        if (isFuture && stepJourney.journey == null && currentStepId == null) {
          continue;
        }

        final stepState = isCurrent
            ? TimelineStepState.current
            : isFuture
                ? TimelineStepState.future
                : TimelineStepState.past;

        final title = step == null
            ? 'Étape ${stepJourney.stepId}'
            : (step.name?.trim().isNotEmpty == true
                ? step.name!
                : 'Étape ${step.position}');

        entries.add(StepEntry(
          stepJourney: stepJourney,
          step: step,
          stepState: stepState,
          isCurrent: isCurrent,
          isPast: isPast,
          isFuture: isFuture,
          title: title,
        ));
      }
    }

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < entries.length; i++)
          ParticipantRow(
            entry: entries[i],
            isFirst: i == 0,
            isLast: i == entries.length - 1,
            user: user,
            isCurrentEvent: isCurrentEvent,
            onTerminateStep: onTerminateStep,
          ),
      ],
    );
  }
}
