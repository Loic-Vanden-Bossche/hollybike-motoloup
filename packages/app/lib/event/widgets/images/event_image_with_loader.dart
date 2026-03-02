/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../image/type/event_image.dart';
import '../../../shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';

class EventImageWithLoader extends StatefulWidget {
  final EventImage image;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool isSelected;

  const EventImageWithLoader({
    super.key,
    required this.image,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  State<EventImageWithLoader> createState() => _EventImageWithLoaderState();
}

class _EventImageWithLoaderState extends State<EventImageWithLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  // Checkmark springs in with elastic bounce, snaps out quickly.
  late final Animation<double> _checkmarkScale = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
    reverseCurve: Curves.easeInCubic,
  );

  // Overlay fades smoothly without the elastic overshoot.
  late final Animation<double> _overlayOpacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(EventImageWithLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected == oldWidget.isSelected) return;
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: widget.isSelected ? 0.93 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: AspectRatio(
        aspectRatio: widget.image.width / widget.image.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Hero(
                  tag: 'event_image_${widget.image.id}',
                  child: CachedNetworkImage(
                    cacheKey: widget.image.key,
                    imageUrl: widget.image.url,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) {
                      final progress = _getProgress(
                        downloadProgress.downloaded,
                        widget.image.size,
                      );
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: progress,
                        child: const GradientLoadingPlaceholder(),
                      );
                    },
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider, fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Container(
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
              // Subtle vignette gradient
              Positioned.fill(
                child: IgnorePointer(
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
              ),
              // Tap / long-press target
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    splashColor: scheme.onPrimary.withValues(alpha: 0.12),
                    highlightColor: scheme.onPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Selection teal overlay (fades in/out)
              Positioned.fill(
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: _overlayOpacity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              // Border (animated between subtle and teal)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.isSelected
                            ? scheme.secondary
                            : scheme.onPrimary.withValues(alpha: 0.10),
                        width: widget.isSelected ? 2.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              // Checkmark badge (springs in, snaps out)
              Positioned(
                top: 8,
                right: 8,
                child: ScaleTransition(
                  scale: _checkmarkScale,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.secondary,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: scheme.primary,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
