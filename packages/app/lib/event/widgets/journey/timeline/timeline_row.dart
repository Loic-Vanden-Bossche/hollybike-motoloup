/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_connector.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_node_circle.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';

/// Layout: dot is placed via [Center] inside an [IntrinsicHeight] row that
/// spans only the [titleChild] height. This guarantees the dot center aligns
/// exactly with the title text center without any hardcoded pixel offsets —
/// Flutter's layout engine does the math automatically.
///
/// For the current step, [bodyChild] is placed in a second row below, keeping
/// the dot aligned with the compact title bar, not the full expanded card.
///
/// [pulseCurrent] — set to false in read-only views (participant timeline) so
/// the current dot uses the same solid style as past steps.
///
/// [animateBody] — set to false to render the body section without
/// AnimatedSwitcher transitions (e.g. always-expanded participant rows).
class TimelineRow extends StatelessWidget {
  final TimelineStepState stepState;
  final bool isFirst;
  final bool isLast;
  final Widget titleChild;
  final Widget? bodyChild;
  final bool pulseCurrent;
  final bool animateBody;

  const TimelineRow({
    super.key,
    required this.stepState,
    required this.isFirst,
    required this.isLast,
    required this.titleChild,
    this.bodyChild,
    this.pulseCurrent = true,
    this.animateBody = true,
  });

  double get _dotSize {
    switch (stepState) {
      case TimelineStepState.current:
        // Participant view (no pulse) uses the same size as past dots.
        return pulseCurrent ? 14.0 : 12.0;
      case TimelineStepState.past:
        return 12.0;
      case TimelineStepState.future:
        return 10.0;
    }
  }

  bool get _isDashed => stepState != TimelineStepState.past;

  @override
  Widget build(BuildContext context) {
    final dotSize = _dotSize;
    final scheme = Theme.of(context).colorScheme;
    // Only draw the outgoing connector when there is a real next step below.
    // The body card is part of the current step, not a next step.
    final hasBelow = !isLast;

    // Left rail for the title row.
    // FractionallySizedBox splits the rail at exactly 50% height (= dot center),
    // so connectors meet precisely at the dot center regardless of card height.
    final titleRail = SizedBox(
      width: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Incoming connector: top half → dot center
          if (!isFirst)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.topCenter,
                child: TimelineConnectorLine(
                    dashed: stepState == TimelineStepState.future),
              ),
            ),
          // Outgoing connector: dot center → bottom half
          if (hasBelow)
            Positioned(
              top: 0,
              bottom: 0,
              left: (28 - 2) / 2,
              width: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                alignment: Alignment.bottomCenter,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ),
          // Opaque background circle — blocks connector from showing through dot
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                ),
              ),
            ),
          ),
          // Dot indicator — centered in the rail = centered with titleChild
          Center(
            child: SizedBox(
              width: dotSize,
              height: dotSize,
              child: TimelineNodeCircle(
                stepState: stepState,
                pulseCurrent: pulseCurrent,
              ),
            ),
          ),
        ],
      ),
    );

    // Body rail: full-height connector alongside the body card.
    final bodyRail = SizedBox(
      width: 28,
      child: !isLast
          ? Stack(children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: (28 - 2) / 2,
                width: 2,
                child: TimelineConnectorLine(dashed: _isDashed),
              ),
            ])
          : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title row.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleRail,
              const SizedBox(width: 10),
              Expanded(child: titleChild),
            ],
          ),
        ),
        // Body section — animated when [animateBody] is true (editable timeline),
        // direct when false (read-only participant rows).
        if (animateBody)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 520),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, anim) => AnimatedBuilder(
              animation: anim,
              builder: (context, inner) => Align(
                alignment: Alignment.topCenter,
                heightFactor: anim.value,
                child: inner,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                child: child,
              ),
            ),
            child: bodyChild != null
                ? Column(
                    key: const ValueKey('body'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      timelineConnectorBridge(4,
                          dashed: _isDashed, withLine: !isLast),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            bodyRail,
                            const SizedBox(width: 10),
                            Expanded(child: bodyChild!),
                          ],
                        ),
                      ),
                      if (!isLast) timelineConnectorBridge(8, dashed: _isDashed),
                    ],
                  )
                : !isLast
                    ? timelineConnectorBridge(8,
                        dashed: _isDashed, key: const ValueKey('gap'))
                    : const SizedBox.shrink(key: ValueKey('empty')),
          )
        else
          _buildDirectBody(bodyRail),
      ],
    );
  }

  /// Non-animated body for read-only views — renders body and gap directly.
  Widget _buildDirectBody(Widget bodyRail) {
    if (bodyChild != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          timelineConnectorBridge(4, dashed: _isDashed, withLine: !isLast),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bodyRail,
                const SizedBox(width: 10),
                Expanded(child: bodyChild!),
              ],
            ),
          ),
          if (!isLast) timelineConnectorBridge(8, dashed: _isDashed),
        ],
      );
    }
    if (!isLast) return timelineConnectorBridge(8, dashed: _isDashed);
    return const SizedBox.shrink();
  }
}
