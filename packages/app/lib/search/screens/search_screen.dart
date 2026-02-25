/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/event/widgets/event_preview_card/event_preview_card.dart';
import 'package:hollybike/event/widgets/event_preview_card/placeholder_event_preview_card.dart';
import 'package:hollybike/search/bloc/search_event.dart';
import 'package:hollybike/search/widgets/search_placeholder/empty_search_placeholder.dart';
import 'package:hollybike/search/widgets/search_placeholder/initial_search_placeholder.dart';
import 'package:hollybike/search/widgets/search_placeholder/loading_search_placeholder.dart';
import 'package:hollybike/search/widgets/search_profile_card/placeholder_search_profile_card.dart';
import 'package:hollybike/search/widgets/search_profile_card/search_profile_card.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_search_input.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../app/app_router.gr.dart';
import '../../event/types/minimal_event.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';

const _kTopBarContentHeight = 5.0;
const _kRefreshTopInsetHeight = 46.0;
const _kSectionHeaderMinHeight = 44.0;
const _kSectionHeaderMaxHeight = 52.0;

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const double _pageTriggerRatio = 0.78;
  static const double _horizontalInset = 16;

  String? _lastSearch;
  late final ScrollController _verticalScrollController;
  late final ScrollController _horizontalScrollController;
  late final FocusNode focusNode;
  bool _isRequestingMoreEvents = false;
  bool _isRequestingMoreProfiles = false;
  bool _hasScrolled = false;
  bool get _isSearchReset => (_lastSearch ?? '').trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    final refreshTopInset =
        MediaQuery.of(context).padding.top + _kRefreshTopInsetHeight;

    return Hud(
      appBar: TopBar(
        title: TopBarSearchInput(
          defaultValue: _lastSearch,
          focusNode: focusNode,
          onSearchRequested: _handleSearchRequest,
        ),
        useTitleContainer: false,
        noPadding: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              _refreshSearch(context, _lastSearch ?? '');
            },
          ),
          BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state.status != SearchStatus.loadingEvents) {
                _isRequestingMoreEvents = false;
              }
              if (state.status != SearchStatus.loadingProfiles) {
                _isRequestingMoreProfiles = false;
              }
            },
          ),
        ],
        child: ThemedRefreshIndicator(
          onRefresh: _refreshCurrentSearch,
          edgeOffset: refreshTopInset,
          displacement: refreshTopInset + 28,
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (_isSearchReset || state.status == SearchStatus.initial) {
                return InitialSearchPlaceholder(
                  onButtonTap: () {
                    focusNode.requestFocus();
                  },
                );
              }

              if (state.status == SearchStatus.fullLoading) {
                return const LoadingSearchPlaceholder();
              }

              if (state.events.isEmpty && state.profiles.isEmpty) {
                return EmptySearchPlaceholder(lastSearch: _lastSearch ?? '');
              }

              return NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  final hasScrolledNow = notification.metrics.pixels > 0;
                  if (hasScrolledNow != _hasScrolled) {
                    setState(() => _hasScrolled = hasScrolledNow);
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _verticalScrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _PhantomHeaderDelegate(
                        height:
                            MediaQuery.of(context).padding.top +
                            _kTopBarContentHeight,
                      ),
                    ),
                    ..._renderProfilesList(state.profiles, state),
                    if (state.profiles.isNotEmpty)
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverMainAxisGroup(
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _AnimatedSearchHeaderDelegate(
                            title: 'Évènements',
                            count: state.events.length,
                            colorScheme: Theme.of(context).colorScheme,
                            hasScrolled: _hasScrolled,
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: _horizontalInset,
                          ),
                          sliver: SliverList.list(
                            children:
                                state.events
                                    .map<Widget>(
                                      (event) => EventPreviewCard(
                                        event: event,
                                        onTap: (uniqueKey) {
                                          _navigateToEventDetails(
                                            context,
                                            event,
                                            uniqueKey,
                                          );
                                        },
                                      ),
                                    )
                                    .toList() +
                                (state.status == SearchStatus.loadingEvents
                                    ? [
                                      const PlaceholderEventPreviewCard(),
                                      const PlaceholderEventPreviewCard(),
                                      const PlaceholderEventPreviewCard(),
                                    ]
                                    : []),
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      displayNavBar: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _lastSearch = BlocProvider.of<SearchBloc>(context).state.lastSearchQuery;
    focusNode = FocusNode();

    _verticalScrollController = ScrollController();
    _verticalScrollController.addListener(() {
      if (!_verticalScrollController.hasClients || _isRequestingMoreEvents) {
        return;
      }

      if (_isNearEnd(_verticalScrollController)) {
        final state = BlocProvider.of<SearchBloc>(context).state;
        if (state.hasMoreEvents && state.lastSearchQuery != null) {
          _isRequestingMoreEvents = true;
          BlocProvider.of<SearchBloc>(context).add(LoadEventsSearchNextPage());
        }
      }
    });

    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(() {
      if (!_horizontalScrollController.hasClients ||
          _isRequestingMoreProfiles) {
        return;
      }

      if (_isNearEnd(_horizontalScrollController)) {
        final state = BlocProvider.of<SearchBloc>(context).state;
        if (state.hasMoreProfiles && state.lastSearchQuery != null) {
          _isRequestingMoreProfiles = true;
          BlocProvider.of<SearchBloc>(
            context,
          ).add(LoadProfilesSearchNextPage());
        }
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  List<Widget> _renderProfilesList(
    List<MinimalUser> profiles,
    SearchState state,
  ) {
    if (profiles.isEmpty) return <Widget>[];

    return <Widget>[
      SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _AnimatedSearchHeaderDelegate(
              title: 'Profils',
              count: profiles.length,
              colorScheme: Theme.of(context).colorScheme,
              hasScrolled: _hasScrolled,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 130,
              child: ListView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children:
                    <Widget>[
                      const SizedBox.square(dimension: _horizontalInset),
                    ] +
                    addSeparators(
                      profiles
                              .map<Widget>(
                                (profile) =>
                                    SearchProfileCard(profile: profile),
                              )
                              .toList() +
                          (state.status == SearchStatus.loadingProfiles
                              ? [
                                const PlaceholderSearchProfileCard(),
                                const PlaceholderSearchProfileCard(),
                                const PlaceholderSearchProfileCard(),
                              ]
                              : []),
                      const SizedBox.square(dimension: 8),
                    ) +
                    <Widget>[
                      const SizedBox.square(dimension: _horizontalInset),
                    ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    String uniqueKey,
  ) {
    context.router.push(
      EventDetailsRoute(event: event, animate: true, uniqueKey: uniqueKey),
    );
  }

  void _handleSearchRequest(String query) {
    final normalizedQuery = query.trim();
    final nextSearch = normalizedQuery.isEmpty ? null : normalizedQuery;

    if (nextSearch == _lastSearch) return;

    if (nextSearch != null) {
      _refreshSearch(context, nextSearch);
    } else {
      BlocProvider.of<SearchBloc>(context).add(ResetSearch());
    }
    setState(() => _lastSearch = nextSearch);
  }

  void _refreshSearch(BuildContext context, String query) {
    if (query.trim().isEmpty) return;
    BlocProvider.of<SearchBloc>(
      context,
    ).add(RefreshSearch(query: query.trim()));
  }

  Future<void> _refreshCurrentSearch() async {
    final query = _lastSearch?.trim();
    if (query == null || query.isEmpty) return;
    _refreshSearch(context, query);
  }

  bool _isNearEnd(ScrollController controller) {
    final position = controller.position;
    final trigger = position.maxScrollExtent * _pageTriggerRatio;
    return position.pixels > trigger;
  }
}

class _AnimatedSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final int count;
  final ColorScheme colorScheme;
  final bool hasScrolled;

  const _AnimatedSearchHeaderDelegate({
    required this.title,
    required this.count,
    required this.colorScheme,
    required this.hasScrolled,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final target = hasScrolled ? 1.0 : 0.0;

    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) {
          final horizontalMargin = lerpDouble(0, 16, t)!;
          final verticalMargin = lerpDouble(0, 4, t)!;
          final radius = lerpDouble(0, 50, t)!;
          final blur = lerpDouble(0, 20, t)!;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: colorScheme.primary.withValues(alpha: 0.6 * t),
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.1 * t),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: colorScheme.secondary,
                        ),
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          letterSpacing: 0.3,
                          color: colorScheme.onPrimary.withValues(
                            alpha: lerpDouble(0.65, 0.75, t)!,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: colorScheme.secondary.withValues(alpha: 0.14),
                          border: Border.all(
                            color: colorScheme.secondary.withValues(
                              alpha: 0.28,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: 11,
                            fontVariations: const [FontVariation.weight(700)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => _kSectionHeaderMaxHeight;

  @override
  double get minExtent => _kSectionHeaderMinHeight;

  @override
  bool shouldRebuild(covariant _AnimatedSearchHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.count != count ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.hasScrolled != hasScrolled;
  }
}

class _PhantomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  const _PhantomHeaderDelegate({required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox(height: height, width: double.infinity);

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _PhantomHeaderDelegate oldDelegate) {
    return oldDelegate.height != height;
  }
}
