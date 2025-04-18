/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class Img {
  final Image image;
  final File file;
  final String? entityId;

  Img({
    required this.image,
    required this.file,
    this.entityId,
  });

  static Img fromFile(File file) {
    final image = Image(
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      image: FileImage(file),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );

    return Img(
      image: image,
      file: file,
    );
  }

  static fromAssetEntity(AssetEntity assetEntity) async {
    final file = await assetEntity.file;
    if (file == null) {
      throw Exception('File not found');
    }

    final fileImage = Img.fromFile(file);

    return Img(image: fileImage.image, file: file, entityId: assetEntity.id);
  }
}
