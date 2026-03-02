/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ImagePickerModalHeader extends StatelessWidget {
  final void Function() onClose;

  const ImagePickerModalHeader({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(icon: const Icon(Icons.close), onPressed: onClose),
    );
  }
}
