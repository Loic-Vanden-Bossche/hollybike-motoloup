/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.secondary.withValues(alpha: 0.18);
    final stepById = {for (final step in journeySteps) step.id: step};
    final currentStepPosition = currentStepId == null
        ? null
        : stepById[currentStepId]?.position;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
          stepJourneys
              .map<Widget?>((stepJourney) {
            final step = stepById[stepJourney.stepId];
            final isCurrent = currentStepId == stepJourney.stepId;
            final isPast =
                !isCurrent &&
                step != null &&
                currentStepPosition != null &&
                step.position < currentStepPosition;
            final isFuture =
                !isCurrent &&
                step != null &&
                currentStepPosition != null &&
                step.position > currentStepPosition;
            if (isFuture && stepJourney.journey == null) {
              return null;
            }
            final title =
                step == null
                    ? 'Etape ${stepJourney.stepId}'
                    : (step.name?.trim().isNotEmpty == true
                        ? step.name!
                        : 'Etape ${step.position}');

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (stepJourney.journey != null || isCurrent)
                    UserJourneyCard(
                      isCurrentEvent: isCurrentEvent,
                      eventStepId: stepJourney.stepId,
                      journey: stepJourney.journey,
                      user: user,
                      color: accent,
                      stepTitleOverride: title,
                      isCurrentStep: isCurrent,
                      displayContext: UserJourneyCardDisplayContext.event,
                    )
                  else
                    _PastStepMissingJourneyCard(
                      title: title,
                      color: accent,
                    ),
                  if (stepJourney.journey == null) ...[
                    const SizedBox(height: 8),
                    if (isCurrent &&
                        stepJourney.hasRecordedPositions &&
                        onTerminateStep != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.tonal(
                          onPressed:
                              () => onTerminateStep?.call(stepJourney.stepId),
                          child: const Text('Terminer le parcours'),
                        ),
                      )
                    else if (isPast)
                      Text(
                        'Aucun trajet enregistré pour cette étape passée.',
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.72),
                          fontSize: 13,
                        ),
                      )
                    else
                      Text(
                        'Aucune position recue pour cette etape.',
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.72),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ],
              ),
            );
          }).whereType<Widget>().toList(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.92),
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const SizedBox(height: 10),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
