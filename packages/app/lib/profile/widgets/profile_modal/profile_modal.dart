/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/profile/widgets/profile_modal/profile_modal_list.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import '../../../app/app_router.gr.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import 'package:auto_route/auto_route.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({super.key});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  @override
  Widget build(BuildContext context) {
    final height = min(MediaQuery.of(context).size.height * 0.74, 620.0);

    return GlassBottomModal(
      maxContentHeight: height,
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          const SizedBox(height: 12),
          _controls(context),
          const SizedBox(height: 12),
          const ProfileModalList(),
          const SizedBox(height: 12),
          _addAccountButton(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currentProfile = context.read<ProfileBloc>().currentProfile;
    final profileName =
        currentProfile is ProfileLoadSuccessEvent
            ? currentProfile.profile.username
            : 'Profil';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comptes & Sessions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onPrimary,
                  fontVariations: const [FontVariation.weight(800)],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Connecté en tant que @$profileName',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.70),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: IconButton.styleFrom(
            backgroundColor: scheme.onPrimary.withValues(alpha: 0.10),
            foregroundColor: scheme.onPrimary,
          ),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }

  Widget _controls(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return _ModalActionButton(
                    icon:
                        state.isDark ? Icons.sunny : Icons.nights_stay_rounded,
                    label: state.isDark ? 'Mode clair' : 'Mode sombre',
                    highlighted: false,
                    onTap: () => context.read<ThemeBloc>().add(ThemeSwitch()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final currentSession = state.authSession;

                  return _ModalActionButton(
                    icon: Icons.logout_rounded,
                    label: 'Se déconnecter',
                    highlighted: true,
                    destructive: true,
                    onTap:
                        currentSession == null
                            ? null
                            : () {
                              context.read<AuthBloc>().add(
                                AuthSessionExpired(
                                  expiredSession: currentSession,
                                ),
                              );
                            },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _addAccountButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          context.router.push(
            LoginRoute(
              onAuthSuccess: () => context.router.maybePop(),
              canPop: true,
            ),
          );
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          backgroundColor: scheme.secondary.withValues(alpha: 0.18),
          foregroundColor: scheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: scheme.secondary.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
        ),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Ajouter un compte'),
      ),
    );
  }
}

class _ModalActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final bool destructive;
  final VoidCallback? onTap;

  const _ModalActionButton({
    required this.icon,
    required this.label,
    required this.highlighted,
    this.destructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color:
              destructive
                  ? scheme.error.withValues(alpha: 0.16)
                  : highlighted
                  ? scheme.secondary.withValues(alpha: 0.18)
                  : scheme.onPrimary.withValues(alpha: 0.08),
          border: Border.all(
            color:
                destructive
                    ? scheme.error.withValues(alpha: 0.42)
                    : highlighted
                    ? scheme.secondary.withValues(alpha: 0.42)
                    : scheme.onPrimary.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color:
                  destructive
                      ? scheme.error
                      : highlighted
                      ? scheme.secondary
                      : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      destructive
                          ? scheme.error
                          : highlighted
                          ? scheme.secondary
                          : scheme.onPrimary.withValues(alpha: 0.9),
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
