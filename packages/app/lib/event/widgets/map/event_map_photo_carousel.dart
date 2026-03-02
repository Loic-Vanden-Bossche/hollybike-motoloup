/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/geolocated_event_image.dart';
import 'package:intl/intl.dart';

const double kCarouselCardHeight = 148.0;
// Approximate expanded total (panel padding + header + gap + cards + SafeArea min).
// Used for camera bottom padding calculations.
const double kCarouselTotalHeight = 250.0;

class EventMapPhotoCarousel extends StatefulWidget {
  final List<GeolocatedEventImage> images;
  final void Function(int index) onPageChanged;
  final bool isMapFullscreen;
  final VoidCallback onRequestFullscreen;
  final VoidCallback onCollapsed;
  final void Function(int currentIndex) onExpanded;

  const EventMapPhotoCarousel({
    super.key,
    required this.images,
    required this.onPageChanged,
    required this.isMapFullscreen,
    required this.onRequestFullscreen,
    required this.onCollapsed,
    required this.onExpanded,
  });

  @override
  State<EventMapPhotoCarousel> createState() => _EventMapPhotoCarouselState();
}

class _EventMapPhotoCarouselState extends State<EventMapPhotoCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.78,
  );
  int _currentPage = 0;
  bool _isExpanded = false;
  bool _pendingExpand = false;

  void _setExpanded(bool value) {
    setState(() => _isExpanded = value);
    if (value) {
      widget.onExpanded(_currentPage);
    } else {
      widget.onCollapsed();
    }
  }

  @override
  void didUpdateWidget(EventMapPhotoCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isMapFullscreen && oldWidget.isMapFullscreen) {
      // Map left fullscreen → retract carousel
      _setExpanded(false);
    } else if (widget.isMapFullscreen && !oldWidget.isMapFullscreen && _pendingExpand) {
      // Map entered fullscreen after expand was requested → expand now
      _pendingExpand = false;
      _setExpanded(true);
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
    final textTheme = Theme.of(context).textTheme;
    final count = widget.images.length;

    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_library_rounded,
                      size: 15,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$count photo${count > 1 ? 's' : ''}',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ToggleButton(
                isExpanded: _isExpanded,
                onPressed: () {
                  if (!widget.isMapFullscreen && !_isExpanded) {
                    // Request fullscreen first; expand once it's reached
                    setState(() => _pendingExpand = true);
                    widget.onRequestFullscreen();
                  } else {
                    _setExpanded(!_isExpanded);
                  }
                },
              ),
            ],
          ),
          // ── Body (AnimatedSize) ──────────────────────────────────────────
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: kCarouselCardHeight,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: widget.images.length,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                              widget.onPageChanged(index);
                            },
                            itemBuilder: (context, index) {
                              final image = widget.images[index];
                              final isActive = index == _currentPage;
                              return AnimatedScale(
                                scale: isActive ? 1.0 : 0.90,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: _CarouselCard(
                                    image: image,
                                    isActive: isActive,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle button ────────────────────────────────────────────────────────────

class _ToggleButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onPressed;

  const _ToggleButton({required this.isExpanded, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.onPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.14),
            ),
          ),
          child: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOutCubic,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: scheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Individual card ──────────────────────────────────────────────────────────

class _CarouselCard extends StatelessWidget {
  final GeolocatedEventImage image;
  final bool isActive;

  const _CarouselCard({required this.image, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? scheme.secondary.withValues(alpha: 0.7)
                : scheme.onPrimary.withValues(alpha: 0.1),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildImage()),
            _buildInfo(context, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: CachedNetworkImage(
        imageUrl: image.url,
        cacheKey: image.key,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.black12,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.black12,
          child: const Icon(Icons.broken_image_rounded, color: Colors.white38),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context, ColorScheme scheme) {
    final location =
        image.position.placeName ??
        image.position.cityName ??
        image.position.stateName ??
        image.position.countryName;

    final dateText = image.takenDateTime != null
        ? DateFormat('d MMM yyyy', 'fr').format(image.takenDateTime!)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 12, color: scheme.secondary),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              location ?? 'Position inconnue',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (dateText != null) ...[
            const SizedBox(width: 6),
            Text(
              dateText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Glass panel ───────────────────────────────────────────────────────────────

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const _GlassPanel({
    required this.child,
    required this.padding,
    this.borderRadius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: 0.66),
                scheme.primary.withValues(alpha: 0.52),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 22,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
