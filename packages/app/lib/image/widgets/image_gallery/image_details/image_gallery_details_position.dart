/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/types/position.dart';

class ImageGalleryDetailsPosition extends StatelessWidget {
  final Position? position;

  const ImageGalleryDetailsPosition({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      return const SizedBox();
    }

    final scheme = Theme.of(context).colorScheme;
    final imagePosition = position as Position;

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Position.getIcon(imagePosition.positionType),
              color: scheme.onPrimary.withValues(alpha: 0.72),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(child: _buildPosition(context, imagePosition)),
          ],
        ),
      ),
    );
  }

  RichText _buildPosition(BuildContext context, Position position) {
    final preciseName = position.placeName;
    final fullCityName = position.cityName;
    final stateName = position.countyName ?? position.stateName;

    final texts = <TextSpan>[];

    void addSpan(TextSpan span) {
      if (texts.isNotEmpty) {
        texts.add(
          TextSpan(
            text: ", ",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.6),
            ),
          ),
        );
      }

      texts.add(span);
    }

    if (preciseName != null) {
      addSpan(
        TextSpan(
          text: preciseName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.86),
          ),
        ),
      );
    }

    if (fullCityName != null) {
      addSpan(
        TextSpan(
          text: fullCityName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    if (stateName != null) {
      addSpan(
        TextSpan(text: stateName, style: Theme.of(context).textTheme.bodySmall),
      );
    }

    if (texts.isEmpty) {
      addSpan(
        TextSpan(
          text: "${position.latitude}, ${position.longitude}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      );
    }

    return RichText(softWrap: true, text: TextSpan(children: texts));
  }
}
