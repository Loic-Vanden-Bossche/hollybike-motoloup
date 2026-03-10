/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import 'user_journey_content.dart';
import 'empty_user_journey.dart';
import 'user_journey_card_display_context.dart';

class UserJourneyCard extends StatelessWidget {
  final UserJourney? journey;
  final MinimalUser? user;
  final Color color;
  final bool isCurrentEvent;
  final void Function()? onDeleted;
  final bool showDate;
  final void Function(UserJourney)? onJourneySelected;
  final int? eventStepId;
  final String? stepTitleOverride;
  final bool isCurrentStep;
  final UserJourneyCardDisplayContext displayContext;

  const UserJourneyCard({
    super.key,
    required this.journey,
    required this.color,
    this.user,
    this.isCurrentEvent = false,
    this.onDeleted,
    this.showDate = false,
    this.onJourneySelected,
    this.eventStepId,
    this.stepTitleOverride,
    this.isCurrentStep = false,
    required this.displayContext,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = Color.alphaBlend(
      color.withValues(alpha: 0.22),
      scheme.primaryContainer.withValues(alpha: 0.74),
    );

    final headerTitle = _resolveHeaderTitle();
    final contextLabel = _resolveContextLabel();

    final content =
        journey == null
            ? SizedBox(
              height: 78,
              child: EmptyUserJourney(
                username: user?.username,
                color: accent.withValues(alpha: 0.28),
              ),
            )
            : UserJourneyContent(
              existingJourney: journey!,
              color: Colors.transparent,
              user: user,
              isCurrentEvent: isCurrentEvent,
              onDeleted: onDeleted,
              showDate: showDate,
              onJourneySelected: onJourneySelected,
              accentColor: accent,
              eventStepId: eventStepId,
              contextLabel: contextLabel,
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
              accent.withValues(alpha: 0.52),
              scheme.primary.withValues(alpha: 0.45),
            ],
          ),
          border: Border.all(color: accent.withValues(alpha: 0.30), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (headerTitle != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        headerTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.94),
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(700)],
                        ),
                      ),
                    ),
                    if (isCurrentStep)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: scheme.onPrimary.withValues(alpha: 0.16),
                        ),
                        child: Text(
                          'Actuelle',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 10.5,
                            fontVariations: const [FontVariation.weight(700)],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              content,
            ],
          ),
        ),
      ),
    );
  }

  String? _resolveHeaderTitle() {
    if (displayContext != UserJourneyCardDisplayContext.event) {
      return null;
    }

    final overrideTitle = stepTitleOverride?.trim();
    if (overrideTitle != null && overrideTitle.isNotEmpty) {
      return overrideTitle;
    }

    final stepName = journey?.stepName?.trim();
    if (stepName != null && stepName.isNotEmpty) {
      return stepName;
    }

    final hasEventLink = (journey?.eventName?.trim().isNotEmpty ?? false);
    if (!hasEventLink) {
      final journeyName = journey?.name?.trim();
      if (journeyName != null && journeyName.isNotEmpty) {
        return journeyName;
      }
    }

    return null;
  }

  String? _resolveContextLabel() {
    if (displayContext != UserJourneyCardDisplayContext.profile) {
      return null;
    }

    final event = journey?.eventName?.trim();
    final step = journey?.stepName?.trim();
    final hasEvent = event != null && event.isNotEmpty;
    final hasStep = step != null && step.isNotEmpty;

    if (!hasEvent && !hasStep) {
      return null;
    }

    if (hasEvent && hasStep) {
      return '$event · $step';
    }

    if (hasEvent || hasStep) {
      return hasEvent ? event : step;
    }

    final journeyName = journey?.name?.trim();
    if (journeyName != null && journeyName.isNotEmpty) {
      return journeyName;
    }

    return null;
  }
}
