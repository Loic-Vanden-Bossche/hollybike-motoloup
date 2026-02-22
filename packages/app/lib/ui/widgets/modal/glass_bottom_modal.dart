import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBottomModal extends StatelessWidget {
  final Widget child;
  final double maxContentHeight;
  final EdgeInsets margin;
  final EdgeInsets contentPadding;
  final bool showGrabber;

  const GlassBottomModal({
    super.key,
    required this.child,
    this.maxContentHeight = 440,
    this.margin = const EdgeInsets.fromLTRB(10, 0, 10, 0),
    this.contentPadding = const EdgeInsets.fromLTRB(14, 10, 14, 6),
    this.showGrabber = true,
  });

  static const _kTopRadius = 32.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_kTopRadius),
          topRight: Radius.circular(_kTopRadius),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withValues(alpha: 0.62),
                      scheme.primary.withValues(alpha: 0.48),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -70,
              left: -50,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.secondary.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -30,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.tertiary.withValues(alpha: 0.14),
                    ),
                  ),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_kTopRadius),
                    topRight: Radius.circular(_kTopRadius),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: scheme.onPrimary.withValues(alpha: 0.14),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: scheme.onPrimary.withValues(alpha: 0.14),
                      width: 1,
                    ),
                    right: BorderSide(
                      color: scheme.onPrimary.withValues(alpha: 0.14),
                      width: 1,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 30,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: contentPadding,
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showGrabber) ...[
                          _buildGrabber(scheme),
                          const SizedBox(height: 10),
                        ],
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: maxContentHeight),
                          child: child,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrabber(ColorScheme scheme) {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: scheme.onPrimary.withValues(alpha: 0.35),
      ),
    );
  }
}
