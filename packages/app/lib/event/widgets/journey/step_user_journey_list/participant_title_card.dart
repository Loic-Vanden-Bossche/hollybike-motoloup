/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/step_entry.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_card_shell.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';

class ParticipantTitleCard extends StatelessWidget {
  final StepEntry entry;

  const ParticipantTitleCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isFutureEmpty = entry.isFuture &&
        (entry.stepJourney == null || entry.stepJourney!.journey == null);

    if (isFutureEmpty) {
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
          child: Text(
            entry.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.55),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(550)],
            ),
          ),
        ),
      );
    }

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
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          if (entry.stepState == TimelineStepState.current) ...[
            const SizedBox(width: 8),
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
          ],
        ],
      ),
    );
  }
}
