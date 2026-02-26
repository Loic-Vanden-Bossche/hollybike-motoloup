/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/placeholders/empty_state_placeholder.dart';

class InitialSearchPlaceholder extends StatelessWidget {
  final void Function() onButtonTap;

  const InitialSearchPlaceholder({super.key, required this.onButtonTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: EmptyStatePlaceholder(
          icon: Icons.search_rounded,
          title: 'Rechercher',
          subtitle: 'Trouvez des évènements et des riders par leur nom',
          actionLabel: 'Commencer la recherche',
          onAction: onButtonTap,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
      ),
    );
  }
}
