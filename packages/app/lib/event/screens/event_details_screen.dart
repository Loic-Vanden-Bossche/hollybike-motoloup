/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/event/fragments/details/event_details_images.dart';
import 'package:hollybike/event/fragments/details/event_details_infos.dart';
import 'package:hollybike/event/fragments/details/event_details_map.dart';
import 'package:hollybike/event/services/participation/event_participation_repository.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/details/event_details_header.dart';
import 'package:hollybike/event/widgets/details/event_edit_floating_button.dart';
import 'package:hollybike/ui/widgets/bar/glass_tab_bar.dart';
import 'package:hollybike/ui/widgets/buttons/glass_fab.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_container.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:provider/provider.dart';

import '../../app/app_router.gr.dart';
import '../../image/services/image_repository.dart';
import '../../positions/background/tracking_nav_intent.dart';
import '../../positions/bloc/my_position/my_position_bloc.dart';
import '../../positions/bloc/my_position/my_position_event.dart';
import '../../positions/bloc/user_positions/user_positions_bloc.dart';
import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';
import '../bloc/event_images_bloc/event_images_bloc.dart';
import '../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../bloc/event_map_images/event_map_images_bloc.dart';
import '../bloc/event_map_images/event_map_images_event.dart';
import '../fragments/details/event_details_my_images.dart';
import '../services/event/event_repository.dart';
import '../types/event_details.dart';
import '../widgets/details/event_details_actions_menu.dart';
import '../widgets/images/show_event_images_picker.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';

enum EventDetailsTab { info, photos, myPhotos, map }

const _kEventDetailsTabBarBodyHeight = 52.0;
const _kEventDetailsTabBarHorizontalInset = 16.0;
const _kEventDetailsTabBarVerticalInset = 0.0;
const _kEventDetailsTopBarContentHeight = 56.0;
const _kEventDetailsHeaderHeight = 260.0;
const _kEventDetailsTopBarPinThreshold = 24.00;

class Args {
  final MinimalEvent? event;
  final bool animate;

  Args({required this.event, this.animate = true});
}

@RoutePage()
class EventDetailsScreen extends StatefulWidget implements AutoRouteWrapper {
  final MinimalEvent event;
  final bool animate;
  final String uniqueKey;

