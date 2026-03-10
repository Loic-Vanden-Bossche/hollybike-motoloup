/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

/// Shared decoration shell for all step cards in the timeline.
/// Handles ClipRRect + Material + Ink + InkWell + Padding uniformly.
class TimelineStepCardShell extends StatelessWidget {
  final Widget child;
  final BoxDecoration decoration;
  final VoidCallback? onTap;

  static const kPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const kRadius = BorderRadius.all(Radius.circular(22));

  const TimelineStepCardShell({
    super.key,
    required this.child,
    required this.decoration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kRadius,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Padding(
              padding: kPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
