/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

import '../../types/participation/event_participation.dart';
import '../../types/participation/event_role.dart';

enum EventParticipationAction { promote, demote, remove }

class EventParticipationActionsMenu extends StatelessWidget {
  final EventParticipation participation;
  final void Function() onPromote;
  final void Function() onDemote;
  final void Function() onRemove;
  final bool canEdit;

  const EventParticipationActionsMenu({
    super.key,
    required this.participation,
    required this.onPromote,
    required this.onDemote,
    required this.onRemove,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (!canEdit) {
      return const SizedBox();
    }

    final scheme = Theme.of(context).colorScheme;

    return PopupMenuButton<EventParticipationAction>(
      tooltip: 'Actions participant',
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.onPrimary.withValues(alpha: 0.08),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 18,
          color: scheme.onPrimary.withValues(alpha: 0.72),
        ),
      ),
      itemBuilder: (BuildContext context) {
        return _buildActions(context);
      },
      onSelected: _onSelected,
    );
  }

  void _onSelected(EventParticipationAction value) {
    switch (value) {
      case EventParticipationAction.promote:
        onPromote();
        break;
      case EventParticipationAction.demote:
        onDemote();
        break;
      case EventParticipationAction.remove:
        onRemove();
        break;
    }
  }

  List<PopupMenuItem<EventParticipationAction>> _buildActions(
    BuildContext context,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final actions = <PopupMenuItem<EventParticipationAction>>[];

    if (participation.role == EventRole.organizer) {
      actions.add(
        PopupMenuItem(
          value: EventParticipationAction.demote,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward_rounded,
                size: 18,
                color: scheme.onPrimary,
              ),
              const SizedBox(width: 10),
              const Text("Rétrograder membre"),
            ],
          ),
        ),
      );
    } else if (participation.role == EventRole.member) {
      actions.add(
        PopupMenuItem(
          value: EventParticipationAction.promote,
          child: Row(
            children: [
              Icon(
                Icons.arrow_upward_rounded,
                size: 18,
                color: scheme.secondary,
              ),
              const SizedBox(width: 10),
              const Text("Promouvoir organisateur"),
            ],
          ),
        ),
      );
    }

    actions.add(
      PopupMenuItem(
        value: EventParticipationAction.remove,
        child: Row(
          children: [
            Icon(
              Icons.person_remove_alt_1_rounded,
              size: 18,
              color: scheme.error,
            ),
            const SizedBox(width: 10),
            Text(
              "Retirer de l'événement",
              style: TextStyle(color: scheme.error),
            ),
          ],
        ),
      ),
    );

    return actions;
  }
}
