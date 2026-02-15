/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ImagePickerModalHeader extends StatelessWidget {
  final void Function() onClose;
  final void Function() onSubmit;
  final bool canSubmit;
  final int selectedCount;

  const ImagePickerModalHeader({
    super.key,
    required this.onClose,
    required this.onSubmit,
    required this.canSubmit,
    this.selectedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final buttonLabel =
        selectedCount > 1 ? "Ajouter ($selectedCount)" : "Ajouter";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ElevatedButton(
          onPressed: canSubmit ? onSubmit : null,
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
