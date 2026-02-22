/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/journey_preview_card_content.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';

import '../../../journey/type/minimal_journey.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';
import 'journey_import_modal_from_type.dart';
import 'journey_preview_card_container.dart';

class JourneyPreviewCard extends StatelessWidget {
  final EventDetails eventDetails;
  final MinimalJourney? journey;
  final bool canAddJourney;
  final void Function() onViewOnMap;

  const JourneyPreviewCard({
    super.key,
    required this.journey,
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
            state is EventJourneyGetPositionsInProgress,
            state is EventJourneyOperationInProgress,
          );
        },
      ),
    );
  }

  Widget _buildJourneyPreview(
    BuildContext context,
    bool loadingPositions,
    bool loadingOperation,
  ) {
    if (journey == null && !loadingOperation) {
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
      duration: const Duration(milliseconds: 500),
      crossFadeState:
          loadingOperation
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
      firstChild: SizedBox(
        height: 140,
        child: JourneyPreviewCardContainer(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<EventJourneyBloc>(),
                    child: JourneyModal(
                      journey: journey!,
                      eventDetails: eventDetails,
                      onViewOnMap: onViewOnMap,
                    ),
                  ),
            );
          },
          child: JourneyPreviewCardContent(
            journey: journey,
            loadingPositions: loadingPositions,
          ),
        ),
      ),
      secondChild: SizedBox(
        height: 140,
        child: _buildLoadingCard(context),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
      ),
    );
  }
}
