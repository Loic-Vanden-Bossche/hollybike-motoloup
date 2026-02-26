/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/loading_placeholders/text_loading_placeholder.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

class PlaceholderSearchProfileCard extends StatelessWidget {
  const PlaceholderSearchProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 90,
      height: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primaryContainer.withValues(alpha: 0.60),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingProfilePicture(size: 52),
                  SizedBox(height: 8),
                  TextLoadingPlaceholder(minLetters: 4, maxLetters: 8),
                  SizedBox(height: 4),
                  TextLoadingPlaceholder(minLetters: 3, maxLetters: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
