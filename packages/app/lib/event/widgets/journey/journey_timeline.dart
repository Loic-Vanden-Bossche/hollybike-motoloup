/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';

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
          final loading = state is EventJourneyOperationInProgress;
          return _buildContent(context, loading);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool loading) {
    final steps = [...eventDetails.journeySteps]
      ..sort((a, b) => a.position - b.position);

    if (loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
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
          _buildHeader(context),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),
        _buildTimeline(context, steps),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          GestureDetector(
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

  _StepState _resolveStepState(
    EventJourneyStep step,
    int? currentStepId,
    Map<int, EventJourneyStep> stepById,
  ) {
    if (step.isCurrent) return _StepState.current;
    final currentStep = currentStepId == null ? null : stepById[currentStepId];
    if (currentStep == null) return _StepState.future;
    return step.position < currentStep.position
        ? _StepState.past
        : _StepState.future;
  }

  Widget _buildTimeline(BuildContext context, List<EventJourneyStep> steps) {
    final stepById = {for (final s in steps) s.id: s};
    final stepJourneyById = <int, EventCallerParticipationStepJourney>{
      for (final sj in eventDetails.callerParticipation?.stepJourneys ?? [])
        sj.stepId: sj,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        final state = _resolveStepState(step, eventDetails.currentStepId, stepById);
        final stepJourney = stepJourneyById[step.id];

        return _TimelineRow(
          stepState: state,
          isLast: isLast,
          child: _buildStepCard(context, step, state, stepJourney),
        );
      }),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    EventJourneyStep step,
    _StepState state,
    EventCallerParticipationStepJourney? stepJourney,
  ) {
    switch (state) {
      case _StepState.current:
        return _CurrentStepCard(
          step: step,
          stepJourney: stepJourney,
          eventDetails: eventDetails,
          onViewOnMap: onViewOnMap,
        );
      case _StepState.past:
        return _PastStepCard(
          step: step,
          stepJourney: stepJourney,
          eventDetails: eventDetails,
          onViewOnMap: onViewOnMap,
        );
      case _StepState.future:
        return _FutureStepCard(step: step);
    }
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

class _TimelineRow extends StatelessWidget {
  final _StepState stepState;
  final bool isLast;
  final Widget child;

  const _TimelineRow({
    required this.stepState,
    required this.isLast,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  _NodeCircle(stepState: stepState),
                  if (!isLast)
                    Expanded(
                      child: _ConnectorLine(
                        dashed: stepState == _StepState.current ||
                            stepState == _StepState.future,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _NodeCircle extends StatelessWidget {
  final _StepState stepState;
  const _NodeCircle({required this.stepState});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (stepState) {
      case _StepState.current:
        return Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary,
            boxShadow: [
              BoxShadow(
                color: scheme.secondary.withValues(alpha: 0.45),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      case _StepState.past:
        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary.withValues(alpha: 0.7),
          ),
        );
      case _StepState.future:
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 11),
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

class _ConnectorLine extends StatelessWidget {
  final bool dashed;
  const _ConnectorLine({required this.dashed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!dashed) {
      return Center(
        child: Container(
          width: 2,
          color: scheme.secondary.withValues(alpha: 0.5),
        ),
      );
    }

    return Center(
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: scheme.onPrimary.withValues(alpha: 0.2),
        ),
        child: const SizedBox(width: 2),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

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
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

class _CurrentStepCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventCallerParticipationStepJourney? stepJourney;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const _CurrentStepCard({
    required this.step,
    required this.stepJourney,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('current — TODO');
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
    return const Text('past — TODO');
  }
}

class _FutureStepCard extends StatelessWidget {
  final EventJourneyStep step;
  const _FutureStepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return const Text('future — TODO');
  }
}

enum _StepState { past, current, future }
