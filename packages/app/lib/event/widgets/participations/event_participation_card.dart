/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/event/widgets/participations/event_participation_actions_menu.dart';
import 'package:hollybike/event/widgets/participations/event_participation_modal.dart';
import 'package:hollybike/shared/utils/dates.dart';

import '../../bloc/event_participations_bloc/event_participations_bloc.dart';
import '../../types/event_journey_step.dart';
import '../../types/participation/event_participation.dart';

class EventParticipationCard extends StatelessWidget {
  final int eventId;
  final EventParticipation participation;
  final bool isOwner;
  final bool isCurrentUser;
  final bool isCurrentUserOrganizer;
  final List<EventJourneyStep> journeySteps;
  final int? currentStepId;

  const EventParticipationCard({
    super.key,
    required this.participation,
    required this.isCurrentUser,
    required this.isCurrentUserOrganizer,
    required this.isOwner,
    required this.eventId,
    required this.journeySteps,
    required this.currentStepId,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _onOpenParticipationModal(context),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color:
                isCurrentUser
                    ? scheme.secondary.withValues(alpha: 0.12)
                    : scheme.onPrimary.withValues(alpha: 0.05),
            border: Border.all(
              color:
                  isCurrentUser
                      ? scheme.secondary.withValues(alpha: 0.34)
                      : scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Hero(
                tag: "user-${participation.user.id}-profile-picture",
                child: UserProfilePicture(
                  url: participation.user.profilePicture,
                  profilePictureKey: participation.user.profilePictureKey,
                  radius: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: "user-${participation.user.id}-username",
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                participation.user.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  color: scheme.onPrimary,
                                  fontVariations: const [
                                    FontVariation.weight(740),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildRoleBadge(context),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Inscrit ${formatPastTime(participation.joinedDateTime)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.62),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Vous participez à cet événement',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.secondary,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                    ],
                    if (journeySteps.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children:
                            journeySteps.map((step) {
                              final isCurrentStep =
                                  (currentStepId ?? 0) == step.id;
                              final label =
                                  step.name?.trim().isNotEmpty == true
                                      ? step.name!
                                      : 'Etape ${step.position}';
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color:
                                      isCurrentStep
                                          ? scheme.primary.withValues(
                                            alpha: 0.18,
                                          )
                                          : scheme.onPrimary.withValues(
                                            alpha: 0.08,
                                          ),
                                  border: Border.all(
                                    color:
                                        isCurrentStep
                                            ? scheme.primary.withValues(
                                              alpha: 0.35,
                                            )
                                            : scheme.onPrimary.withValues(
                                              alpha: 0.12,
                                            ),
                                  ),
                                ),
                                child: Text(
                                  isCurrentStep ? '$label - actuelle' : label,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color:
                                        isCurrentStep
                                            ? scheme.primary
                                            : scheme.onPrimary.withValues(
                                              alpha: 0.86,
                                            ),
                                    fontVariations: const [
                                      FontVariation.weight(650),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              EventParticipationActionsMenu(
                participation: participation,
                canEdit: isCurrentUserOrganizer && (!isOwner && !isCurrentUser),
                onPromote: () => _onPromote(context),
                onDemote: () => _onDemote(context),
                onRemove: () => _onRemove(context),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right_rounded,
                size: 19,
                color: scheme.onPrimary.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOrganizerRole = participation.roleName == 'Organisateur';
    final color = isOrganizerRole ? scheme.secondary : scheme.onPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: isOrganizerRole ? 0.18 : 0.1),
        border: Border.all(
          color: color.withValues(alpha: isOrganizerRole ? 0.36 : 0.2),
          width: 1,
        ),
      ),
      child: Text(
        participation.roleName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color.withValues(alpha: 0.95),
          fontVariations: const [FontVariation.weight(700)],
        ),
      ),
    );
  }

  void _onPromote(BuildContext context) {
    context.read<EventParticipationBloc>().add(
      PromoteEventParticipant(userId: participation.user.id),
    );
  }

  void _onDemote(BuildContext context) {
    context.read<EventParticipationBloc>().add(
      DemoteEventParticipant(userId: participation.user.id),
    );
  }

  void _onRemove(BuildContext context) {
    context.read<EventParticipationBloc>().add(
      RemoveEventParticipant(userId: participation.user.id),
    );
  }

  void _onOpenParticipationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<EventDetailsBloc>(),
          child: EventParticipationModal(participation: participation),
        );
      },
    );
  }
}
