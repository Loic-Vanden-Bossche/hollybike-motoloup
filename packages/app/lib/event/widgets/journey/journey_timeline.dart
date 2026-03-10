/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_event.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user_journey/widgets/user_journey_modal.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';
import 'package:hollybike/event/widgets/journey/journey_timeline_components.dart';

class JourneyTimeline extends StatelessWidget {
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const JourneyTimeline({
    super.key,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) {
        if (state is EventJourneyOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }
        if (state is EventJourneyOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: BlocBuilder<EventJourneyBloc, EventJourneyState>(
        builder: (context, state) {
          final loading = state is EventJourneyOperationInProgress ||
              state is EventJourneyUploadInProgress ||
              state is EventJourneyCreationInProgress ||
              state is EventJourneyGetPositionsInProgress;
          return _buildContent(context, loading);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool loading) {
    final steps = [...eventDetails.journeySteps]
      ..sort((a, b) => a.position - b.position);

    // Initial load: no steps yet — show full spinner card.
    if (loading && steps.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, loading: false),
          const SizedBox(height: 8),
          _buildLoadingCard(context),
        ],
      );
    }

    if (steps.isEmpty) {
      if (!eventDetails.canEditJourney) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, loading: false),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: UploadJourneyMenu(
                event: eventDetails.event,
                onSelection: (type) =>
                    journeyImportModalFromType(context, type, eventDetails.event),
                child: EmptyJourneyPreviewCard(event: eventDetails.event),
              ),
            ),
          ),
        ],
      );
    }

    // Steps exist: operations show a mini loader on the Ajouter button.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, loading: loading),
        const SizedBox(height: 12),
        _buildTimeline(context, steps),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, {required bool loading}) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: scheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'ITINÉRAIRE',
          style: TextStyle(
            color: scheme.secondary.withValues(alpha: 0.8),
            fontSize: 10,
            fontVariations: const [FontVariation.weight(700)],
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        if (eventDetails.canEditJourney)
          loading
              ? Row(
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: scheme.secondary.withValues(alpha: 0.4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ajouter',
                      style: TextStyle(
                        color: scheme.secondary.withValues(alpha: 0.35),
                        fontSize: 12,
                        fontVariations: const [FontVariation.weight(650)],
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () => _onAddStep(context),
                  child: Row(
                    children: [
                      Icon(Icons.add_rounded, size: 15, color: scheme.secondary),
                      const SizedBox(width: 4),
                      Text(
                        'Ajouter',
                        style: TextStyle(
                          color: scheme.secondary,
                          fontSize: 12,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                    ],
                  ),
                ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, List<EventJourneyStep> steps) {
    final stepJourneyById = <int, EventCallerParticipationStepJourney>{
      for (final sj in eventDetails.callerParticipation?.stepJourneys ?? [])
        sj.stepId: sj,
    };
    return _AnimatedTimeline(
      steps: steps,
      stepJourneyById: stepJourneyById,
      eventDetails: eventDetails,
      onViewOnMap: onViewOnMap,
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primary.withValues(alpha: 0.56),
              scheme.primary.withValues(alpha: 0.42),
            ],
          ),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _onAddStep(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final position = box.localToGlobal(Offset.zero);

    final type = await showUploadJourneyMenu(
      context,
      position: RelativeRect.fromLTRB(
        position.dx + box.size.width,
        position.dy + 12,
        position.dx,
        position.dy,
      ),
    );

    if (type == null || !context.mounted) return;
    journeyImportModalFromType(context, type, eventDetails.event);
  }
}

// ─── Animated timeline ───────────────────────────────────────────────────────

class _AnimatedTimeline extends StatefulWidget {
  final List<EventJourneyStep> steps;
  final Map<int, EventCallerParticipationStepJourney> stepJourneyById;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const _AnimatedTimeline({
    required this.steps,
    required this.stepJourneyById,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  State<_AnimatedTimeline> createState() => _AnimatedTimelineState();
}

class _AnimatedTimelineState extends State<_AnimatedTimeline> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<EventJourneyStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = List.from(widget.steps);
  }

  @override
  void didUpdateWidget(_AnimatedTimeline old) {
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
        return _CurrentStepTitleCard(
            step: step, eventDetails: widget.eventDetails);
      case TimelineStepState.past:
        return _PastStepCard(
          step: step,
          stepJourney: stepJourney,
          eventDetails: widget.eventDetails,
          onViewOnMap: widget.onViewOnMap,
        );
      case TimelineStepState.future:
        return _FutureStepCard(
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
        ? _CurrentStepBodyCard(
            step: step,
            stepJourney: stepJourney,
            eventDetails: widget.eventDetails,
            onViewOnMap: widget.onViewOnMap,
          )
        : null;

    final row = _TimelineRow(
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

// ─── Timeline row ─────────────────────────────────────────────────────────────

/// Layout: dot is placed via [Center] inside an [IntrinsicHeight] row that
/// spans only the [titleChild] height. This guarantees the dot center aligns
/// exactly with the title text center without any hardcoded pixel offsets —
/// Flutter's layout engine does the math automatically.
///
/// For the current step, [bodyChild] is placed in a second row below, keeping
/// the dot aligned with the compact title bar, not the full expanded card.
class _TimelineRow extends StatelessWidget {
  final TimelineStepState stepState;
  final bool isFirst;
  final bool isLast;
  final Widget titleChild;
  final Widget? bodyChild;

  const _TimelineRow({
    required this.stepState,
    required this.isFirst,
    required this.isLast,
    required this.titleChild,
    this.bodyChild,
  });

  double get _dotSize {
    switch (stepState) {
      case TimelineStepState.current:
        return 14.0;
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
                child: TimelineConnectorLine(dashed: stepState == TimelineStepState.future),
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
              child: TimelineNodeCircle(stepState: stepState),
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
        // Body section animates in when the step becomes current and out when
        // it leaves the current state. AnimatedSwitcher detects the key change
        // (body ↔ gap ↔ empty) and runs SizeTransition + FadeTransition.
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
                )
              : !isLast
                  ? timelineConnectorBridge(8, dashed: _isDashed, key: const ValueKey('gap'))
                  : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}


/// Compact title bar for the current step — only the header row.
/// Kept separate from [_CurrentStepBodyCard] so the timeline dot can align
/// with this card's vertical center (= title row center) via Center().
class _CurrentStepTitleCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;

  const _CurrentStepTitleCard({
    required this.step,
    required this.eventDetails,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';

    return TimelineStepCardShell(
      decoration: BoxDecoration(
        borderRadius: TimelineStepCardShell.kRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.56),
            scheme.primary.withValues(alpha: 0.42),
          ],
        ),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              stepName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 14,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: scheme.secondary.withValues(alpha: 0.16),
            ),
            child: Text(
              'Actuelle',
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 11,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          if (eventDetails.canEditJourney) ...[
            const SizedBox(width: 4),
            _StepActionsMenu(
              step: step,
              eventDetails: eventDetails,
              forceWithoutSetCurrent: true,
            ),
          ],
        ],
      ),
    );
  }
}

/// Body content for the current step — route image, metrics, and user journey.
/// Rendered below [_CurrentStepTitleCard] in a separate timeline body row.
class _CurrentStepBodyCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventCallerParticipationStepJourney? stepJourney;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const _CurrentStepBodyCard({
    required this.step,
    required this.stepJourney,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: 0.56),
                scheme.primary.withValues(alpha: 0.42),
              ],
            ),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Route section — InkWell layered above image via Stack
                // so the ripple is visible over the image.
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: AspectRatio(
                            aspectRatio: 1.66,
                            child: LayoutBuilder(
                              builder: (context, constraints) => OverflowBox(
                                maxHeight: constraints.maxHeight + 25,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight + 25,
                                  child: JourneyImage(
                                    imageKey: step.journey.previewImageKey,
                                    imageUrl: step.journey.previewImage,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _MetricChip(
                              icon: Icons.route_outlined,
                              label: step.journey.distanceLabel,
                            ),
                            _MetricChip(
                              icon: Icons.north_east_rounded,
                              label: '${step.journey.totalElevationGain ?? 0} m',
                            ),
                            _MetricChip(
                              icon: Icons.south_east_rounded,
                              label: '${step.journey.totalElevationLoss ?? 0} m',
                            ),
                            if (step.journey.readablePartialLocation != null)
                              _MetricChip(
                                icon: Icons.location_on_outlined,
                                label: step.journey.readablePartialLocation!,
                              ),
                          ],
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openRouteDetails(context),
                        ),
                      ),
                    ),
                  ],
                ),
                // User journey section
                ..._buildUserJourneySection(context, scheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openRouteDetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<EventJourneyBloc>(),
        child: JourneyModal(
          journey: step.journey,
          stepId: step.id,
          onViewOnMap: onViewOnMap,
        ),
      ),
    );
  }

  void _openUserJourneyDetails(BuildContext context, UserJourney journey) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => UserJourneyModal(
        journey: journey,
        isCurrentEvent: true,
        stepId: step.id,
      ),
    );
  }

  List<Widget> _buildUserJourneySection(
      BuildContext context, ColorScheme scheme) {
    final sj = stepJourney;

    // No participation record for this user — suppress the section entirely
    if (sj == null) return [];

    final journey = sj.journey;

    // Divider with "MON TRAJET" label
    final divider = <Widget>[
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'MON TRAJET',
            style: TextStyle(
              color: scheme.secondary.withValues(alpha: 0.65),
              fontSize: 9,
              fontVariations: const [FontVariation.weight(700)],
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ];

    if (journey != null) {
      return [
        SizedBox(
          width: double.infinity,
          child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _openUserJourneyDetails(context, journey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...divider,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      journey.distanceLabel,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 24,
                        fontVariations: const [FontVariation.weight(760)],
                        height: 1.0,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.secondary.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: scheme.onPrimary.withValues(alpha: 0.78),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          journey.totalTimeLabel,
                          style: TextStyle(
                            color: scheme.onPrimary.withValues(alpha: 0.86),
                            fontSize: 11.5,
                            fontVariations: const [FontVariation.weight(650)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _MetricChip(
                    icon: Icons.north_east_rounded,
                    label: 'D+ ${journey.totalElevationGain?.round() ?? 0} m',
                    accent: scheme.secondary,
                  ),
                  _MetricChip(
                    icon: Icons.terrain_rounded,
                    label: 'Alt ${journey.maxElevation?.round() ?? 0} m',
                    accent: scheme.secondary,
                  ),
                  _MetricChip(
                    icon: Icons.speed_rounded,
                    label: journey.maxSpeedLabel,
                    accent: scheme.secondary,
                  ),
                  _MetricChip(
                    icon: Icons.gps_fixed_rounded,
                    label: journey.maxGForceLabel,
                    accent: scheme.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ];
    }

    // No journey yet
    if (sj.hasRecordedPositions) {
      return [
        ...divider,
        FilledButton.tonal(
          onPressed: () => context.read<EventDetailsBloc>().add(
                TerminateUserJourney(stepId: step.id),
              ),
          child: const Text('Terminer le parcours'),
        ),
      ];
    }

    return [
      ...divider,
      Text(
        'Aucune position reçue pour cette étape.',
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.55),
          fontSize: 12,
          fontVariations: const [FontVariation.weight(500)],
        ),
      ),
    ];
  }
}

class _PastStepCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventCallerParticipationStepJourney? stepJourney;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const _PastStepCard({
    required this.step,
    required this.stepJourney,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';
    final journey = stepJourney?.journey;

    return TimelineStepCardShell(
      decoration: BoxDecoration(
        borderRadius: TimelineStepCardShell.kRadius,
        color: scheme.primaryContainer.withValues(alpha: 0.30),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      onTap: () => _openDetails(context),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: scheme.secondary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              stepName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.75),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(600)],
              ),
            ),
          ),
          if (journey != null) ...[
            const SizedBox(width: 8),
            _SmallChip(label: journey.distanceLabel, scheme: scheme),
            const SizedBox(width: 6),
            _SmallChip(
              icon: Icons.schedule_rounded,
              label: journey.totalTimeLabel,
              scheme: scheme,
            ),
          ] else if (stepJourney != null) ...[
            const SizedBox(width: 8),
            _SmallChip(
              label: step.journey.distanceLabel,
              scheme: scheme,
              muted: true,
            ),
          ],
          if (eventDetails.canEditJourney) ...[
            const SizedBox(width: 4),
            _StepActionsMenu(
              step: step,
              eventDetails: eventDetails,
            ),
          ],
        ],
      ),
    );
  }

  void _openDetails(BuildContext context) {
    final journey = stepJourney?.journey;
    if (journey != null) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (_) => UserJourneyModal(
          journey: journey,
          isCurrentEvent: true,
          stepId: step.id,
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<EventJourneyBloc>(),
          child: JourneyModal(
            journey: step.journey,
            stepId: step.id,
            onViewOnMap: onViewOnMap,
          ),
        ),
      );
    }
  }
}

