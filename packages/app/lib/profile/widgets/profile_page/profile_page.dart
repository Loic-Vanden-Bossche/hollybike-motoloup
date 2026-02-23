/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/association/types/association.dart';
import 'package:hollybike/event/bloc/events_bloc/events_event.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';
import 'package:hollybike/event/fragments/profile_events.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/image/services/image_repository.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/profile/widgets/profile_banner/profile_banner.dart';
import 'package:hollybike/profile/widgets/profile_page/placeholder_profile_page.dart';
import 'package:hollybike/ui/widgets/bar/glass_tab_bar.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';

import '../../widgets/profile_images.dart';
import '../../widgets/profile_journeys.dart';

const _kProfileTabBarBodyHeight = 52.0;
const _kProfileTabBarHorizontalInset = 14.0;
const _kProfileTabBarVerticalInset = 0.0;

class ProfilePage extends StatefulWidget {
  final int? id;
  final bool profileLoading;
  final MinimalUser? profile;
  final String? email;
  final Association? association;
  final bool isMe;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  const ProfilePage({
    super.key,
    this.id,
    required this.profileLoading,
    required this.profile,
    this.email,
    required this.association,
    this.isMe = false,
    this.onBack,
    this.onSettings,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarInset = MediaQuery.viewPaddingOf(context).top;
    final tabBarHeight =
        _kProfileTabBarBodyHeight + (_kProfileTabBarVerticalInset * 2);

    if (widget.profileLoading) {
      return PlaceholderProfilePage(loadingProfileId: widget.id);
    }

    if (widget.profile == null) {
      return Center(
        child: Text(
          'Une erreur est survenue lors de la récupération du profil.',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.55),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (context, scrolled) => [
              // ── Profile hero banner ──────────────────────────────────────
              SliverToBoxAdapter(
                child: ProfileBanner(
                  profile: widget.profile!,
                  association: widget.association,
                  email: widget.email,
                  canEdit: widget.isMe,
                  onBack: widget.onBack,
                  onSettings: widget.onSettings,
                ),
              ),

              // ── Pinned glass pill tab bar ────────────────────────────────
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _ProfilePinnedTabBarDelegate(
                    height: tabBarHeight,
                    statusBarInset: statusBarInset,
                    child: const GlassTabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      margin: EdgeInsets.zero,
                      items: [
                        GlassTabItem(
                          icon: Icons.event_rounded,
                          label: 'Évènements',
                        ),
                        GlassTabItem(
                          icon: Icons.image_rounded,
                          label: 'Photos',
                        ),
                        GlassTabItem(
                          icon: Icons.route_rounded,
                          label: 'Trajets',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
        body: _tabBarContent(),
      ),
    );
  }

  Widget _tabBarContent() {
    final currentSession = context.read<ProfileBloc>().state.currentSession;

    final key =
        currentSession == null
            ? UniqueKey()
            : ValueKey('${widget.profile!.id}_${currentSession.host}');

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserEventsBloc>(
          key: key,
          create:
              (context) => UserEventsBloc(
                userId: widget.profile!.id,
                eventRepository: RepositoryProvider.of<EventRepository>(
                  context,
                ),
              )..add(SubscribeToEvents()),
        ),
        BlocProvider<ProfileImagesBloc>(
          key: key,
          create:
              (context) => ProfileImagesBloc(
                userId: widget.profile!.id,
                imageRepository: RepositoryProvider.of<ImageRepository>(
                  context,
                ),
              ),
        ),
        BlocProvider(
          key: key,
          create:
              (context) => ProfileJourneysBloc(
                userId: widget.profile!.id,
                userJourneyRepository:
                    RepositoryProvider.of<UserJourneyRepository>(context),
              ),
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final currentProfileEvent =
              context.read<ProfileBloc>().currentProfile;

          final currentProfile =
              currentProfileEvent is ProfileLoadSuccessEvent
                  ? currentProfileEvent.profile.toMinimalUser()
                  : null;

          final isMe = currentProfile?.id == widget.profile?.id;

          return TabBarView(
            children: [
              ProfileEvents(
                isMe: isMe,
                username: widget.profile!.username,
                scrollController: _scrollController,
              ),
              ProfileImages(
                isMe: isMe,
                username: widget.profile!.username,
                scrollController: _scrollController,
              ),
              ProfileJourneys(
                isMe: isMe,
                user: widget.profile as MinimalUser,
                scrollController: _scrollController,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfilePinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double statusBarInset;
  final Widget child;

  const _ProfilePinnedTabBarDelegate({
    required this.height,
    required this.statusBarInset,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topOffset = shrinkOffset > 0 ? statusBarInset : 0.0;

    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: topOffset),
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        builder: (context, animatedTopOffset, child) {
          return Transform.translate(
            offset: Offset(0, animatedTopOffset),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _kProfileTabBarHorizontalInset,
            _kProfileTabBarVerticalInset,
            _kProfileTabBarHorizontalInset,
            _kProfileTabBarVerticalInset,
          ),
          child: SizedBox(height: _kProfileTabBarBodyHeight, child: child),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _ProfilePinnedTabBarDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.statusBarInset != statusBarInset ||
        oldDelegate.child != child;
  }
}
