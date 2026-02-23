/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/widgets/event_loading_profile_picture.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/async_renderer.dart';
import 'package:provider/provider.dart';

import '../../../auth/services/auth_persistence.dart';
import '../../services/profile_repository.dart';

class ProfileModalList extends StatelessWidget {
  const ProfileModalList({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 320),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.onPrimary.withValues(alpha: 0.09),
              scheme.primary.withValues(alpha: 0.12),
            ],
          ),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return AsyncRenderer(
                future:
                    Provider.of<AuthPersistence>(
                      context,
                      listen: false,
                    ).sessions,
                placeholder: _buildLoadingList(context),
                builder: (sessions) => _buildSessionsList(context, sessions),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, List<AuthSession> sessions) {
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 28,
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 8),
              Text(
                'Aucune session secondaire enregistrée',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Ajoutez un autre compte pour basculer rapidement entre vos profils.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final listHeight = (sessions.length * 76.0).clamp(76.0, 240.0);
    final canScroll = sessions.length > 3;

    return SizedBox(
      height: listHeight + 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: Text(
              '${sessions.length} session${sessions.length > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.7),
                fontVariations: const [FontVariation.weight(650)],
                letterSpacing: 0.2,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: sessions.length,
              physics:
                  canScroll
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              separatorBuilder:
                  (BuildContext context, int index) =>
                      const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final session = sessions[index];
                final isCurrentSession = index == 0;

                return AsyncRenderer(
                  future: RepositoryProvider.of<ProfileRepository>(
                    context,
                  ).getProfile(session),
                  builder:
                      (profile) => _SessionTile(
                        session: session,
                        profile: profile,
                        isCurrentSession: isCurrentSession,
                        onTap:
                            isCurrentSession
                                ? null
                                : () =>
                                    _handleCardTap(context, session, profile),
                      ),
                  placeholder: _SessionTileLoading(
                    isCurrentSession: isCurrentSession,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder:
            (BuildContext context, int index) => const SizedBox(height: 8),
        itemBuilder:
            (context, index) =>
                _SessionTileLoading(isCurrentSession: index == 0),
      ),
    );
  }

  void _handleCardTap(BuildContext context, AuthSession session, Profile _) {
    context.read<AuthBloc>().add(
      AuthChangeCurrentSession(newCurrentSession: session),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final AuthSession session;
  final Profile profile;
  final bool isCurrentSession;
  final VoidCallback? onTap;

  const _SessionTile({
    required this.session,
    required this.profile,
    required this.isCurrentSession,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color:
                isCurrentSession
                    ? scheme.secondary.withValues(alpha: 0.14)
                    : scheme.onPrimary.withValues(alpha: 0.05),
            border: Border.all(
              color:
                  isCurrentSession
                      ? scheme.secondary.withValues(alpha: 0.35)
                      : scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              UserProfilePicture(
                radius: 21,
                url: profile.profilePicture,
                profilePictureKey: profile.profilePictureKey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimary,
                        fontVariations: const [FontVariation.weight(750)],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatHost(session.host),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.secondary.withValues(alpha: 0.92),
                        fontVariations: const [FontVariation.weight(650)],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _buildTrailing(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (isCurrentSession) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: scheme.secondary.withValues(alpha: 0.2),
          border: Border.all(
            color: scheme.secondary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Text(
          'Actif',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.secondary,
            fontVariations: const [FontVariation.weight(750)],
          ),
        ),
      );
    }

    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 14,
      color: scheme.onPrimary.withValues(alpha: 0.52),
    );
  }

  String _formatHost(String rawHost) {
    final parsed = Uri.tryParse(rawHost);
    final host = parsed?.host;
    if (host != null && host.isNotEmpty) return host;
    return rawHost;
  }
}

class _SessionTileLoading extends StatelessWidget {
  final bool isCurrentSession;

  const _SessionTileLoading({required this.isCurrentSession});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            isCurrentSession
                ? scheme.secondary.withValues(alpha: 0.10)
                : scheme.onPrimary.withValues(alpha: 0.04),
        border: Border.all(
          color:
              isCurrentSession
                  ? scheme.secondary.withValues(alpha: 0.25)
                  : scheme.onPrimary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: scheme.onPrimary.withValues(alpha: 0.12),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(context, width: 120),
                const SizedBox(height: 7),
                _line(context, width: 170, alpha: 0.24),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _line(context, width: 44, height: 12, alpha: 0.22),
        ],
      ),
    );
  }

  Widget _line(
    BuildContext context, {
    required double width,
    double height = 13,
    double alpha = 0.3,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: alpha),
      ),
    );
  }
}
