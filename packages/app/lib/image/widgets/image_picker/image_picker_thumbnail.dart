/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'image_picker_thumbnail_container.dart';

class ImagePickerThumbnail extends StatelessWidget {
  final AssetEntity assetEntity;
  final bool isSelected;
  final void Function(Img) onImageSelected;

  const ImagePickerThumbnail({
    super.key,
    required this.assetEntity,
    required this.isSelected,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePickerThumbnailContainer(
      isSelected: isSelected,
      child: Image(
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        image: AssetEntityImageProvider(
          assetEntity,
          isOriginal: false,
          thumbnailSize: ThumbnailSize(200, 200),
        ),
      ),
      onTap:
          () async => onImageSelected(await Img.fromAssetEntity(assetEntity)),
    );
  }
}
