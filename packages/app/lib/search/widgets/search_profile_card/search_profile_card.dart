/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../../app/app_router.gr.dart';

class SearchProfileCard extends StatelessWidget {
  final MinimalUser profile;

  const SearchProfileCard({super.key, required this.profile});

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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _handleCardTap(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scheme.secondary.withValues(alpha: 0.50),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.secondary.withValues(alpha: 0.20),
                              blurRadius: 12,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ProfilePicture(user: profile, size: 48),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.90),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(700)],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.role ?? 'Rider',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontSize: 9,
                          fontVariations: const [FontVariation.weight(500)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      context.router.push(ProfileRoute(urlId: '${profile.id}'));
    });
  }
}
