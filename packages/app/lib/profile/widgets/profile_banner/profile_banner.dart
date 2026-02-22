/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/association/types/association.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ProfileBanner extends StatelessWidget {
  final MinimalUser profile;
  final Association? association;
  final String? email;
  final bool canEdit;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  const ProfileBanner({
    super.key,
    required this.profile,
    this.association,
    this.email,
    this.canEdit = false,
    this.onBack,
    this.onSettings,
  });

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
          // Base gradient
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

          // Teal blob — top-left
          Positioned(
            top: -50,
            left: -35,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.secondary.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
          ),

          // Tertiary blob — bottom-right
          Positioned(
            bottom: -35,
            right: -25,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.tertiary.withValues(alpha: 0.16),
                  ),
                ),
              ),
            ),
          ),

          // Content layer
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
                  // ── Nav row ───────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      onBack != null
                          ? _NavButton(
                              icon: Icons.arrow_back_rounded,
                              onTap: onBack!,
                              scheme: scheme,
                            )
                          : const SizedBox(width: 36),
                      onSettings != null
                          ? _NavButton(
                              icon: Icons.settings_rounded,
                              onTap: onSettings!,
                              scheme: scheme,
                            )
                          : const SizedBox(width: 36),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── Avatar with teal glow ring ────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: scheme.secondary.withValues(alpha: 0.55),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.secondary.withValues(alpha: 0.22),
                          blurRadius: 22,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ProfilePicture(user: profile, size: 80),
                  ),
                  const SizedBox(height: 12),

                  // ── Username ──────────────────────────────────────────────
                  Hero(
                    tag: "user-${profile.id}-username",
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        profile.username,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 20,
                          fontVariations: const [FontVariation.weight(750)],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // ── Association + role chip ───────────────────────────────
                  if (association != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: scheme.onPrimary.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${association!.name}  ·  ${profile.role ?? "Membre"}',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.65),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(600)],
                        ),
                      ),
                    ),
                  ],

                  // ── Email (isMe only) ─────────────────────────────────────
                  if (email != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 12,
                          color: scheme.onPrimary.withValues(alpha: 0.38),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          email!,
                          style: TextStyle(
                            color: scheme.onPrimary.withValues(alpha: 0.38),
                            fontSize: 12,
                            fontVariations: const [FontVariation.weight(500)],
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Edit button (isMe) ────────────────────────────────────
                  if (canEdit) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () =>
                          context.router.push(const EditProfileRoute()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: scheme.secondary.withValues(alpha: 0.40),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 13,
                              color: scheme.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Modifier le profil',
                              style: TextStyle(
                                color: scheme.secondary,
                                fontSize: 12,
                                fontVariations: const [
                                  FontVariation.weight(650),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: scheme.onPrimary.withValues(alpha: 0.80),
        ),
      ),
    );
  }
}
