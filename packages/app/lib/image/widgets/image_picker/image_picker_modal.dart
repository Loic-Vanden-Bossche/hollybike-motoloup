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
          top: 8,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(context),
              const SizedBox(height: 8),
              ImagePickerModalHeader(
                onClose: widget.onClose,
                onSubmit: _onSubmit,
                canSubmit: _selectedImages.isNotEmpty && !widget.isLoading,
                selectedCount: _selectedImages.length,
              ),
              const SizedBox(height: 16),
              if (widget.isLoading) _buildLoadingState(context),
              if (!widget.isLoading) ...[
                _buildSelectedImageList(),
                if (_selectedImages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Choisissez vos photos",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ImagePickerChoiceList(
                  mode: widget.mode,
                  onImagesSelected: _onImagesSelected,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedImages.isNotEmpty) ...[
          IgnorePointer(
            child: Opacity(
              opacity: 0.5,
              child: ImagePickerSelectedImagesList(
                selectedImages: _selectedImages,
                onDeleteIndex: (_) {},
              ),
            ),
          ),
        ],
        SizedBox(
          height: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedImages.length > 1
                      ? "Envoi de ${_selectedImages.length} photos..."
                      : "Envoi en cours...",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedImageList() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _selectedImages.isEmpty
          ? const SizedBox.shrink()
          : ImagePickerSelectedImagesList(
              selectedImages: _selectedImages,
              onDeleteIndex: _onImageIndexDeleted,
            ),
    );
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

      _selectedImages.addAll(images);
    });
  }
}
