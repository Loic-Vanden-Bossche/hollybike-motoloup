/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class TimelineSmallChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool muted;

  const TimelineSmallChip({
    super.key,
    required this.label,
    this.icon,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scheme.onPrimary.withValues(alpha: muted ? 0.05 : 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 11,
              color: scheme.onPrimary.withValues(alpha: muted ? 0.35 : 0.55),
            ),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: muted ? 0.40 : 0.70),
              fontSize: 10.5,
              fontVariations: const [FontVariation.weight(600)],
            ),
          ),
        ],
      ),
    );
  }
}
