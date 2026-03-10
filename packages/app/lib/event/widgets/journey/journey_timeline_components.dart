/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

/// Shared step-state enum used by both [JourneyTimeline] and [StepUserJourneyList].
enum TimelineStepState { past, current, future }

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

/// Dot indicator for a timeline step.
///
/// [pulseCurrent] defaults to true (pulsing glow for current step).
/// Set to false in read-only views where current = same styling as past.
class TimelineNodeCircle extends StatelessWidget {
  final TimelineStepState stepState;
  final bool pulseCurrent;

  const TimelineNodeCircle({
    super.key,
    required this.stepState,
    this.pulseCurrent = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (stepState) {
      case TimelineStepState.current:
        return pulseCurrent
            ? const TimelinePulsingDot()
            : DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondary.withValues(alpha: 0.7),
                ),
              );
      case TimelineStepState.past:
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary.withValues(alpha: 0.7),
          ),
        );
      case TimelineStepState.future:
        return DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
        );
    }
  }
}

/// Pulsing glow dot used for the current step in [JourneyTimeline].
class TimelinePulsingDot extends StatefulWidget {
  const TimelinePulsingDot({super.key});

  @override
  State<TimelinePulsingDot> createState() => _TimelinePulsingDotState();
}

class _TimelinePulsingDotState extends State<TimelinePulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _glow = Tween<double>(begin: 0.20, end: 0.65).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.secondary,
          boxShadow: [
            BoxShadow(
              color: scheme.secondary.withValues(alpha: _glow.value),
              blurRadius: 8 + _glow.value * 10,
              spreadRadius: 1 + _glow.value * 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical connector line between timeline dots.
class TimelineConnectorLine extends StatelessWidget {
  final bool dashed;
  const TimelineConnectorLine({super.key, required this.dashed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!dashed) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.secondary.withValues(alpha: 0.5),
        ),
      );
    }
    return CustomPaint(
      painter: TimelineDashedLinePainter(
        color: scheme.onPrimary.withValues(alpha: 0.2),
      ),
    );
  }
}

/// Painter for dashed connector lines.
class TimelineDashedLinePainter extends CustomPainter {
  final Color color;
  const TimelineDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(TimelineDashedLinePainter old) => old.color != color;
}

/// A thin vertical bridge that continues the connector line through the
/// vertical gap between timeline rows.
///
/// [dashed] controls whether the line is dashed or solid.
/// [withLine] set to false produces an empty gap (no line drawn).
Widget timelineConnectorBridge(
  double height, {
  required bool dashed,
  Key? key,
  bool withLine = true,
}) =>
    SizedBox(
      key: key,
      height: height,
      child: withLine
          ? Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (28 - 2) / 2,
                  width: 2,
                  child: TimelineConnectorLine(dashed: dashed),
                ),
              ],
            )
          : null,
    );
