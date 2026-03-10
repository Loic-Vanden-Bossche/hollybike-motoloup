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
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/event/widgets/journey/timeline/animated_timeline.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
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
    return AnimatedTimeline(
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
