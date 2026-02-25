/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/event_preview_card/placeholder_event_preview_card.dart';
import 'package:hollybike/search/widgets/search_profile_card/placeholder_search_profile_card.dart';

import '../../../shared/utils/add_separators.dart';

class LoadingSearchPlaceholder extends StatelessWidget {
  const LoadingSearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              height: 36,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primaryContainer.withValues(alpha: 0.50),
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: addSeparators([
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
                const PlaceholderSearchProfileCard(),
              ], const SizedBox(width: 8)),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              height: 36,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primaryContainer.withValues(alpha: 0.50),
              ),
            ),
          ),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: PlaceholderEventPreviewCard(),
            ),
          ),
        ],
      ),
    );
  }
}
