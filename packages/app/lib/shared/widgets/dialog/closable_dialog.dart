/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

class ClosableDialog extends StatelessWidget {
  final String title;
  final Widget? body;
  final void Function() onClose;

  const ClosableDialog({
    super.key,
    required this.title,
    required this.onClose,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return GlassDialog(
      title: title,
      onClose: onClose,
      body: body ?? const SizedBox.shrink(),
    );
  }
}
