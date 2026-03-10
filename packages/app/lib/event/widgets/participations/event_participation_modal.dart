/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/types/participation/event_participation.dart';
import 'package:hollybike/event/widgets/journey/step_user_journey_list/step_user_journey_list.dart';
import 'package:hollybike/shared/utils/dates.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card_display_context.dart';

import '../event_loading_profile_picture.dart';
import '../../../user_journey/widgets/user_journey_card.dart';

class EventParticipationModal extends StatelessWidget {
  final EventParticipation participation;

  const EventParticipationModal({super.key, required this.participation});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    EventDetailsBloc? eventDetailsBloc;
    try {
      eventDetailsBloc = context.read<EventDetailsBloc>();
    } catch (_) {
      eventDetailsBloc = null;
    }
    final stepJourneyCardsWidget =
        eventDetailsBloc == null
            ? (participation.stepJourneys.length <= 1
                ? UserJourneyCard(
                  journey: participation.journey,
                  user: participation.user,
                  color: scheme.secondary.withValues(alpha: 0.18),
                  isCurrentEvent: true,
                  displayContext: UserJourneyCardDisplayContext.event,
                )
                : StepUserJourneyList(
                  stepJourneys: participation.stepJourneys,
                  journeySteps: const [],
                  currentStepId: null,
                  user: participation.user,
                ))
            : BlocBuilder<EventDetailsBloc, EventDetailsState>(
              bloc: eventDetailsBloc,
              builder: (context, state) {
                final details = state.eventDetails;
                final eventSteps = details?.journeySteps ?? const [];
                final currentStepId = details?.currentStepId;
                if (eventSteps.length <= 1) {
                  return UserJourneyCard(
                    journey: participation.journey,
                    user: participation.user,
                    color: scheme.secondary.withValues(alpha: 0.18),
                    isCurrentEvent: true,
                    displayContext: UserJourneyCardDisplayContext.event,
                  );
                }
                return StepUserJourneyList(
                  stepJourneys: participation.stepJourneys,
                  journeySteps: eventSteps,
                  currentStepId: currentStepId,
                  user: participation.user,
                );
              },
            );

    return GlassBottomModal(
      maxContentHeight: 540,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: "user-${participation.user.id}-profile-picture",
                child: UserProfilePicture(
                  url: participation.user.profilePicture,
                  profilePictureKey: participation.user.profilePictureKey,
                  radius: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "user-${participation.user.id}-username",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          participation.user.username,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: scheme.onPrimary,
                            fontVariations: const [FontVariation.weight(760)],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      participation.roleName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.secondary,
                        fontVariations: const [FontVariation.weight(650)],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _onOpenUserProfile(context),
                style: IconButton.styleFrom(
                  backgroundColor: scheme.secondary.withValues(alpha: 0.16),
                  foregroundColor: scheme.secondary,
                ),
                icon: const Icon(Icons.open_in_new_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: scheme.onPrimary.withValues(alpha: 0.07),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: scheme.onPrimary.withValues(alpha: 0.72),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    "Inscrit ${formatTimeDate(participation.joinedDateTime.toLocal())}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onPrimary.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          stepJourneyCardsWidget,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onOpenUserProfile(BuildContext context) {
    final router = context.router;
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushPath("/profile/${participation.user.id}");
    });
  }
}
