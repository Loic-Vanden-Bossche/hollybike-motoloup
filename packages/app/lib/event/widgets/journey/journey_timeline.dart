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
import 'package:hollybike/user_journey/widgets/user_journey_modal.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final stepName = step.name?.trim().isNotEmpty == true
        ? step.name!
        : 'Étape ${step.position}';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: step name + Actuelle badge + admin menu
                Row(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                const SizedBox(height: 10),
                // Route preview image
                SizedBox(
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: JourneyImage(
                      imageKey: step.journey.previewImageKey,
                      imageUrl: step.journey.previewImage,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Route metrics
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
                // User journey section
                ..._buildUserJourneySection(context, scheme),
              ],
            ),
          ),
        ),
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

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: scheme.primaryContainer.withValues(alpha: 0.30),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openDetails(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
          ),
        ),
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
  const _FutureStepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return const Text('future — TODO');
  }
}

enum _StepState { past, current, future }

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

    return PopupMenuButton<_StepAction>(
      icon: Icon(
        Icons.more_horiz_rounded,
        size: 18,
        color: scheme.onPrimary.withValues(alpha: 0.7),
      ),
      onSelected: (action) => _onAction(context, action),
      itemBuilder: (_) => [
        const PopupMenuItem(value: _StepAction.rename, child: Text('Renommer')),
        if (!step.isCurrent && !forceWithoutSetCurrent)
          const PopupMenuItem(
            value: _StepAction.setCurrent,
            child: Text('Définir comme actuelle'),
          ),
        PopupMenuItem(
          value: _StepAction.remove,
          child: Text('Retirer', style: TextStyle(color: scheme.error)),
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
          builder: (d) => AlertDialog(
            title: const Text('Nom de l\'étape'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Ex: Aller'),
              textInputAction: TextInputAction.done,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(d).pop(null),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(d).pop(controller.text.trim()),
                child: const Text('Valider'),
              ),
            ],
          ),
        );
        controller.dispose();
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
