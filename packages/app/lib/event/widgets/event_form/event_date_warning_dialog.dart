/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import 'package:lottie/lottie.dart';

Future<void> showEventDateWarningDialog(BuildContext context, String message) {
  return showGlassConfirmationDialog(
    context: context,
    title: 'Dates/horaires invalides',
    showCancel: false,
    confirmLabel: 'Ok',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          height: 150,
          fit: BoxFit.cover,
          'assets/lottie/lottie_calendar_error_animation.json',
          repeat: false,
        ),
        Text(message),
      ],
    ),
  );
}
