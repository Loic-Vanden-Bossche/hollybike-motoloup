/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ParticipantInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const ParticipantInfoChip({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
