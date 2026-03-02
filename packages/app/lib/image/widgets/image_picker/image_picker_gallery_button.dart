/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'image_picker_button_container.dart';

class ImagePickerGalleryButton extends StatelessWidget {
  static const _mediaPickerChannel = MethodChannel('com.hollybike/media_picker');
  final ImagePicker imagePicker = ImagePicker();
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;

  ImagePickerGalleryButton({
    super.key,
    required this.mode,
    required this.onImagesSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePickerButtonContainer(
      onTap: _onGalleryTap,
      icon: const Icon(Icons.photo),
      label: "Galerie",
    );
  }

  Future<void> _onGalleryTap() async {
    final imgs =
        Platform.isAndroid
            ? await _pickImagesWithNativePicker()
            : await _pickImagesWithImagePicker();

    onImagesSelected(imgs);
  }

  Future<List<Img>> _pickImagesWithNativePicker() async {
    await Permission.accessMediaLocation.request();

    final rawResults = await _mediaPickerChannel.invokeListMethod<dynamic>(
      'pickGalleryImages',
      {'multiple': mode != ImagePickerMode.single},
    );

    if (rawResults == null) {
      return const [];
    }

    return rawResults
        .whereType<dynamic>()
        .map((item) => Map<String, dynamic>.from(item as Map))
        .map((item) {
          return Img.fromFile(
            File(item['path'] as String),
          );
        })
        .toList();
  }

  Future<List<Img>> _pickImagesWithImagePicker() async {
    final images = await _pickImages();
    return images.map((image) => Img.fromFile(File(image.path))).toList();
  }

  Future<List<XFile>> _pickImages() async {
    if (mode == ImagePickerMode.single) {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      return image == null ? [] : [image];
    } else {
      return imagePicker.pickMultiImage();
    }
  }
}
