/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import 'user_journey_content.dart';
import 'empty_user_journey.dart';

class UserJourneyCard extends StatelessWidget {
  final UserJourney? journey;
  final MinimalUser? user;
  final Color color;
  final bool isCurrentEvent;
  final void Function()? onDeleted;
  final bool showDate;
  final void Function(UserJourney)? onJourneySelected;

  const UserJourneyCard({
    super.key,
    required this.journey,
    required this.color,
    this.user,
    this.isCurrentEvent = false,
    this.onDeleted,
    this.showDate = false,
    this.onJourneySelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = Color.alphaBlend(
      color.withValues(alpha: 0.22),
      scheme.primaryContainer.withValues(alpha: 0.74),
    );

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
        child: Padding(padding: const EdgeInsets.all(10), child: content),
      ),
    );
  }
}
