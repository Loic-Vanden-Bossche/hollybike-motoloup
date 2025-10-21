/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_choice_list.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_modal_header.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_selected_images_list.dart';

class ImagePickerModal extends StatefulWidget {
  final ImagePickerMode mode;
  final bool isLoading;
  final void Function() onClose;
  final void Function(List<File>) onSubmit;

  const ImagePickerModal({
    super.key,
    required this.mode,
    this.isLoading = false,
    required this.onClose,
    required this.onSubmit,
  });

  @override
  State<ImagePickerModal> createState() => _ImagePickerModalState();
}

class _ImagePickerModalState extends State<ImagePickerModal> {
  final _selectedImages = <Img>[];

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: Theme.of(context).colorScheme.onPrimary,
      width: 3,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border(top: border, left: border, right: border),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImagePickerModalHeader(
                onClose: widget.onClose,
                onSubmit: _onSubmit,
                canSubmit: _selectedImages.isNotEmpty && !widget.isLoading,
              ),
              const SizedBox(height: 16),
              _buildSelectedImageList(),
              ImagePickerChoiceList(
                entityIdSelectedList: _getSelectedEntityIds(),
                mode: widget.mode,
                onImagesSelected: _onImagesSelected,
                isLoading: widget.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImageList() {
    if (widget.isLoading || _selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return ImagePickerSelectedImagesList(
      selectedImages: _selectedImages,
      onDeleteIndex: _onImageIndexDeleted,
    );
  }

  List<String> _getSelectedEntityIds() {
    return _selectedImages
        .map((img) => img.entityId)
        .where((element) => element != null)
        .toList()
        .cast<String>();
  }

  void _onSubmit() async {
    final files = _selectedImages.map((img) => img.file).toList();
    widget.onSubmit(files);
  }

  void _onImageIndexDeleted(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _onImagesSelected(List<Img> images) {
    setState(() {
      if (widget.mode == ImagePickerMode.single) {
        _selectedImages.clear();
      }

      final entityIdsToDelete = _filterEntityIdsToDelete(images);

      _selectedImages.removeWhere(
        (img) => entityIdsToDelete.contains(img.entityId),
      );

      final filesToAdd =
          images
              .where(
                (img) => entityIdsToDelete.every(
                  (entityId) => img.entityId != entityId,
                ),
              )
              .toList();

      _selectedImages.addAll(filesToAdd);
    });
  }

  List<String> _filterEntityIdsToDelete(List<Img> images) {
    return images
        .map((img) => img.entityId)
        .where(
          (entityId) => _selectedImages.any(
            (img) => img.entityId != null && img.entityId == entityId,
          ),
        )
        .toList()
        .cast<String>();
  }
}
