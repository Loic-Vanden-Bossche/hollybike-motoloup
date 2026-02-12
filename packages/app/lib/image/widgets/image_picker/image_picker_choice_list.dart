/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_gallery_button.dart';

import 'image_picker_camera_button.dart';

class ImagePickerChoiceList extends StatefulWidget {
  final List<String> entityIdSelectedList;
  final ImagePickerMode mode;
  final void Function(List<Img>) onImagesSelected;
  final bool isLoading;

  const ImagePickerChoiceList({
    super.key,
    required this.entityIdSelectedList,
    required this.mode,
    required this.onImagesSelected,
    required this.isLoading,
  });

  @override
  State<ImagePickerChoiceList> createState() => _ImagePickerChoiceListState();
}

class _ImagePickerChoiceListState extends State<ImagePickerChoiceList> {
  bool get isLoading => widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final list = [
      ImagePickerCameraButton(
        onImageSelected: (image) => widget.onImagesSelected([image]),
      ),
      ImagePickerGalleryButton(
        mode: widget.mode,
        onImagesSelected: widget.onImagesSelected,
      ),
    ];

    const height = 100.0;

    return AnimatedCrossFade(
      crossFadeState:
          isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      firstChild: SizedBox(
        height: height,
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      secondChild: SizedBox(
        height: height,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 8);
          },
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return AspectRatio(aspectRatio: 1, child: list[index]);
          },
        ),
      ),
    );
  }
}
