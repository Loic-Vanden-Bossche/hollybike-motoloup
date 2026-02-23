/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class BarContainer extends StatelessWidget {
  final Widget? child;
  final Alignment alignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const BarContainer({
    super.key,
    required this.child,
    this.alignment = Alignment.centerLeft,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: margin,
      height: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.66),
                    scheme.primary.withValues(alpha: 0.52),
                  ],
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: padding,
                alignment: alignment,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
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
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
