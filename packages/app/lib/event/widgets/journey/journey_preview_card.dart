/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and LoÃ¯c Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_event.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';
import 'journey_import_modal_from_type.dart';
import 'journey_preview_card_container.dart';

class JourneyPreviewCard extends StatelessWidget {
  final EventDetails eventDetails;
  final bool canAddJourney;
  final void Function(int stepId) onViewOnMap;

  const JourneyPreviewCard({
    super.key,
    required this.eventDetails,
    required this.canAddJourney,
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
          return _buildJourneyPreview(
            context,
            state is EventJourneyOperationInProgress,
          );
        },
      ),
    );
  }

  Widget _buildJourneyPreview(BuildContext context, bool loadingOperation) {
    final steps = [...eventDetails.journeySteps]
      ..sort((a, b) => a.position - b.position);

    if (steps.isEmpty && !loadingOperation) {
      if (!canAddJourney) return const SizedBox.shrink();

      return SizedBox(
        height: 140,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: UploadJourneyMenu(
            event: eventDetails.event,
            onSelection: (type) {
              journeyImportModalFromType(context, type, eventDetails.event);
            },
            child: EmptyJourneyPreviewCard(event: eventDetails.event),
          ),
        ),
      );
    }

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 400),
      crossFadeState:
          loadingOperation
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
      firstChild: _buildSteps(context, steps),
      secondChild: SizedBox(height: 140, child: _buildLoadingCard(context)),
    );
  }

  Widget _buildSteps(BuildContext context, List<EventJourneyStep> steps) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JourneyPreviewCardContainer(
          child: Row(
            children: [
              Text(
                'Etapes',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 14,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const Spacer(),
              if (canAddJourney)
                GestureDetector(
                  onTap: () => _onAddStep(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 15,
                        color: scheme.secondary,
                      ),
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
          ),
        ),
        const SizedBox(height: 8),
        ...steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildAnimatedStepCard(context, step),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedStepCard(BuildContext context, EventJourneyStep step) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(sizeFactor: animation, child: child),
          );
        },
        child:
            step.isCurrent
                ? _buildCurrentStepCard(context, step)
                : _buildCompactStepCard(context, step),
      ),
    );
  }

  Widget _buildCurrentStepCard(BuildContext context, EventJourneyStep step) {
    final scheme = Theme.of(context).colorScheme;

    return JourneyPreviewCardContainer(
      key: ValueKey('current-${step.id}'),
      onTap: () => _openStepDetails(context, step),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  step.name ?? 'Etape ${step.position}',
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
                _buildStepActions(context, step, forceWithoutSetCurrent: true),
              ],
            ],
          ),
          const SizedBox(height: 10),
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
          Row(
            children: [
              _metricChip(
                context,
                icon: Icons.route_outlined,
                label: step.journey.distanceLabel,
              ),
              const SizedBox(width: 8),
              _metricChip(
                context,
                icon: Icons.north_east_rounded,
                label: '${step.journey.totalElevationGain ?? 0} m',
              ),
              const SizedBox(width: 8),
              _metricChip(
                context,
                icon: Icons.south_east_rounded,
                label: '${step.journey.totalElevationLoss ?? 0} m',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricChip(
                context,
                icon: Icons.vertical_align_bottom_rounded,
                label: '${step.journey.minElevation ?? 0} m',
              ),
              _metricChip(
                context,
                icon: Icons.terrain_rounded,
                label: '${step.journey.maxElevation ?? 0} m',
              ),
              if (step.journey.readablePartialLocation != null)
                _metricChip(
                  context,
                  icon: Icons.location_on_outlined,
                  label: step.journey.readablePartialLocation!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStepCard(BuildContext context, EventJourneyStep step) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      key: ValueKey('compact-${step.id}'),
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: scheme.primaryContainer.withValues(alpha: 0.35),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _openStepDetails(context, step),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 58,
                    height: 44,
                    child: JourneyImage(
                      imageKey: step.journey.previewImageKey,
                      imageUrl: step.journey.previewImage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.name ?? 'Etape ${step.position}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.journey.distanceLabel,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.60),
                          fontSize: 12,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                      ),
                    ],
                  ),
                ),
                if (eventDetails.canEditJourney) ...[
                  const SizedBox(width: 4),
                  _buildStepActions(context, step),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepActions(
    BuildContext context,
    EventJourneyStep step, {
    bool forceWithoutSetCurrent = false,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return PopupMenuButton<_StepAction>(
      icon: Icon(
        Icons.more_horiz_rounded,
        size: 18,
        color: scheme.onPrimary.withValues(alpha: 0.7),
      ),
      onSelected: (action) => _onStepAction(context, step, action),
      itemBuilder:
          (_) => [
            const PopupMenuItem(
              value: _StepAction.rename,
              child: Text('Renommer'),
            ),
            if (!step.isCurrent && !forceWithoutSetCurrent)
              const PopupMenuItem(
                value: _StepAction.setCurrent,
                child: Text('Definir comme actuelle'),
              ),
            PopupMenuItem(
              value: _StepAction.remove,
              child: Text('Retirer', style: TextStyle(color: scheme.error)),
            ),
          ],
    );
  }

  Widget _metricChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: scheme.onPrimary.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: scheme.onPrimary.withValues(alpha: 0.70)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.85),
              fontSize: 11,
              fontVariations: const [FontVariation.weight(600)],
            ),
          ),
        ],
      ),
    );
  }

  void _openStepDetails(BuildContext context, EventJourneyStep step) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: context.read<EventJourneyBloc>(),
            child: JourneyModal(
              journey: step.journey,
              stepId: step.id,
              onViewOnMap: onViewOnMap,
            ),
          ),
    );
  }

  Future<void> _onStepAction(
    BuildContext context,
    EventJourneyStep step,
    _StepAction action,
  ) async {
    switch (action) {
      case _StepAction.rename:
        final name = await _askStepName(
          context,
          initialValue: step.name ?? 'Etape ${step.position}',
        );
        if (name == null) return;
        if (!context.mounted) return;
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

  Future<String?> _askStepName(
    BuildContext context, {
    String? initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final name = await showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nom de l\'etape'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Ex: Aller'),
            textInputAction: TextInputAction.done,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(dialogContext).pop(controller.text.trim()),
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );

    if (name == null || name.isEmpty) {
      return null;
    }

    return name;
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

    journeyImportModalFromType(
      context,
      type,
      eventDetails.event,
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
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
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

enum _StepAction { rename, setCurrent, remove }
