/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/details/event_upload_image_modal.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_event.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';

import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';

enum EventDetailsAction { leave, delete, cancel, finish, uploadImage }

class EventDetailsActionsMenu extends StatelessWidget {
  final int eventId;
  final EventStatusState status;
  final bool isOwner;
  final bool isJoined;
  final bool isOrganizer;
  final bool hasImage;

  const EventDetailsActionsMenu({
    super.key,
    required this.eventId,
    required this.status,
    required this.isOwner,
    required this.isJoined,
    required this.isOrganizer,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _buildActions(context);

    if (actions.isEmpty) return const SizedBox();

    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
      itemBuilder: (context) {
        return actions;
      },
      onSelected: (value) => _onSelected(context, value),
    );
  }

  List<PopupMenuItem> _buildActions(BuildContext context) {
    final actions = <PopupMenuItem>[];

    if (isJoined && !isOwner) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.leave,
          child: Row(
            children: [
              Icon(Icons.exit_to_app),
              SizedBox(width: 10),
              Text("Quitter l'événement"),
            ],
          ),
        ),
      );
    }

    if (isOrganizer) {
      actions.add(
        PopupMenuItem(
          value: EventDetailsAction.uploadImage,
          child: Row(
            children: [
              const Icon(Icons.image),
              const SizedBox(width: 10),
              Text(hasImage ? "Modifier l'image" : "Ajouter une image"),
            ],
          ),
        ),
      );
    }

    if (isOrganizer && status == EventStatusState.scheduled) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.cancel,
          child: Row(
            children: [
              Icon(Icons.cancel),
              SizedBox(width: 10),
              Text("Annuler l'événement"),
            ],
          ),
        ),
      );
    }

    if (isOrganizer && status == EventStatusState.now) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.finish,
          child: Row(
            children: [
              Icon(Icons.flag),
              SizedBox(width: 10),
              Text("Terminer l'événement"),
            ],
          ),
        ),
      );
    }

    if (isOwner && status != EventStatusState.now) {
      actions.add(
        const PopupMenuItem(
          value: EventDetailsAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 10),
              Text("Supprimer l'événement"),
            ],
          ),
        ),
      );
    }

    return actions;
  }

  void _onSelected(BuildContext context, EventDetailsAction value) {
    switch (value) {
      case EventDetailsAction.leave:
        _onLeave(context);
        break;
      case EventDetailsAction.delete:
        _onDelete(context);
        break;
      case EventDetailsAction.cancel:
        _onCancel(context);
        break;
      case EventDetailsAction.finish:
        _onFinish(context);
        break;
      case EventDetailsAction.uploadImage:
        _onUploadImage(context);
    }
  }

  void _onFinish(BuildContext context) async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: "Terminer l'événement",
      message: "Êtes-vous sûr de vouloir terminer cet événement ?",
      cancelLabel: "Annuler",
      confirmLabel: "Terminer",
    );

    if (confirmed == true && context.mounted) {
      context.read<EventDetailsBloc>().add(FinishEvent());
    }
  }

  void _onCancel(BuildContext context) async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: "Annuler l'événement",
      message: "Êtes-vous sûr de vouloir annuler cet événement ?",
      cancelLabel: "Revenir en arrière",
      confirmLabel: "Confirmer",
      destructiveConfirm: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<EventDetailsBloc>().add(CancelEvent());
    }
  }

  void _onDelete(BuildContext context) async {
    if (status == EventStatusState.now) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible de supprimer un événement en cours."),
        ),
      );
      return;
    }

    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: "Supprimer l'événement",
      message: "Êtes-vous sûr de vouloir supprimer cet événement ?",
      cancelLabel: "Annuler",
      confirmLabel: "Supprimer",
      destructiveConfirm: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<EventDetailsBloc>().add(DeleteEvent());
    }
  }

  void _onLeave(BuildContext context) {
    context.read<EventDetailsBloc>().add(LeaveEvent());

    context.read<MyPositionBloc>().add(DisableSendPositions());
  }

  void _onUploadImage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<EventDetailsBloc>(),
          child: const EventUploadImageModal(),
        );
      },
    );
  }
}
