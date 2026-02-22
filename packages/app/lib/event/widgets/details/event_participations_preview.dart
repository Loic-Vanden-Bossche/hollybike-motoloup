/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';

import '../../types/participation/event_participation.dart';

class EventParticipationsPreview extends StatelessWidget {
  final Event event;
  final List<EventParticipation> previewParticipants;
  final int previewParticipantsCount;
  final void Function() onTap;

  final _avatarSize = 36.0;
  final _borderSize = 3.0;

  const EventParticipationsPreview({
    super.key,
    required this.event,
    required this.previewParticipants,
    required this.previewParticipantsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.56),
                    scheme.primary.withValues(alpha: 0.42),
                  ],
                ),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatarStack(context, scheme),
                  const SizedBox(width: 10),
                  _buildCountText(scheme),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onPrimary.withValues(alpha: 0.35),
                    size: 16,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context, ColorScheme scheme) {
    if (previewParticipants.isEmpty) {
      return Icon(
        Icons.people_alt_rounded,
        color: scheme.onPrimary.withValues(alpha: 0.40),
        size: 22,
      );
    }

    final shown = previewParticipants.take(4).toList();
    final avatarRadius = _avatarSize / 2;

    return SizedBox(
      height: _avatarSize,
      width: (shown.length * avatarRadius) + avatarRadius,
      child: Stack(
        alignment: Alignment.topLeft,
        children:
            shown.asMap().entries.map((entry) {
              final participation = entry.value;
              final index = entry.key;

              final avatar = Hero(
                tag:
                    "profile_picture_participation_${participation.user.id}",
                child: Container(
                  width: _avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primaryContainer,
                      width: _borderSize,
                    ),
                  ),
                  child: UserProfilePicture(
                    url: participation.user.profilePicture,
                    profilePictureKey: participation.user.profilePictureKey,
                    radius: avatarRadius,
                  ),
                ),
              );

              if (index == 0) return avatar;

              return Positioned(
                top: -_borderSize,
                left: avatarRadius * index.toDouble(),
                child: avatar,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCountText(ColorScheme scheme) {
    final style = TextStyle(
      color: scheme.onPrimary.withValues(alpha: 0.88),
      fontSize: 12,
      fontVariations: const [FontVariation.weight(650)],
    );

    if (previewParticipantsCount == 0) {
      return Text(
        'Aucun participant',
        style: style.copyWith(
          color: scheme.onPrimary.withValues(alpha: 0.55),
          fontVariations: const [FontVariation.weight(500)],
        ),
      );
    }

    if (previewParticipantsCount == 1) {
      return Text('1 participant', style: style);
    }

    return Text('$previewParticipantsCount participants', style: style);
  }
}
