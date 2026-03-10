/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_small_chip.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_actions_menu.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_card_shell.dart';
import 'package:hollybike/user_journey/widgets/user_journey_modal.dart';

class TimelinePastStepCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventCallerParticipationStepJourney? stepJourney;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const TimelinePastStepCard({
    super.key,
    required this.step,
    required this.stepJourney,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';
    final journey = stepJourney?.journey;

    return TimelineStepCardShell(
      decoration: BoxDecoration(
        borderRadius: TimelineStepCardShell.kRadius,
        color: scheme.primaryContainer.withValues(alpha: 0.30),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      onTap: () => _openDetails(context),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: scheme.secondary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              stepName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.75),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(600)],
              ),
            ),
          ),
          if (journey != null) ...[
            const SizedBox(width: 8),
            TimelineSmallChip(label: journey.distanceLabel),
            const SizedBox(width: 6),
            TimelineSmallChip(
              icon: Icons.schedule_rounded,
              label: journey.totalTimeLabel,
            ),
          ] else if (stepJourney != null) ...[
            const SizedBox(width: 8),
            TimelineSmallChip(
              label: step.journey.distanceLabel,
              muted: true,
            ),
          ],
          if (eventDetails.canEditJourney) ...[
            const SizedBox(width: 4),
            TimelineStepActionsMenu(
              step: step,
              eventDetails: eventDetails,
            ),
          ],
        ],
      ),
    );
  }

  void _openDetails(BuildContext context) {
    final journey = stepJourney?.journey;
    if (journey != null) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (_) => UserJourneyModal(
          journey: journey,
          isCurrentEvent: true,
          stepId: step.id,
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<EventJourneyBloc>(),
          child: JourneyModal(
            journey: step.journey,
            stepId: step.id,
            onViewOnMap: onViewOnMap,
          ),
        ),
      );
    }
  }
}
