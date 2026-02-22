/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:lottie/lottie.dart';

class EmptyJourneyPreviewCard extends StatelessWidget {
  final Event event;

  const EmptyJourneyPreviewCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1.5,
        color: scheme.onPrimary.withValues(alpha: 0.22),
        radius: const Radius.circular(22),
        dashPattern: const [6, 5],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.48),
                  scheme.primary.withValues(alpha: 0.32),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Lottie.asset(
                    'assets/lottie/lottie_journey.json',
                    repeat: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sélectionner un parcours',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.88),
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Appuyez pour importer un tracé GPX',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.48),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: scheme.secondary.withValues(alpha: 0.70),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
