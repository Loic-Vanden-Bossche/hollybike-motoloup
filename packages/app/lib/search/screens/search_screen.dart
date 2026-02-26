/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
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
import 'package:hollybike/ui/widgets/slivers/glass_sliver_headers.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../app/app_router.gr.dart';
import '../../event/types/minimal_event.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_state.dart';

const _kTopBarContentHeight = 5.0;
const _kRefreshTopInsetHeight = 46.0;
const _kSectionHeaderHeight = 52.0;

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

              return CustomScrollView(
                controller: _verticalScrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: PinnedSpacerHeaderDelegate(
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
                        delegate: GlassSectionHeaderDelegate(
                          title: 'Évènements',
                          badgeText: '${state.events.length}',
                          colorScheme: Theme.of(context).colorScheme,
                          height: _kSectionHeaderHeight,
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
            delegate: GlassSectionHeaderDelegate(
              title: 'Profils',
              badgeText: '${profiles.length}',
              colorScheme: Theme.of(context).colorScheme,
              height: _kSectionHeaderHeight,
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