  const EventDetailsScreen({
    super.key,
    required this.event,
    this.animate = true,
    this.uniqueKey = "default",
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create:
          (context) => EventDetailsBloc(
            eventRepository: RepositoryProvider.of<EventRepository>(context),
            eventParticipationRepository:
                RepositoryProvider.of<EventParticipationRepository>(context),
            eventId: event.id,
          )..add(SubscribeToEvent()),
      child: this,
    );
  }
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 4,
    vsync: this,
    initialIndex: 0,
  );

  late bool _animate = widget.animate;

  late final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _myImagesSelectionActive = ValueNotifier(false);
  bool _interceptBackOnMap = false;
  bool _isTabBarPinnedUnderTopBar = false;

  // Set to true when the screen is opened via the "Terminer le parcours"
  // notification action.  Cleared after the confirmation dialog is shown once.
  bool _pendingAutoTerminate = false;
  StreamSubscription<int>? _trackingNavSubscription;
  int? _focusedMapStepId;
  int _mapFocusRequestVersion = 0;

  EventDetailsTab currentTab = EventDetailsTab.info;

  @override
  void initState() {
    super.initState();

    _tabController.animation?.addListener(() {
      final newTab =
          EventDetailsTab.values[_tabController.animation!.value.round()];

      if (currentTab != newTab) {
        setState(() {
          currentTab = newTab;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncBackInterception();
        });
      }
    });

    _scrollController.addListener(_syncBackInterception);
    _refreshEventDetails();

    // If this screen was opened from the "Terminer le parcours" notification
    // action, mark that we should auto-trigger the confirmation dialog once
    // the event details have finished loading.
    final pendingTerminateId = TrackingNavIntent.consumePendingTerminate();
    if (pendingTerminateId == widget.event.id) {
      _pendingAutoTerminate = true;
    }

    _trackingNavSubscription = TrackingNavIntent.stream.listen((eventId) {
      if (!mounted || eventId != widget.event.id) return;

      final pendingTerminateId = TrackingNavIntent.consumePendingTerminate();
      if (pendingTerminateId != widget.event.id) return;

      final detailsState = context.read<EventDetailsBloc>().state;
      final details = detailsState.eventDetails;

      if (details != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _autoTriggerTerminate(context, details);
        });
      } else {
        _pendingAutoTerminate = true;
      }
    });
  }

  @override
  void dispose() {
    _trackingNavSubscription?.cancel();
    _tabController.dispose();
    _scrollController.removeListener(_syncBackInterception);
    _myImagesSelectionActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarInset = MediaQuery.viewPaddingOf(context).top;
    final pinnedTopOffset = statusBarInset + _kEventDetailsTopBarContentHeight;

    return PopScope(
      canPop: !_interceptBackOnMap,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!_interceptBackOnMap) return;
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      },
      child: BlocListener<EventDetailsBloc, EventDetailsState>(
        listener: (context, state) {
          // Auto-trigger terminate dialog once event details have loaded,
          // when the screen was opened from the notification action button.
          if (_pendingAutoTerminate && state is EventDetailsLoadSuccess) {
            _pendingAutoTerminate = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _autoTriggerTerminate(context, state.eventDetails);
            });
          }

          if (state is EventOperationFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          } else if (state is EventDetailsLoadFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          } else if (state is DeleteEventFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          }

          if (state is EventOperationSuccess) {
            Toast.showSuccessToast(context, state.successMessage);
          }

          if (state is DeleteEventSuccess) {
            Toast.showSuccessToast(context, "Événement supprimé");

            setState(() {
              _animate = false;
            });

            context.router.removeWhere((route) {
              if (route.path == '/event-participations') {
                final eventId =
                    route
                        .argsAs(
                          orElse:
                              () => EventParticipationsRouteArgs(
                                eventDetails: EventDetails.empty(),
                                participationPreview: [],
                              ),
                        )
                        .eventDetails
                        .event
                        .id;

                return eventId == widget.event.id;
              }

              if (route.path == "/event-details") {
                final eventId =
                    route
                        .argsAs(
                          orElse:
                              () => EventDetailsRouteArgs(
                                event: MinimalEvent.empty(),
                              ),
                        )
                        .event
                        .id;

                return eventId == widget.event.id;
              }

              return false;
            });
          }
        },
        child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<EventImagesBloc>(
                  create:
                      (context) => EventImagesBloc(
                        eventId: widget.event.id,
                        imageRepository: RepositoryProvider.of<ImageRepository>(
                          context,
                        ),
                      ),
                ),
                BlocProvider(
                  create:
                      (context) => EventMyImagesBloc(
                        eventId: widget.event.id,
                        imageRepository: RepositoryProvider.of<ImageRepository>(
                          context,
                        ),
                        eventRepository: RepositoryProvider.of<EventRepository>(
                          context,
                        ),
                      ),
                ),
              ],
              child: Hud(
                appBar: TopBar(
                  prefix: TopBarActionIcon(
                    onPressed: _handleBackNavigation,
                    icon: Icons.arrow_back,
                  ),
                  title: TopBarTitle(""),
                  useTitleContainer: false,
                  suffix: _renderActions(state),
                ),
                floatingActionButton: _getFloatingButton(),
                body: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool _) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: EventDetailsHeader(
                          event:
                              state.eventDetails?.event.toMinimalEvent() ??
                              widget.event,
                          animate: _animate,
                          uniqueKey: widget.uniqueKey,
                        ),
                      ),
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                        sliver: SliverPersistentHeader(
                          pinned: true,
                          delegate: _EventDetailsPinnedTabBarDelegate(
                            height:
                                _kEventDetailsTabBarBodyHeight +
                                (_kEventDetailsTabBarVerticalInset * 2),
                            pinnedTopOffset: pinnedTopOffset,
                            isPinned: _isTabBarPinnedUnderTopBar,
                            isHidden:
                                _isTabBarPinnedUnderTopBar &&
                                currentTab == EventDetailsTab.map,
                            child: GlassTabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.center,
                              margin: EdgeInsets.zero,
                              items: const [
                                GlassTabItem(
                                  icon: Icons.info_rounded,
                                  label: 'Infos',
                                ),
                                GlassTabItem(
                                  icon: Icons.photo_library_rounded,
                                  label: 'Photos',
                                ),
                                GlassTabItem(
                                  icon: Icons.add_photo_alternate_rounded,
                                  label: 'Mes photos',
                                ),
                                GlassTabItem(
                                  icon: Icons.explore_rounded,
                                  label: 'Carte',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: _tabTabContent(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleBackNavigation() async {
    if (_shouldScrollMapToTopFirst()) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (!mounted) return;
    context.router.maybePop();
  }

  bool _shouldScrollMapToTopFirst() {
    if (currentTab != EventDetailsTab.map) return false;
    if (!_scrollController.hasClients) return false;
    return _scrollController.offset > 24;
  }

  void _syncBackInterception() {
    final shouldIntercept = _shouldScrollMapToTopFirst();
    final shouldPinTabBar = _shouldPinTabBarUnderTopBar();
    final shouldUpdateMapInterception = shouldIntercept != _interceptBackOnMap;
    final shouldUpdateTabPin = shouldPinTabBar != _isTabBarPinnedUnderTopBar;

    if ((shouldUpdateMapInterception || shouldUpdateTabPin) && mounted) {
      setState(() {
        if (shouldUpdateMapInterception) {
          _interceptBackOnMap = shouldIntercept;
        }
        if (shouldUpdateTabPin) {
          _isTabBarPinnedUnderTopBar = shouldPinTabBar;
        }
      });
    }
  }

  bool _shouldPinTabBarUnderTopBar() {
    if (!_scrollController.hasClients || !mounted) return false;

    final statusBarInset = MediaQuery.viewPaddingOf(context).top;
    final topUiHeight = statusBarInset + _kEventDetailsTopBarContentHeight;
    final triggerOffset =
        _kEventDetailsHeaderHeight -
        topUiHeight +
        _kEventDetailsTopBarPinThreshold;

    return _scrollController.offset >= triggerOffset;
  }

  // ── Tab content ────────────────────────────────────────────────────────────

  Widget _tabTabContent() {
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        if (state.eventDetails == null && state is EventDetailsLoadFailure) {
          return const Center(
            child: Text("Impossible de charger les détails de l'événement"),
          );
        }

        return AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild:
              state.eventDetails == null
                  ? const SizedBox()
                  : TabBarView(
                    controller: _tabController,
                    children: _getTabs(state.eventDetails!),
                  ),
          secondChild: const Center(child: CircularProgressIndicator()),
          crossFadeState:
              state is EventDetailsLoadInProgress && state.eventDetails == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
        );
      },
    );
  }

  List<Widget> _getTabs(EventDetails eventDetails) {
    return [
      ThemedRefreshIndicator(
        onRefresh: _refreshEventDetails,
        child: EventDetailsInfos(
          eventDetails: eventDetails,
          onViewOnMap: (stepId) {
            _focusedMapStepId = stepId;
            _mapFocusRequestVersion++;
            _tabController.animateTo(3);
          },
        ),
      ),
      Builder(
        builder: (context) {
          return EventDetailsImages(
            scrollController: _scrollController,
            eventId: eventDetails.event.id,
            isParticipating: eventDetails.isParticipating,
            onAddPhotos: () => _onAddPhotoFromAllPhotos(context),
          );
        },
      ),
      EventDetailsMyImages(
        scrollController: _scrollController,
        isParticipating: eventDetails.isParticipating,
        selectionNotifier: _myImagesSelectionActive,
        isImagesPublic:
            eventDetails.callerParticipation?.isImagesPublic ?? false,
        eventId: eventDetails.event.id,
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => UserPositionsBloc(
                  authPersistence: Provider.of<AuthPersistence>(
                    context,
                    listen: false,
                  ),
                  profileRepository: RepositoryProvider.of<ProfileRepository>(
                    context,
                  ),
                  canSeeUserPositions: eventDetails.isParticipating,
                ),
          ),
          BlocProvider(
            create:
                (context) => EventMapImagesBloc(
                  eventId: eventDetails.event.id,
                  imageRepository: RepositoryProvider.of<ImageRepository>(
                    context,
                  ),
                )..add(LoadEventMapImages()),
          ),
        ],
        child: EventDetailsMap(
          eventId: eventDetails.event.id,
          journeySteps: eventDetails.journeySteps,
          currentStepId: eventDetails.currentStepId,
          focusedStepId: _focusedMapStepId,
          focusRequestVersion: _mapFocusRequestVersion,
          onMapLoaded: _scrollMapToFullscreen,
          onMapInteractionStart: _scrollMapToFullscreen,
          isMapFullscreen: _isTabBarPinnedUnderTopBar,
          onRequestFullscreen: _scrollMapToFullscreen,
        ),
      ),
    ];
  }

  void _scrollMapToFullscreen() {
    if (!_scrollController.hasClients) return;

    final target = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;

    if ((target - current).abs() < 24) return;

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _refreshEventDetails() {
    context.read<EventDetailsBloc>().add(LoadEventDetails());

    return context.read<EventDetailsBloc>().firstWhenNotLoading;
  }

  // Called once after the event details load when the screen was opened via
  // the "Terminer le parcours" notification action.  Reuses the same
  // confirmation dialog and BLoC events as EventNowStatus / EventFinishedStatus.
  Future<void> _autoTriggerTerminate(
    BuildContext context,
    EventDetails? details,
  ) async {
    if (details == null) return;
    if (!mounted) return;

    final canTerminate =
        details.callerParticipation?.journey == null &&
        details.callerParticipation?.hasRecordedPositions == true;
    if (!canTerminate) return;

    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: "Terminer le parcours",
      message:
          "Êtes-vous sûr de vouloir terminer le parcours ? Vous ne pourrez plus partager votre position en temps réel.",
      cancelLabel: "Annuler",
      confirmLabel: "Terminer",
    );

    if (confirmed == true && context.mounted) {
      context.read<EventDetailsBloc>().add(
        TerminateUserJourney(stepId: details.currentStepId),
      );
      context.read<MyPositionBloc>().add(DisableSendPositions());
    }
  }

  Widget? _getFloatingButton() {
    switch (currentTab) {
      case EventDetailsTab.info:
        return BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoadFailure ||
                (state is EventDetailsLoadInProgress &&
                    state.eventDetails == null) ||
                state.eventDetails == null) {
              return const SizedBox();
            }

            final eventDetails = state.eventDetails!;

            return EventEditFloatingButton(
              canEdit: eventDetails.isOrganizer,
              event: eventDetails.event,
              onEdit: _onEdit,
            );
          },
        );
      case EventDetailsTab.photos:
        return null;
      case EventDetailsTab.myPhotos:
        return ValueListenableBuilder<bool>(
          valueListenable: _myImagesSelectionActive,
          builder: (context, selectionActive, _) {
            if (selectionActive) return const SizedBox();

            return BlocBuilder<EventDetailsBloc, EventDetailsState>(
              builder: (context, state) {
                if (state is EventDetailsLoadFailure ||
                    state is EventDetailsLoadInProgress ||
                    state.eventDetails == null ||
                    state.eventDetails?.isParticipating == false) {
                  return const SizedBox();
                }

                final eventDetails = state.eventDetails!;

                return Builder(
                  builder: (providerContext) {
                    return GlassFab(
                      icon: Icons.add_a_photo_outlined,
                      label: 'Ajouter des photos',
                      onPressed:
                          () => showEventImagesPicker(
                            providerContext,
                            eventDetails.event.id,
                            bloc: providerContext.read<EventMyImagesBloc>(),
                          ),
                    );
                  },
                );
              },
            );
          },
        );
      case EventDetailsTab.map:
        return null;
    }
  }

  void _onAddPhotoFromAllPhotos(BuildContext providerContext) {
    final eventMyImagesBloc = providerContext.read<EventMyImagesBloc>();
    _tabController.animateTo(2);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      showEventImagesPicker(context, widget.event.id, bloc: eventMyImagesBloc);
    });
  }

  Widget? _renderActions(EventDetailsState state) {
    final event = state.eventDetails;

    if ((state is EventDetailsLoadInProgress && event == null) ||
        state is EventDetailsLoadFailure ||
        event == null ||
        (!event.isOwner && !event.isParticipating && !event.isOrganizer)) {
      return null;
    }

    return TopBarActionContainer(
      colorInverted: true,
      child: EventDetailsActionsMenu(
        eventId: event.event.id,
        status: event.event.status,
        isOwner: event.isOwner,
        isJoined: event.isParticipating,
        isOrganizer: event.isOrganizer,
        hasImage: event.event.image != null,
      ),
    );
  }

  void _onEdit(EventFormData formData) {
    context.read<EventDetailsBloc>().add(EditEvent(formData: formData));

    Navigator.of(context).pop();
  }
}

class _EventDetailsPinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final double pinnedTopOffset;
  final bool isPinned;
  final bool isHidden;
  final Widget child;

  const _EventDetailsPinnedTabBarDelegate({
    required this.height,
    required this.pinnedTopOffset,
    required this.isPinned,
    required this.isHidden,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topOffset = isPinned ? pinnedTopOffset : 0.0;

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
        child: AnimatedOpacity(
          opacity: isHidden ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          child: IgnorePointer(
            ignoring: isHidden,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                _kEventDetailsTabBarHorizontalInset,
                _kEventDetailsTabBarVerticalInset,
                _kEventDetailsTabBarHorizontalInset,
                _kEventDetailsTabBarVerticalInset,
              ),
              child: SizedBox(
                height: _kEventDetailsTabBarBodyHeight,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _EventDetailsPinnedTabBarDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.pinnedTopOffset != pinnedTopOffset ||
        oldDelegate.isPinned != isPinned ||
        oldDelegate.isHidden != isHidden ||
        oldDelegate.child != child;
  }
}
