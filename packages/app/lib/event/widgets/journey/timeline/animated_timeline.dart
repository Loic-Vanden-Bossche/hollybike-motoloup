/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_current_step_body_card.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_current_step_title_card.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_future_step_card.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_past_step_card.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_row.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';

class AnimatedTimeline extends StatefulWidget {
  final List<EventJourneyStep> steps;
  final Map<int, EventCallerParticipationStepJourney> stepJourneyById;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const AnimatedTimeline({
    super.key,
    required this.steps,
    required this.stepJourneyById,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  State<AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends State<AnimatedTimeline> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<EventJourneyStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = List.from(widget.steps);
  }

  @override
  void didUpdateWidget(AnimatedTimeline old) {
    super.didUpdateWidget(old);
    _syncSteps(widget.steps);
  }

  void _syncSteps(List<EventJourneyStep> newSteps) {
    // Removals — iterate backwards to keep indices stable
    for (int i = _steps.length - 1; i >= 0; i--) {
      if (!newSteps.any((s) => s.id == _steps[i].id)) {
        final removed = _steps.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (ctx, anim) => _buildAnimatedItem(ctx, removed, i, anim),
          duration: const Duration(milliseconds: 350),
        );
      }
    }
    // Insertions
    for (int i = 0; i < newSteps.length; i++) {
      if (!_steps.any((s) => s.id == newSteps[i].id)) {
        _steps.insert(i, newSteps[i]);
        _listKey.currentState?.insertItem(
          i,
          duration: const Duration(milliseconds: 480),
        );
      }
    }
    // State updates (e.g. set current)
    setState(() {
      for (int i = 0; i < _steps.length; i++) {
        final updated = newSteps.firstWhere(
          (s) => s.id == _steps[i].id,
          orElse: () => _steps[i],
        );
        if (updated != _steps[i]) _steps[i] = updated;
      }
    });
  }

  TimelineStepState _resolveState(EventJourneyStep step) {
    if (step.isCurrent) return TimelineStepState.current;
    final stepById = {for (final s in widget.steps) s.id: s};
    final currentStep = widget.eventDetails.currentStepId == null
        ? null
        : stepById[widget.eventDetails.currentStepId];
    if (currentStep == null) return TimelineStepState.future;
    return step.position < currentStep.position
        ? TimelineStepState.past
        : TimelineStepState.future;
  }

  Widget _buildTitle(
    EventJourneyStep step,
    TimelineStepState state,
    EventCallerParticipationStepJourney? stepJourney,
  ) {
    switch (state) {
      case TimelineStepState.current:
        return TimelineCurrentStepTitleCard(
            step: step, eventDetails: widget.eventDetails);
      case TimelineStepState.past:
        return TimelinePastStepCard(
          step: step,
          stepJourney: stepJourney,
          eventDetails: widget.eventDetails,
          onViewOnMap: widget.onViewOnMap,
        );
      case TimelineStepState.future:
        return TimelineFutureStepCard(
          step: step,
          eventDetails: widget.eventDetails,
          onViewOnMap: widget.onViewOnMap,
        );
    }
  }

  Widget _buildAnimatedItem(
    BuildContext context,
    EventJourneyStep step,
    int index,
    Animation<double> animation,
  ) {
    final isFirst = index == 0;
    final isLast = index == _steps.length - 1;
    final state = _resolveState(step);
    final stepJourney = widget.stepJourneyById[step.id];

    // Title card animates when step state changes (past ↔ current ↔ future)
    final titleChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.12),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey('${step.id}_$state'),
        child: _buildTitle(step, state, stepJourney),
      ),
    );

    final bodyChild = state == TimelineStepState.current
        ? TimelineCurrentStepBodyCard(
            step: step,
            stepJourney: stepJourney,
            eventDetails: widget.eventDetails,
            onViewOnMap: widget.onViewOnMap,
          )
        : null;

    final row = TimelineRow(
      stepState: state,
      isFirst: isFirst,
      isLast: isLast,
      titleChild: titleChild,
      bodyChild: bodyChild,
    );

    // Add / remove animations: slide from right + fade + height expand.
    // Use AnimatedBuilder + Align(heightFactor) instead of SizeTransition so
    // there is no internal ClipRect that would cut off the pulsing dot glow.
    final heightCurve =
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: heightCurve,
      builder: (context, child) => Align(
        alignment: Alignment.topCenter,
        heightFactor: heightCurve.value,
        child: child,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.18, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: row,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _steps.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) =>
          _buildAnimatedItem(context, _steps[index], index, animation),
    );
  }
}
