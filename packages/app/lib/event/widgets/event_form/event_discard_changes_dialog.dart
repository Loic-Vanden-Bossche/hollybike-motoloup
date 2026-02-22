/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';

Future<void> showEventDiscardChangesDialog(
  BuildContext context,
  void Function() onConfirm,
) {
  return showGlassConfirmationDialog(
    context: context,
    title: 'Annuler la création ?',
    message: 'Toutes les informations saisies seront perdues.',
    cancelLabel: 'Annuler',
    confirmLabel: 'Confirmer',
  ).then((confirmed) {
    if (confirmed == true) onConfirm();
  });
}
