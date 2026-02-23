/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/utils/dates.dart';

class ImageGalleryDetailsEvent extends StatelessWidget {
  final MinimalEvent event;

  const ImageGalleryDetailsEvent({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onPrimary.withValues(alpha: 0.06),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image(image: event.imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event_rounded,
                  color: scheme.onPrimary.withValues(alpha: 0.72),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.86),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatReadableDate(
                          event.startDate.toLocal(),
                        ).capitalize(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.62),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
