/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ThemedRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double? edgeOffset;
  final double? displacement;

  const ThemedRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.edgeOffset,
    this.displacement,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      edgeOffset: edgeOffset ?? 0,
      displacement: displacement ?? 40,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
