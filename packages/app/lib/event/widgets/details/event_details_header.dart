/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/minimal_event.dart';

class EventDetailsHeader extends StatelessWidget {
  final MinimalEvent event;
  final bool animate;
  final String uniqueKey;

  const EventDetailsHeader({
    super.key,
    required this.animate,
    required this.event,
    required this.uniqueKey,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Hero image (badge lives inside so it's in the shuttle overlay) ──
          HeroMode(
            enabled: animate,
            child: Hero(
              tag: "event-image-$uniqueKey",
              flightShuttleBuilder: (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                final shuttle = (toHeroContext.widget as Hero).child;
                return AnimatedBuilder(
                  animation: animation,
                  child: shuttle,
                  builder: (context, child) {
                    final progress =
                        animation.status == AnimationStatus.reverse
                            ? 1 - animation.value
                            : animation.value;
                    final radius =
                        flightDirection == HeroFlightDirection.push
                            ? lerpDouble(16, 0, progress)!
                            : lerpDouble(0, 16, progress)!;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: child,
                    );
                  },
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: event.imageProvider,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder:
                        (context, error, stackTrace) => ColoredBox(
                          color: scheme.primary.withValues(alpha: 0.3),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_rounded,
                              color: scheme.onPrimary.withValues(alpha: 0.3),
                              size: 48,
                            ),
                          ),
                        ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.30, 0.65, 1.0],
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          scheme.primaryContainer.withValues(alpha: 0.50),
                          scheme.primaryContainer,
                        ],
                      ),
                    ),
                  ),
                  // Badge inside the Hero so it's present in the shuttle
                  // during flight and at the same position when it lands.
                  // bottom: 18 (Positioned) + 10 (spacer) + 26*1.1 (1-line title) ≈ 57
                  Positioned(
                    left: 16,
                    bottom: 57,
                    child: Material(
                      color: Colors.transparent,
                      child: _DateBadge(date: event.startDate),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Event name Hero ───────────────────────────────────────────────
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: HeroMode(
              enabled: animate,
              child: Hero(
                tag: "event-name-$uniqueKey",
                flightShuttleBuilder: (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) {
                  final shuttle = (toHeroContext.widget as Hero).child;
                  return Material(
                    color: Colors.transparent,
                    child: ClipRect(
                      child: SizedBox.expand(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: shuttle,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontVariations: [FontVariation.weight(800)],
                    height: 1.1,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 12,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date glass pill ────────────────────────────────────────────────────────────

class _DateBadge extends StatelessWidget {
  final DateTime date;

  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    final maxBadgeWidth = MediaQuery.sizeOf(context).width - 64;

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBadgeWidth),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black.withValues(alpha: 0.32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white70,
                  size: 11,
                ),
                const SizedBox(width: 6),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    _formatDate(date),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontVariations: [FontVariation.weight(650)],
                      letterSpacing: 0.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _monthName(date.month);
    final year = date.year;
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$day $month $year · $hours:$minutes';
  }

  String _monthName(int month) {
    const months = [
      'jan.',
      'fév.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sep.',
      'oct.',
      'nov.',
      'déc.',
    ];
    return months[month - 1];
  }
}
