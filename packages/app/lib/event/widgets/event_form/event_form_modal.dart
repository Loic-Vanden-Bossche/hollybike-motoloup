/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/widgets/event_form/event_form.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import 'event_discard_changes_dialog.dart';

class EventFormModal extends StatefulWidget {
  final void Function(EventFormData) onSubmit;
  final String submitButtonText;
  final EventFormData? initialData;
  final bool canEditDates;
  final bool enforceNoPastDates;

  const EventFormModal({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
    this.initialData,
    this.canEditDates = true,
    this.enforceNoPastDates = false,
  });

  @override
  State<EventFormModal> createState() => _EventFormModalState();
}

class _EventFormModalState extends State<EventFormModal> {
  bool touched = false;
  bool _discardDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _handleClose();
        },
        child: GlassBottomModal(
          maxContentHeight: 440,
          child: EventForm(
            canEditDates: widget.canEditDates,
            enforceNoPastDates: widget.enforceNoPastDates,
            submitButtonText: widget.submitButtonText,
            initialData: widget.initialData,
            onClose: _handleClose,
            onTouched: () {
              setState(() {
                touched = true;
              });
            },
            onSubmit: widget.onSubmit,
          ),
        ),
      ),
    );
  }

  Future<void> _handleClose() async {
    if (!touched) {
      Navigator.of(context).pop();
      return;
    }

    if (_discardDialogOpen) return;
    _discardDialogOpen = true;
    try {
      await showEventDiscardChangesDialog(context, () {
        Navigator.of(context).pop();
      });
    } finally {
      _discardDialogOpen = false;
    }
  }
}
