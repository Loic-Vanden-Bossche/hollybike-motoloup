/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_gallery_button.dart';

import 'image_picker_camera_button.dart';

class ImagePickerChoiceList extends StatelessWidget {
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;

  const ImagePickerChoiceList({
    super.key,
    required this.mode,
    required this.onImagesSelected,
  });

  @override
  Widget build(BuildContext context) {
    const height = 100.0;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: ImagePickerCameraButton(
              onImageSelected: (image) => onImagesSelected([image]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ImagePickerGalleryButton(
              mode: mode,
              onImagesSelected: onImagesSelected,
            ),
          ),
        ],
      ),
    );
  }
}
