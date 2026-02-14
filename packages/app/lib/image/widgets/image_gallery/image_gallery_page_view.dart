/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/image/type/event_image.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery_bottom_modal.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';
import 'package:hollybike/shared/widgets/modal/content_shrink_bottom_modal.dart';
import 'package:photo_view/photo_view.dart';

import '../../../event/bloc/event_images_bloc/event_image_details_bloc.dart';
import '../../../event/bloc/event_images_bloc/event_image_details_state.dart';

class ImageGalleryPageView extends StatefulWidget {
  final int imageIndex;
  final List<EventImage> images;
  final void Function() onLoadNextPage;
  final void Function() onImageDeleted;

  const ImageGalleryPageView({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.images,
    required this.onImageDeleted,
  });

  @override
  State<ImageGalleryPageView> createState() => _ImageGalleryPageViewState();
}

class _ImageGalleryPageViewState extends State<ImageGalleryPageView> {
  static const double _closeDragThreshold = 120;
  static const double _maxDragOffsetX = 220;
  static const double _maxDragOffsetY = 320;
  static const double _maxDragDistance = 380;
  static const double _dragActivationThreshold = 16;

  late final controller = PageController(initialPage: widget.imageIndex);

  late int currentPage = widget.imageIndex;

  bool isZoomed = false;
  bool modalOpened = false;
  Offset _dragOffset = Offset.zero;
  bool _isDraggingToClose = false;
  bool _blockModalDrag = false;
  int? _activePointer;
  Offset? _dragStartPosition;

  EventImage? get currentImage {
    try {
      return widget.images[currentPage];
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = this.currentImage;

    if (currentImage == null) {
      return Container(color: Colors.black);
    }

    return BlocListener<EventImageDetailsBloc, EventImageDetailsState>(
      listener: (context, state) {
        if (state is DeleteImageSuccess) {
          _onImageDeleted();
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Color.fromRGBO(0, 0, 0, _currentOverlayOpacity)),
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: ContentShrinkBottomModal(
              modalOpened: modalOpened,
              backgroundColor: Colors.transparent,
              appBarOpacity: _currentControlsOpacity,
              onStatusChanged: (opened) {
                safeSetState(() {
                  modalOpened = opened;
                });
              },
              maxModalHeight: 460,
              enableDrag: !isZoomed && !_blockModalDrag,
              modalContent: ImageGalleryBottomModal(
                image: widget.images[currentPage],
                onImageDeleted: () {
                  setState(() {
                    modalOpened = false;
                  });
                },
              ),
              child: PageView.builder(
                dragStartBehavior: DragStartBehavior.down,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });

                  if (index == widget.images.length - 1) {
                    widget.onLoadNextPage();
                  }
                },
                controller: controller,
                physics:
                    isZoomed || modalOpened || _isDraggingToClose
                        ? const NeverScrollableScrollPhysics()
                        : const AlwaysScrollableScrollPhysics(),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final image = widget.images[index];

                  final hero =
                      index == currentPage
                          ? PhotoViewHeroAttributes(
                            tag: 'event_image_${image.id}',
                          )
                          : null;

                  return AnimatedContainer(
                    duration: Duration(
                      milliseconds: _isDraggingToClose ? 0 : 180,
                    ),
                    curve: Curves.easeOut,
                    transform:
                        Matrix4.identity()
                          ..translateByDouble(
                            index == currentPage ? _dragOffset.dx : 0.0,
                            index == currentPage ? _dragOffset.dy : 0.0,
                            0.0,
                            1.0,
                          )
                          ..scaleByDouble(
                            index == currentPage ? _currentDragScale : 1.0,
                            index == currentPage ? _currentDragScale : 1.0,
                            1.0,
                            1.0,
                          ),
                    transformAlignment: Alignment.center,
                    child: PhotoView(
                      initialScale: PhotoViewComputedScale.contained,
                      disableGestures: modalOpened,
                      imageProvider: CachedNetworkImageProvider(
                        image.url,
                        cacheKey: image.key,
                      ),
                      gestureDetectorBehavior: HitTestBehavior.translucent,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      scaleStateChangedCallback: (scaleState) {
                        setState(() {
                          isZoomed = scaleState != PhotoViewScaleState.initial;
                        });
                      },
                      loadingBuilder: (context, event) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Une erreur est survenue lors du chargement de l\'image',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      minScale: PhotoViewComputedScale.contained,
                      heroAttributes: hero,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _currentDragProgress =>
      (_dragOffset.distance / _maxDragDistance).clamp(0, 1);

  double get _currentDragScale =>
      lerpDouble(1, 0.78, _currentDragProgress) ?? 1;

  double get _currentOverlayOpacity =>
      lerpDouble(1, 0.15, _currentDragProgress) ?? 1;

  double get _currentControlsOpacity {
    final fadeProgress = ((_currentDragProgress / 0.3).clamp(0, 1)).toDouble();
    return 1 - fadeProgress;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointer != null || isZoomed || modalOpened) {
      return;
    }

    _activePointer = event.pointer;
    _dragStartPosition = event.position;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_activePointer != event.pointer ||
        _dragStartPosition == null ||
        isZoomed ||
        modalOpened) {
      return;
    }

    final delta = event.position - _dragStartPosition!;
    final downDistance = delta.dy;

    if (!_isDraggingToClose) {
      final isVerticalIntent =
          downDistance > _dragActivationThreshold &&
          downDistance.abs() > delta.dx.abs();

      if (!isVerticalIntent) {
        return;
      }
    }

    setState(() {
      _blockModalDrag = true;
      _isDraggingToClose = true;
      _dragOffset = Offset(
        delta.dx.clamp(-_maxDragOffsetX, _maxDragOffsetX).toDouble(),
        downDistance.clamp(0, _maxDragOffsetY).toDouble(),
      );
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_activePointer != event.pointer) {
      return;
    }

    if (!_isDraggingToClose) {
      setState(() {
        _activePointer = null;
        _dragStartPosition = null;
        _blockModalDrag = false;
      });
      return;
    }

    if (_dragOffset.dy > _closeDragThreshold) {
      setState(() {
        _activePointer = null;
        _dragStartPosition = null;
        _blockModalDrag = false;
      });
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _activePointer = null;
      _dragStartPosition = null;
      _blockModalDrag = false;
      _isDraggingToClose = false;
      _dragOffset = Offset.zero;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (_activePointer != event.pointer) {
      return;
    }

    if (!_isDraggingToClose) {
      setState(() {
        _activePointer = null;
        _dragStartPosition = null;
        _blockModalDrag = false;
      });
      return;
    }

    setState(() {
      _activePointer = null;
      _dragStartPosition = null;
      _blockModalDrag = false;
      _isDraggingToClose = false;
      _dragOffset = Offset.zero;
    });
  }

  void _onImageDeleted() {
    if (currentPage < widget.images.length - 1) {
      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }

    widget.onImageDeleted();
  }
}
