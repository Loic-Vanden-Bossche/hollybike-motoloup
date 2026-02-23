/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../image/type/event_image.dart';
import '../../../shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';

class EventImageWithLoader extends StatelessWidget {
  final EventImage image;
  final void Function()? onTap;

  const EventImageWithLoader({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: image.width / image.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'event_image_${image.id}',
                child: CachedNetworkImage(
                  cacheKey: image.key,
                  imageUrl: image.url,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    final progress = _getProgress(
                      downloadProgress.downloaded,
                      image.size,
                    );
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: progress,
                      child: const GradientLoadingPlaceholder(),
                    );
                  },
                  imageBuilder:
                      (context, imageProvider) =>
                          Image(image: imageProvider, fit: BoxFit.cover),
                  errorWidget:
                      (context, url, error) => Container(
                        color: scheme.primaryContainer.withValues(alpha: 0.58),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 42,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.00),
                      Colors.black.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashColor: scheme.onPrimary.withValues(alpha: 0.12),
                  highlightColor: scheme.onPrimary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: scheme.onPrimary.withValues(alpha: 0.10),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getProgress(int downloaded, int total) {
    if (downloaded == total) {
      return 0.2;
    } else if (downloaded == 0) {
      return 0.2;
    } else {
      return ((downloaded / total) - 1) * -1;
    }
  }
}
