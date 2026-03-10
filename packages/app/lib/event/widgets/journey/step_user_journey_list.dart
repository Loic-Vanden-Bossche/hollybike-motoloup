/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_timeline_components.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card_display_context.dart';

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

    final entries = <_StepEntry>[];

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

        entries.add(_StepEntry(
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

        entries.add(_StepEntry(
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
          _ParticipantRow(
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

// ─── Data holder ──────────────────────────────────────────────────────────────

class _StepEntry {
  final EventCallerParticipationStepJourney? stepJourney;
  final EventJourneyStep? step;
  final TimelineStepState stepState;
  final bool isCurrent;
  final bool isPast;
  final bool isFuture;
  final String title;

  const _StepEntry({
    required this.stepJourney,
    required this.step,
    required this.stepState,
    required this.isCurrent,
    required this.isPast,
    required this.isFuture,
    required this.title,
  });
}

// ─── Timeline row ─────────────────────────────────────────────────────────────

/// Read-only timeline row. Same dot + connector rail layout as [_TimelineRow]
/// in [JourneyTimeline], but without animations or edit actions.
/// Past and current steps are rendered identically (solid dot, no pulse).
class _ParticipantRow extends StatelessWidget {
  final _StepEntry entry;
  final bool isFirst;
  final bool isLast;
  final MinimalUser? user;
  final bool isCurrentEvent;
  final void Function(int stepId)? onTerminateStep;

  const _ParticipantRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.user,
    required this.isCurrentEvent,
    required this.onTerminateStep,
  });

  bool get _isDashed => entry.stepState == TimelineStepState.future;

  double get _dotSize {
    switch (entry.stepState) {
      case TimelineStepState.current:
      case TimelineStepState.past:
        return 12.0;
      case TimelineStepState.future:
        return 10.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dotSize = _dotSize;
    final body = _buildBody(context);
    final hasBody = body != null;

    // Left rail for the title row — same geometry as _TimelineRow.
    final titleRail = SizedBox(
      width: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isFirst)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.topCenter,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ),
          if (!isLast || hasBody)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.bottomCenter,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ),
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: TimelineNodeCircle(
                stepState: entry.stepState,
                pulseCurrent: false,
              ),
            ),
          ),
        ],
      ),
    );

    // Body rail — full-height connector alongside the body card.
    final bodyRail = SizedBox(
      width: 28,
      child: !isLast
          ? Stack(children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: (28 - 2) / 2,
                width: 2,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ])
          : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleRail,
              const SizedBox(width: 10),
              Expanded(child: _buildTitleCard(context)),
            ],
          ),
        ),
        // Body (always expanded)
        if (hasBody) ...[
          timelineConnectorBridge(4, dashed: _isDashed, withLine: true),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bodyRail,
                const SizedBox(width: 10),
                Expanded(child: body),
              ],
            ),
          ),
          if (!isLast) timelineConnectorBridge(8, dashed: _isDashed),
        ] else if (!isLast)
          timelineConnectorBridge(8, dashed: _isDashed),
      ],
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFutureEmpty =
        entry.isFuture &&
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
          if (entry.isCurrent) ...[
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

  Widget? _buildBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepJourney = entry.stepJourney;
    final accent = scheme.secondary.withValues(alpha: 0.18);

    // Future step with no journey → no body (title chip is enough)
    if (entry.isFuture && (stepJourney == null || stepJourney.journey == null)) {
      return null;
    }

    // Step has a journey → show UserJourneyCard without duplicate header
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

    // Current step, no journey yet
    if (entry.isCurrent) {
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
      return _InfoChip(
        icon: Icons.gps_not_fixed_rounded,
        label: 'Aucune position reçue pour cette étape.',
        scheme: scheme,
      );
    }

    // Past step (or unknown context) with no journey recorded
    return _PastStepMissingJourneyCard(
      title: entry.title,
      color: accent,
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme scheme;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onPrimary.withValues(alpha: 0.06),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.onPrimary.withValues(alpha: 0.55)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.65),
                fontSize: 12,
                fontVariations: const [FontVariation.weight(500)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastStepMissingJourneyCard extends StatelessWidget {
  final String title;
  final Color color;

  const _PastStepMissingJourneyCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = Color.alphaBlend(
      color.withValues(alpha: 0.20),
      scheme.primaryContainer.withValues(alpha: 0.70),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.42),
              scheme.primary.withValues(alpha: 0.30),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.28)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 18,
                color: scheme.onPrimary.withValues(alpha: 0.78),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Trajet non enregistré sur cette étape.',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.80),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(560)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
