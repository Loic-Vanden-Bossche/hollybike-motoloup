/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../../../event/widgets/event_loading_profile_picture.dart';

class ImageGalleryDetailsOwner extends StatelessWidget {
  final MinimalUser owner;

  const ImageGalleryDetailsOwner({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onPrimary.withValues(alpha: 0.06),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            UserProfilePicture(
              url: owner.profilePicture,
              profilePictureKey: owner.profilePictureKey,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                owner.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.88),
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: scheme.secondary.withValues(alpha: 0.16),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.32),
                  width: 1,
                ),
              ),
              child: Text(
                'Auteur',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.secondary,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
