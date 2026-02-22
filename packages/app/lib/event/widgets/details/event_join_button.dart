/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class EventJoinButton extends StatelessWidget {
  final bool isJoined;
  final bool canJoin;
  final void Function(BuildContext context) onJoin;

  const EventJoinButton({
    super.key,
    required this.isJoined,
    required this.canJoin,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    if (isJoined) return _buildJoinedBadge(context);
    if (!canJoin) return const SizedBox.shrink();
    return _buildJoinButton(context);
  }

  Widget _buildJoinedBadge(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: scheme.secondary.withValues(alpha: 0.14),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: scheme.secondary, size: 14),
              const SizedBox(width: 6),
              Text(
                'Inscrit',
                style: TextStyle(
                  color: scheme.secondary,
                  fontSize: 12,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onJoin(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.secondary.withValues(alpha: 0.85),
                  scheme.secondary.withValues(alpha: 0.65),
                ],
              ),
              border: Border.all(
                color: scheme.secondary.withValues(alpha: 0.45),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.secondary.withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Rejoindre',
              style: TextStyle(
                color: scheme.surface,
                fontSize: 12,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
