/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class EmptySearchPlaceholder extends StatelessWidget {
  final String? lastSearch;

  const EmptySearchPlaceholder({super.key, required this.lastSearch});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primaryContainer.withValues(alpha: 0.40),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 36,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: scheme.onPrimaryContainer,
                    fontSize: 14,
                    height: 1.5,
                    fontVariations: const [FontVariation.weight(450)],
                  ),
                  children: [
                    const TextSpan(text: 'Aucun résultat pour '),
                    TextSpan(
                      text: '«$lastSearch»',
                      style: TextStyle(
                        color: scheme.secondary,
                        fontVariations: const [FontVariation.weight(700)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
