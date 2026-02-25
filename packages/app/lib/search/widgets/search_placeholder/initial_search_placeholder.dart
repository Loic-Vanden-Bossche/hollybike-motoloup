/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class InitialSearchPlaceholder extends StatelessWidget {
  final void Function() onButtonTap;

  const InitialSearchPlaceholder({super.key, required this.onButtonTap});

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
                color: scheme.primaryContainer.withValues(alpha: 0.60),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.30),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.search_rounded,
                size: 36,
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Rechercher',
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 22,
                fontVariations: const [FontVariation.weight(800)],
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                'Trouvez des évènements et des riders par leur nom',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(450)],
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onButtonTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: scheme.secondary.withValues(alpha: 0.15),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  'Commencer la recherche',
                  style: TextStyle(
                    color: scheme.secondary,
                    fontSize: 13,
                    fontVariations: const [FontVariation.weight(700)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
