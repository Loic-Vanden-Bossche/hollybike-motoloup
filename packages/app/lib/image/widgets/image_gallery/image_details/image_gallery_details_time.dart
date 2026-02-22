/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/dates.dart';

class ImageGalleryDetailsTime extends StatelessWidget {
  final DateTime uploadedAt;
  final DateTime? takenAt;

  const ImageGalleryDetailsTime({
    super.key,
    required this.uploadedAt,
    this.takenAt,
  });

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.access_time_rounded,
              color: scheme.onPrimary.withValues(alpha: 0.72),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildDates(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDates(BuildContext context) {
    final widgets = <Widget>[
      Text(
        "Ajoutée ${formatReadableDate(uploadedAt.toLocal())}",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onPrimary.withValues(alpha: 0.78),
        ),
      ),
    ];

    if (takenAt != null) {
      widgets.addAll([
        const SizedBox(height: 4),
        Text(
          "Prise ${formatReadableDate(takenAt!.toLocal())}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.62),
          ),
        ),
      ]);
    }

    return widgets;
  }
}
