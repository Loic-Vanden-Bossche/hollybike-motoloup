/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/participant_info_chip.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/participant_missing_journey_card.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/participant_title_card.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/step_entry.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_row.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card_display_context.dart';

/// Read-only timeline row for the participant view.
/// Reuses [TimelineRow] with [pulseCurrent] and [animateBody] disabled —
/// past and current dots are identical (solid, no pulse) and the body
/// is always expanded without animation.
class ParticipantRow extends StatelessWidget {
  final StepEntry entry;
  final bool isFirst;
  final bool isLast;
  final MinimalUser? user;
  final bool isCurrentEvent;
  final void Function(int stepId)? onTerminateStep;

  const ParticipantRow({
    super.key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.user,
    required this.isCurrentEvent,
    required this.onTerminateStep,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineRow(
      stepState: entry.stepState,
      isFirst: isFirst,
      isLast: isLast,
      pulseCurrent: false,
      animateBody: false,
      titleChild: ParticipantTitleCard(entry: entry),
      bodyChild: _buildBody(context),
    );
  }

  Widget? _buildBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepJourney = entry.stepJourney;
    final accent = scheme.secondary.withValues(alpha: 0.18);

    // Future step with no journey → no body
    if (entry.stepState == TimelineStepState.future &&
        (stepJourney == null || stepJourney.journey == null)) {
      return null;
    }

    // Step has a recorded journey → show UserJourneyCard without duplicate header
    if (stepJourney?.journey != null) {
      return UserJourneyCard(
        isCurrentEvent: isCurrentEvent,
        eventStepId: stepJourney!.stepId,
        journey: stepJourney.journey,
        user: user,
        color: accent,
        isCurrentStep: false,
        displayContext: UserJourneyCardDisplayContext.event,
        showStepHeader: false,
      );
    }

    // Current step with no journey yet
    if (entry.stepState == TimelineStepState.current) {
      if (stepJourney != null &&
          stepJourney.hasRecordedPositions &&
          onTerminateStep != null) {
        return Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.tonal(
            onPressed: () => onTerminateStep?.call(stepJourney.stepId),
            child: const Text('Terminer le parcours'),
          ),
        );
      }
      return const ParticipantInfoChip(
        icon: Icons.gps_not_fixed_rounded,
        label: 'Aucune position reçue pour cette étape.',
      );
    }

    // Past step with no recorded journey
    return ParticipantMissingJourneyCard(color: accent);
  }
}
