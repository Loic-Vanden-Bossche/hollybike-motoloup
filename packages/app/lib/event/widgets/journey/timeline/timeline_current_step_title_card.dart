/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_actions_menu.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_card_shell.dart';

/// Compact title bar for the current step — only the header row.
/// Kept separate from [TimelineCurrentStepBodyCard] so the timeline dot can align
/// with this card's vertical center (= title row center) via Center().
class TimelineCurrentStepTitleCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;

  const TimelineCurrentStepTitleCard({
    super.key,
    required this.step,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';

    return TimelineStepCardShell(
      decoration: BoxDecoration(
        borderRadius: TimelineStepCardShell.kRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.56),
            scheme.primary.withValues(alpha: 0.42),
          ],
        ),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              stepName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: scheme.secondary.withValues(alpha: 0.16),
            ),
            child: Text(
              'Actuelle',
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 11,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          if (eventDetails.canEditJourney) ...[
            const SizedBox(width: 4),
            TimelineStepActionsMenu(
              step: step,
              eventDetails: eventDetails,
              forceWithoutSetCurrent: true,
            ),
          ],
        ],
      ),
    );
  }
}
