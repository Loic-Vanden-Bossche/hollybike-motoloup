/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ParticipantMissingJourneyCard extends StatelessWidget {
  final Color color;

  const ParticipantMissingJourneyCard({super.key, required this.color});

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
