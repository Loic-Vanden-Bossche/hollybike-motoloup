/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_event.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

enum TimelineStepAction { rename, setCurrent, remove }

class TimelineDialogButton extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;

  const TimelineDialogButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: primary
              ? scheme.secondary.withValues(alpha: 0.15)
              : scheme.primaryContainer.withValues(alpha: 0.45),
          border: Border.all(
            color: primary
                ? scheme.secondary.withValues(alpha: 0.42)
                : scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: primary
                ? scheme.secondary
                : scheme.onPrimary.withValues(alpha: 0.72),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(650)],
          ),
        ),
      ),
    );
  }
}

class TimelineStepActionsMenu extends StatelessWidget {
  final EventJourneyStep step;
  final EventDetails eventDetails;
  final bool forceWithoutSetCurrent;

  const TimelineStepActionsMenu({
    super.key,
    required this.step,
    required this.eventDetails,
    this.forceWithoutSetCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassPopupMenuButton<TimelineStepAction>(
      padding: EdgeInsets.zero,
      onSelected: (action) => _onAction(context, action),
      itemBuilder: (_) => [
        glassPopupMenuItem(
          value: TimelineStepAction.rename,
          label: 'Renommer',
          icon: Icons.edit_rounded,
        ),
        if (!step.isCurrent && !forceWithoutSetCurrent)
          glassPopupMenuItem(
            value: TimelineStepAction.setCurrent,
            label: 'Définir comme actuelle',
            icon: Icons.flag_rounded,
          ),
        glassPopupMenuItem(
          value: TimelineStepAction.remove,
          label: 'Retirer',
          icon: Icons.delete_rounded,
          color: scheme.error,
        ),
      ],
    );
  }

  Future<void> _onAction(BuildContext context, TimelineStepAction action) async {
    switch (action) {
      case TimelineStepAction.rename:
        final controller = TextEditingController(
            text: step.name ?? 'Étape ${step.position}');
        final name = await showDialog<String?>(
          context: context,
          builder: (d) => GlassDialog(
            title: 'Nom de l\'étape',
            onClose: () => Navigator.of(d).pop(null),
            body: TextField(
              controller: controller,
              decoration: buildGlassInputDecoration(d, labelText: 'Nom'),
              textInputAction: TextInputAction.done,
              onSubmitted: (v) => Navigator.of(d).pop(v.trim()),
              autofocus: true,
            ),
            actions: [
              TimelineDialogButton(
                label: 'Annuler',
                onTap: () => Navigator.of(d).pop(null),
              ),
              TimelineDialogButton(
                label: 'Valider',
                primary: true,
                onTap: () => Navigator.of(d).pop(controller.text.trim()),
              ),
            ],
          ),
        );
        // Dispose after the dismiss animation so the TextField
        // doesn't access a dead controller while animating out.
        WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
        if (name == null || name.isEmpty || !context.mounted) return;
        context.read<EventJourneyBloc>().add(
              RenameJourneyStepInEvent(
                eventId: eventDetails.event.id,
                stepId: step.id,
                name: name,
              ),
            );
        return;
      case TimelineStepAction.setCurrent:
        context.read<EventJourneyBloc>().add(
              SetCurrentJourneyStep(
                eventId: eventDetails.event.id,
                stepId: step.id,
              ),
            );
        return;
      case TimelineStepAction.remove:
        final confirmed = await showGlassConfirmationDialog(
          context: context,
          title: 'Retirer l\'étape',
          message: 'Retirer cette étape de l\'itinéraire ?',
          confirmLabel: 'Retirer',
          destructiveConfirm: true,
        );
        if (confirmed != true || !context.mounted) return;
        context.read<EventJourneyBloc>().add(
              RemoveJourneyStepFromEvent(
                eventId: eventDetails.event.id,
                stepId: step.id,
              ),
            );
        return;
    }
  }
}
