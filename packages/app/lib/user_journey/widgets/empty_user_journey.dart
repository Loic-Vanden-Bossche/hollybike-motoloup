/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyUserJourney extends StatelessWidget {
  final String? username;

  const EmptyUserJourney({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        strokeWidth: 1.2,
        color: scheme.onPrimary.withValues(alpha: 0.24),
        radius: const Radius.circular(16),
        dashPattern: const [4, 6],
      ),
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.onPrimary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: Lottie.asset(
                'assets/lottie/lottie_journey.json',
                repeat: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _getMessage(),
                softWrap: true,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.84),
                  fontVariations: const [FontVariation.weight(560)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMessage() {
    if (username == null) {
      return 'Lorsque vous aurez terminé votre trajet, vous pourrez le consulter ici';
    }

    return 'Lorsque $username aura terminé son trajet, vous pourrez le consulter ici';
  }
}
