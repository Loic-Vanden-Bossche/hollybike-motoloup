/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/journey/widgets/journey_position.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../../journey/type/minimal_journey.dart';
import '../../../journey/widgets/journey_image.dart';
import '../../../shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class JourneyPreviewCardContent extends StatelessWidget {
  final MinimalJourney? journey;
  final bool loadingPositions;

  const JourneyPreviewCardContent({
    super.key,
    required this.journey,
    required this.loadingPositions,
  });

  @override
  Widget build(BuildContext context) {
    if (journey == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final existingJourney = journey!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Left: distance hero + location ───────────────────────────
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                existingJourney.distanceLabel,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 20,
                  fontVariations: const [FontVariation.weight(750)],
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'distance',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.45),
                  fontSize: 9,
                  fontVariations: const [FontVariation.weight(600)],
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              _buildLocationInfo(context, existingJourney),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // ── Right: journey preview image ──────────────────────────────
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: JourneyImage(
              imageKey: existingJourney.previewImageKey,
              imageUrl: existingJourney.previewImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context, MinimalJourney journey) {
    final scheme = Theme.of(context).colorScheme;

    if (loadingPositions && journey.destination == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 10,
            maxLetters: 14,
          ),
          const SizedBox(height: 4),
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 10,
            maxLetters: 14,
          ),
        ],
      );
    }

    final location = journey.readablePartialLocation;
    final start = journey.start;
    final widgets = <Widget>[];

    if (start != null) {
      widgets.add(
        Row(
          children: [
            Icon(
              Icons.trip_origin_rounded,
              size: 11,
              color: scheme.secondary,
            ),
            const SizedBox(width: 4),
            Expanded(child: JourneyPosition(pos: start)),
          ],
        ),
      );
    }

    if (location != null) {
      widgets.add(
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 11,
              color: scheme.onPrimary.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.60),
                  fontSize: 11,
                  fontVariations: const [FontVariation.weight(500)],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    if (widgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addSeparators(widgets, const SizedBox(height: 5)),
    );
  }
}
