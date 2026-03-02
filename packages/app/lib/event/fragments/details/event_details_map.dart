/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_bloc.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_state.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/event/widgets/map/event_map_photo_carousel.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

class EventDetailsMap extends StatefulWidget {
  final int eventId;
  final MinimalJourney? journey;
  final void Function() onMapLoaded;
  final void Function()? onMapInteractionStart;
  final bool isMapFullscreen;
  final VoidCallback onRequestFullscreen;

  const EventDetailsMap({
    super.key,
    required this.eventId,
    required this.journey,
    required this.onMapLoaded,
    required this.isMapFullscreen,
    required this.onRequestFullscreen,
    this.onMapInteractionStart,
  });

  @override
  State<EventDetailsMap> createState() => _EventDetailsMapState();
}

class _EventDetailsMapState extends State<EventDetailsMap> {
  final JourneyMapController _mapController = JourneyMapController();

  @override
  void initState() {
    super.initState();
    context.read<UserPositionsBloc>().add(
      SubscribeToUserPositions(eventId: widget.eventId),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionsBloc, UserPositionsState>(
      builder: (context, posState) {
        final imagesState = context.watch<EventMapImagesBloc>().state;
        final hasGeolocatedImages =
            imagesState is EventMapImagesLoaded &&
            imagesState.images.isNotEmpty;

        if (widget.journey == null &&
            posState.userPositions.isEmpty &&
            !hasGeolocatedImages) {
          return ThemedRefreshIndicator(
            onRefresh: () => _refreshEventDetails(context),
            child: ScrollablePlaceholder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: MediaQuery.of(context).size.width * 0.1,
              child: _buildPlaceholder(),
            ),
          );
        }

        return EventDetailsTabScrollWrapper(
          scrollViewKey: 'event_details_map_${widget.eventId}',
          sliverChild: true,
          child: SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _MapCard(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    JourneyMap(
                      journey: widget.journey,
                      controller: _mapController,
                      onMapLoaded: widget.onMapLoaded,
                      onMapInteractionStart: widget.onMapInteractionStart,
                    ),
                    _buildCarouselOverlay(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarouselOverlay() {
    return BlocBuilder<EventMapImagesBloc, EventMapImagesState>(
      builder: (context, state) {
        final images = state is EventMapImagesLoaded ? state.images : null;
        final show = images != null && images.isNotEmpty;

        return Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 24),
            child: AnimatedSlide(
              offset: show ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 380),
              curve: show ? Curves.easeOutCubic : Curves.easeInCubic,
              child: AnimatedOpacity(
                opacity: show ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 280),
                child: show
                    ? EventMapPhotoCarousel(
                        images: images,
                        isMapFullscreen: widget.isMapFullscreen,
                        onRequestFullscreen: widget.onRequestFullscreen,
                        onCollapsed: () => _mapController.hideMarker(),
                        onExpanded: (index) {
                          _mapController.showMarkerFor(images[index]);
                          _mapController.panCameraTo(images[index]);
                        },
                        onPageChanged: (index) {
                          _mapController.showMarkerFor(images[index]);
                          _mapController.panCameraTo(images[index]);
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          child: Lottie.asset(
            fit: BoxFit.cover,
            'assets/lottie/lottie_journey.json',
            repeat: false,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Aucun trajet lié à cet évènement ou aucun utilisateur ne partage sa position.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _refreshEventDetails(BuildContext context) {
    context.read<EventDetailsBloc>().add(LoadEventDetails());
    return context.read<EventDetailsBloc>().firstWhenNotLoading;
  }
}

// ── _MapCard ──────────────────────────────────────────────────────────────────

class _MapCard extends StatelessWidget {
  final Widget child;

  const _MapCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.14),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24000000),
              blurRadius: 26,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