class _FutureStepCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const _FutureStepCard({
    required this.step,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';

    return Opacity(
      opacity: 0.5,
      child: TimelineStepCardShell(
        decoration: BoxDecoration(
          borderRadius: TimelineStepCardShell.kRadius,
          color: scheme.primaryContainer.withValues(alpha: 0.15),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
        onTap: () => _openDetails(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                stepName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(550)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SmallChip(
              label: step.journey.distanceLabel,
              scheme: scheme,
              muted: true,
            ),
            if (eventDetails.canEditJourney) ...[
              const SizedBox(width: 4),
              _StepActionsMenu(
                step: step,
                eventDetails: eventDetails,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<EventJourneyBloc>(),
        child: JourneyModal(
          journey: step.journey,
          stepId: step.id,
          onViewOnMap: onViewOnMap,
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? accent;

  const _MetricChip({required this.icon, required this.label, this.accent});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = accent ?? scheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.withValues(alpha: 0.70)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.85),
              fontSize: 11,
              fontVariations: const [FontVariation.weight(600)],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final ColorScheme scheme;
  final IconData? icon;
  final bool muted;

  const _SmallChip({
    required this.label,
    required this.scheme,
    this.icon,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scheme.onPrimary.withValues(alpha: muted ? 0.05 : 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 11,
              color: scheme.onPrimary.withValues(alpha: muted ? 0.35 : 0.55),
            ),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: muted ? 0.40 : 0.70),
              fontSize: 10.5,
              fontVariations: const [FontVariation.weight(600)],
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepAction { rename, setCurrent, remove }

class _DialogButton extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primary
              ? scheme.secondary.withValues(alpha: 0.15)
              : scheme.primaryContainer.withValues(alpha: 0.45),
          border: Border.all(
            color: primary
                ? scheme.secondary.withValues(alpha: 0.42)
                : scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primary
                ? scheme.secondary
                : scheme.onPrimary.withValues(alpha: 0.72),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(650)],
          ),
        ),
      ),
    );
  }
}

class _StepActionsMenu extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;
  final bool forceWithoutSetCurrent;

  const _StepActionsMenu({
    required this.step,
    required this.eventDetails,
    this.forceWithoutSetCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassPopupMenuButton<_StepAction>(
      padding: EdgeInsets.zero,
      onSelected: (action) => _onAction(context, action),
      itemBuilder: (_) => [
        glassPopupMenuItem(
          value: _StepAction.rename,
          label: 'Renommer',
          icon: Icons.edit_rounded,
        ),
        if (!step.isCurrent && !forceWithoutSetCurrent)
          glassPopupMenuItem(
            value: _StepAction.setCurrent,
            label: 'Définir comme actuelle',
            icon: Icons.flag_rounded,
          ),
        glassPopupMenuItem(
          value: _StepAction.remove,
          label: 'Retirer',
          icon: Icons.delete_rounded,
          color: scheme.error,
        ),
      ],
    );
  }

  Future<void> _onAction(BuildContext context, _StepAction action) async {
    switch (action) {
      case _StepAction.rename:
        final controller = TextEditingController(
            text: step.name ?? 'Étape ${step.position}');
        final name = await showDialog<String?>(
          context: context,
          builder: (d) => GlassDialog(
            title: 'Nom de l\'étape',
            onClose: () => Navigator.of(d).pop(null),
            body: TextField(
              controller: controller,
              decoration: buildGlassInputDecoration(d, labelText: 'Nom'),
              textInputAction: TextInputAction.done,
              onSubmitted: (v) => Navigator.of(d).pop(v.trim()),
              autofocus: true,
            ),
            actions: [
              _DialogButton(
                label: 'Annuler',
                onTap: () => Navigator.of(d).pop(null),
              ),
              _DialogButton(
                label: 'Valider',
                primary: true,
                onTap: () => Navigator.of(d).pop(controller.text.trim()),
              ),
            ],
          ),
        );
        // Dispose after the dismiss animation so the TextField
        // doesn't access a dead controller while animating out.
        WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
        if (name == null || name.isEmpty || !context.mounted) return;
        context.read<EventJourneyBloc>().add(
              RenameJourneyStepInEvent(
                eventId: eventDetails.event.id,
                stepId: step.id,
                name: name,
              ),
            );
        return;
      case _StepAction.setCurrent:
        context.read<EventJourneyBloc>().add(
              SetCurrentJourneyStep(
                eventId: eventDetails.event.id,
                stepId: step.id,
              ),
            );
        return;
      case _StepAction.remove:
        final confirmed = await showGlassConfirmationDialog(
          context: context,
          title: 'Retirer l\'étape',
          message: 'Retirer cette étape de l\'itinéraire ?',
          confirmLabel: 'Retirer',
          destructiveConfirm: true,
        );
        if (confirmed != true || !context.mounted) return;
        context.read<EventJourneyBloc>().add(
              RemoveJourneyStepFromEvent(
                eventId: eventDetails.event.id,
                stepId: step.id,
              ),
            );
        return;
    }
  }
}
