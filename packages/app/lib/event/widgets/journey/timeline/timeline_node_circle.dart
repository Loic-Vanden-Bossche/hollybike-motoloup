/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';

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
