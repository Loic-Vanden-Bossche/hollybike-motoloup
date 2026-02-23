/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_role.dart';
import '../event_loading_profile_picture.dart';

class EventCandidateCard extends StatelessWidget {
  final EventCandidate candidate;
  final bool isSelected;
  final bool alreadyParticipating;
  final void Function() onTap;

  const EventCandidateCard({
    super.key,
    required this.candidate,
    required this.isSelected,
    required this.onTap,
    required this.alreadyParticipating,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDisabled = alreadyParticipating;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isDisabled ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color:
                isDisabled
                    ? scheme.onPrimary.withValues(alpha: 0.03)
                    : isSelected
                    ? scheme.secondary.withValues(alpha: 0.14)
                    : scheme.onPrimary.withValues(alpha: 0.05),
            border: Border.all(
              color:
                  isDisabled
                      ? scheme.onPrimary.withValues(alpha: 0.10)
                      : isSelected
                      ? scheme.secondary.withValues(alpha: 0.36)
                      : scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              UserProfilePicture(
                url: candidate.profilePicture,
                profilePictureKey: candidate.profilePictureKey,
                radius: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimary.withValues(
                          alpha: isDisabled ? 0.55 : 0.88,
                        ),
                      ),
                    ),
                    if (candidate.eventRole != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        "Déjà ${_eventRoleName(candidate.eventRole!)}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onPrimary.withValues(alpha: 0.56),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 3),
                      Text(
                        isSelected
                            ? "Sera ajouté à l'événement"
                            : "Appuyez pour sélectionner",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              isSelected
                                  ? scheme.secondary
                                  : scheme.onPrimary.withValues(alpha: 0.52),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IgnorePointer(
                child: Checkbox(
                  value: isSelected,
                  onChanged: isDisabled ? null : (_) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _eventRoleName(EventRole role) {
    switch (role) {
      case EventRole.organizer:
        return "Organisateur";
      case EventRole.member:
        return "Participant";
    }
  }
}
