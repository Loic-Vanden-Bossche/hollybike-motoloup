/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/journey/journey_modal_header.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/journey/widgets/journey_location.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import '../../../journey/type/minimal_journey.dart';

class JourneyModal extends StatelessWidget {
  final void Function() onViewOnMap;
  final EventDetails eventDetails;
  final MinimalJourney journey;

  const JourneyModal({
    super.key,
    required this.journey,
    required this.onViewOnMap,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      maxContentHeight: 560,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Actions header
          JourneyModalHeader(
            onViewOnMap: onViewOnMap,
            event: eventDetails.event,
            canEditJourney: eventDetails.canEditJourney,
          ),
          const SizedBox(height: 16),

          // Route preview image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: JourneyImage(
                imageKey: journey.previewImageKey,
                imageUrl: journey.previewImage,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Location info
          JourneyLocation(journey: journey, sizeFactor: 1.5),
          const SizedBox(height: 14),

          // Stats card
          Container(
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                // Distance + elevation row
                Row(
                  children: [
                    Icon(
                      Icons.route_outlined,
                      size: 20,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      journey.distanceLabel,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 15,
                        fontVariations: const [FontVariation.weight(700)],
                      ),
                    ),
                    const Spacer(),
                    _statChip(
                      scheme,
                      Icons.north_east_rounded,
                      '${journey.totalElevationGain} m',
                    ),
                    const SizedBox(width: 8),
                    _statChip(
                      scheme,
                      Icons.south_east_rounded,
                      '${journey.totalElevationLoss} m',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  color: scheme.onPrimary.withValues(alpha: 0.08),
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                // Min/max elevation row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _statChip(
                      scheme,
                      Icons.vertical_align_bottom_rounded,
                      '${journey.minElevation} m',
                    ),
                    const SizedBox(width: 8),
                    _statChip(
                      scheme,
                      Icons.terrain_rounded,
                      '${journey.maxElevation} m',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _statChip(ColorScheme scheme, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: scheme.onPrimary.withValues(alpha: 0.50)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.70),
            fontSize: 12,
            fontVariations: const [FontVariation.weight(550)],
          ),
        ),
      ],
    );
  }
}
