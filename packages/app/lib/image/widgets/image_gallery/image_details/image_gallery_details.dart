/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/image/type/event_image_details.dart';
import 'package:hollybike/image/widgets/image_gallery/image_details/image_gallery_details_owner.dart';

import 'image_gallery_details_event.dart';
import 'image_gallery_details_position.dart';
import 'image_gallery_details_time.dart';

class ImageGalleryDetails extends StatelessWidget {
  final EventImageDetails imageDetails;

  const ImageGalleryDetails({super.key, required this.imageDetails});

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      ImageGalleryDetailsOwner(owner: imageDetails.owner),
      ImageGalleryDetailsTime(
        uploadedAt: imageDetails.uploadDateTime,
        takenAt: imageDetails.takenDateTime,
      ),
      ImageGalleryDetailsEvent(event: imageDetails.event),
      ImageGalleryDetailsPosition(position: imageDetails.position),
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            _animationWrapper(sections[i], i),
            if (i != sections.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _animationWrapper(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      duration: Duration(milliseconds: 250 + (index * 80)),
      builder: (BuildContext context, double value, _) {
        return Transform.translate(
          offset: Offset(12 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
    );
  }
}
