/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_pictures/loading_profile_picture.dart';

class PlaceholderProfileBanner extends StatelessWidget {
  final int? loadingProfileId;

  const PlaceholderProfileBanner({super.key, this.loadingProfileId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.70),
                    scheme.primary.withValues(alpha: 0.52),
                  ],
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 22),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: scheme.onPrimary.withValues(alpha: 0.10),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nav row placeholders
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _shimmerCircle(scheme, 36),
                      _shimmerCircle(scheme, 36),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Avatar placeholder
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: scheme.secondary.withValues(alpha: 0.30),
                        width: 2,
                      ),
                    ),
                    child: LoadingProfilePicture(
                      size: 80,
                      loadingProfileId: loadingProfileId,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Username placeholder
                  _shimmerPill(scheme, width: 130, height: 20, radius: 10),
                  const SizedBox(height: 8),

                  // Role chip placeholder
                  _shimmerPill(scheme, width: 170, height: 26, radius: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCircle(ColorScheme scheme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primaryContainer.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _shimmerPill(
    ColorScheme scheme, {
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
