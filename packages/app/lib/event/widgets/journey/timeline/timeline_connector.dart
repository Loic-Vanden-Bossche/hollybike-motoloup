/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

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
