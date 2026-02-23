/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/ui/widgets/buttons/glass_fab.dart';

import '../../types/event.dart';
import '../../types/event_form_data.dart';
import '../event_form/event_form_modal.dart';

class EventEditFloatingButton extends StatelessWidget {
  final bool canEdit;
  final Event event;
  final void Function(EventFormData formData) onEdit;

  const EventEditFloatingButton({
    super.key,
    required this.onEdit,
    required this.canEdit,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    if (!canEdit) return const SizedBox();

    return GlassFab(
      icon: Icons.edit_rounded,
      label: 'Modifier',
      onPressed: () => _onOpenEditModal(context),
    );
  }

  void _onOpenEditModal(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      showModalBottomSheet<void>(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EventFormModal(
            canEditDates: event.status != EventStatusState.now,
            enforceNoPastDates:
                event.status == EventStatusState.finished ||
                event.status == EventStatusState.canceled,
            initialData: EventFormData(
              name: event.name,
              description: event.description,
              startDate: event.startDate,
              endDate: event.endDate,
            ),
            onSubmit: onEdit,
            submitButtonText: 'Sauvegarder',
          );
        },
      );
    });
  }
}
