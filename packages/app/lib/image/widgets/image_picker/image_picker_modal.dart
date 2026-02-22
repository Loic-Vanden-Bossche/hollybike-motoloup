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
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      showGrabber: false,
      contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImagePickerModalHeader(
            onClose: widget.onClose,
            onSubmit: _onSubmit,
            canSubmit: _selectedImages.isNotEmpty && !widget.isLoading,
            selectedCount: _selectedImages.length,
          ),
          const SizedBox(height: 14),

          if (widget.isLoading) _buildLoadingState(scheme),
          if (!widget.isLoading) ...[
            _buildSelectedImageList(),
            if (_selectedImages.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Choisissez vos photos',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.50),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(450)],
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
    );
  }

  Widget _buildLoadingState(ColorScheme scheme) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            minHeight: 3,
            backgroundColor: scheme.onPrimary.withValues(alpha: 0.10),
            valueColor: AlwaysStoppedAnimation<Color>(
              scheme.secondary,
            ),
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
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedImages.length > 1
                      ? 'Envoi de ${_selectedImages.length} photos...'
                      : 'Envoi en cours...',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.60),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(500)],
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
