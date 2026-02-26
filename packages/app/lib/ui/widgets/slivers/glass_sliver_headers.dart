import 'dart:ui';

import 'package:flutter/material.dart';

class GlassSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final ColorScheme colorScheme;
  final String? badgeText;
  final double height;

  const GlassSectionHeaderDelegate({
    required this.title,
    required this.colorScheme,
    this.badgeText,
    this.height = 52,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final target = (shrinkOffset > 0 || overlapsContent) ? 1.0 : 0.0;

    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) {
          final horizontalMargin = lerpDouble(0, 16, t)!;
          final verticalMargin = lerpDouble(0, 4, t)!;
          final radius = lerpDouble(0, 50, t)!;
          final blur = lerpDouble(0, 20, t)!;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: colorScheme.primary.withValues(alpha: 0.6 * t),
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.1 * t),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: colorScheme.secondary,
                        ),
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          letterSpacing: 0.3,
                          color: colorScheme.onPrimary.withValues(
                            alpha: lerpDouble(0.65, 0.75, t)!,
                          ),
                        ),
                      ),
                      if (badgeText != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: colorScheme.secondary.withValues(
                              alpha: 0.14,
                            ),
                            border: Border.all(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.28,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 11,
                              fontVariations: const [FontVariation.weight(700)],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant GlassSectionHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.badgeText != badgeText ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.height != height;
  }
}

class PinnedSpacerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  const PinnedSpacerHeaderDelegate({required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox(height: height, width: double.infinity);

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant PinnedSpacerHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }
}
