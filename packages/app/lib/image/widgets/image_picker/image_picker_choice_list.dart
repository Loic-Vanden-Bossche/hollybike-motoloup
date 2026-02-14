/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hollybike/image/type/image_picker_mode.dart';
import 'package:hollybike/image/utils/image_picker/img.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_gallery_button.dart';
import 'package:hollybike/image/widgets/image_picker/image_picker_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

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
  final assetEntitiesList = <AssetEntity>[];
  bool _loadingImages = true;
  final imagePicker = ImagePicker();

  bool get isLoading => _loadingImages || widget.isLoading;

  @override
  void initState() {
    super.initState();

    _checkImagesPermission()
        .then((granted) {
      if (granted) {
        return _loadImages();
      }
    })
        .whenComplete(() {
      setState(() {
        _loadingImages = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      ImagePickerCameraButton(
        onImageSelected: (image) => widget.onImagesSelected([image]),
      ),
      ...assetEntitiesList.map((entity) {
        return ImagePickerThumbnail(
          assetEntity: entity,
          isSelected: widget.entityIdSelectedList.contains(entity.id),
          onImageSelected: (image) => widget.onImagesSelected([image]),
        );
      }),
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

  void _loadImages() async {
    final filterOption = FilterOptionGroup(
      orders: const [
        OrderOption(type: OrderOptionType.updateDate, asc: false),
        OrderOption(type: OrderOptionType.createDate, asc: false),
      ],
    );

    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
      filterOption: filterOption,
    );

    if (paths.isEmpty) {
      return;
    }

    final path = await paths.first.obtainForNewProperties();

    final List<AssetEntity> entities = await path.getAssetListPaged(
      page: 0,
      size: 10,
    );

    setState(() {
      assetEntitiesList.addAll(entities);
    });
  }

  Future<bool> _checkImagesPermission() async {
    final permission = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: true,
        ),
      ),
    );

    if (permission.hasAccess) {
      return true;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await PhotoManager.presentLimited(type: RequestType.image);
    } else {
      await PhotoManager.openSetting();
    }

    return false;
  }
}
