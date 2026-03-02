/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ImagePickerSelectedImage extends StatefulWidget {
  final Widget child;

  const ImagePickerSelectedImage({
    super.key,
    required this.child,
  });

  @override
  State<ImagePickerSelectedImage> createState() =>
      _ImagePickerSelectedImageState();
}

class _ImagePickerSelectedImageState extends State<ImagePickerSelectedImage> {
  bool initial = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        initial = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      curve: Curves.easeInOut,
      scale: initial ? 1 : 0.88,
      duration: const Duration(milliseconds: 100),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: widget.child,
        ),
      ),
    );
  }
}
