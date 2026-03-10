/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_small_chip.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_actions_menu.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_card_shell.dart';

class TimelineFutureStepCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const TimelineFutureStepCard({
    super.key,
    required this.step,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';

    return Opacity(
      opacity: 0.5,
      child: TimelineStepCardShell(
        decoration: BoxDecoration(
          borderRadius: TimelineStepCardShell.kRadius,
          color: scheme.primaryContainer.withValues(alpha: 0.15),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        onTap: () => _openDetails(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                stepName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(550)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            TimelineSmallChip(
              label: step.journey.distanceLabel,
              muted: true,
            ),
            if (eventDetails.canEditJourney) ...[
              const SizedBox(width: 4),
              TimelineStepActionsMenu(
                step: step,
                eventDetails: eventDetails,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
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
