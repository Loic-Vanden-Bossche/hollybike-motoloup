/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';

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

    return GlassPopupMenuButton<EventParticipationAction>(
      tooltip: 'Actions participant',
      icon: const GlassPopupMenuTriggerIcon(
        iconSize: 18,
        padding: EdgeInsets.all(6),
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
        glassPopupMenuItem(
          value: EventParticipationAction.demote,
          icon: Icons.arrow_downward_rounded,
          label: "Rétrograder membre",
        ),
      );
    } else if (participation.role == EventRole.member) {
      actions.add(
        glassPopupMenuItem(
          value: EventParticipationAction.promote,
          icon: Icons.arrow_upward_rounded,
          label: "Promouvoir organisateur",
          color: scheme.secondary,
        ),
      );
    }

    actions.add(
      glassPopupMenuItem(
        value: EventParticipationAction.remove,
        icon: Icons.person_remove_alt_1_rounded,
        label: "Retirer de l'événement",
        color: scheme.error,
      ),
    );

    return actions;
  }
}
