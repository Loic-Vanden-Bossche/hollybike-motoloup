/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../event/widgets/journey/journey_import_modal_from_type.dart';
import '../../event/widgets/journey/upload_journey_menu.dart';
import 'journey_library_card.dart';

class JourneyLibrary extends StatelessWidget {
  final List<Journey> journeys;
  final Event event;
  final void Function() onAddJourney;
  final void Function(Journey) onSelected;

  const JourneyLibrary({
    super.key,
    required this.journeys,
    required this.event,
    required this.onAddJourney,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (journeys.isEmpty) {
      final scheme = Theme.of(context).colorScheme;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Aucun parcours disponible.',
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.55),
                fontSize: 14,
                fontVariations: const [FontVariation.weight(500)],
              ),
            ),
            const SizedBox(height: 16),
            UploadJourneyMenu(
              event: event,
              includeLibrary: false,
              onSelection: (type) {
                journeyImportModalFromType(
                  context,
                  type,
                  event,
                  selected: onAddJourney,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.40),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 15,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ajouter un parcours',
                      style: TextStyle(
                        color: scheme.secondary,
                        fontSize: 13,
                        fontVariations: const [FontVariation.weight(650)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: journeys.length,
        physics: const AlwaysScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final journey = journeys[index];

          return JourneyLibraryCard(journey: journey, onSelected: onSelected);
        },
      ),
    );
  }
}
