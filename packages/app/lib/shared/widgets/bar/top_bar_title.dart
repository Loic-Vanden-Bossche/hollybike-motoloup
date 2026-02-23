/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class TopBarTitle extends StatelessWidget {
  final String title;

  const TopBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.88),
        fontVariations: const [FontVariation.weight(760)],
      ),
    );
  }
}
