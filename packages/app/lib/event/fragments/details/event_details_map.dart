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
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/event/widgets/map/event_map_photo_carousel.dart';
import 'package:hollybike/event/widgets/map/journey_map.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

class EventDetailsMap extends StatefulWidget {
  final int eventId;
  final List<EventJourneyStep> journeySteps;
  final int? currentStepId;
  final int? focusedStepId;
  final int focusRequestVersion;
  final void Function() onMapLoaded;
  final void Function()? onMapInteractionStart;
  final bool isMapFullscreen;
  final VoidCallback onRequestFullscreen;

  const EventDetailsMap({
    super.key,
    required this.eventId,
    required this.journeySteps,
    required this.currentStepId,
    required this.focusedStepId,
    required this.focusRequestVersion,
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
  int? _selectedStepId;

  @override
  void initState() {
    super.initState();
    _selectedStepId = _defaultSelectedStepId();
    context.read<UserPositionsBloc>().add(
      SubscribeToUserPositions(eventId: widget.eventId),
    );
  }

  @override
  void didUpdateWidget(covariant EventDetailsMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusRequestVersion != oldWidget.focusRequestVersion &&
        widget.focusedStepId != null &&
        widget.journeySteps.any((step) => step.id == widget.focusedStepId)) {
      _selectedStepId = widget.focusedStepId;
      return;
    }

    final stillExists = widget.journeySteps.any(
      (step) => step.id == _selectedStepId,
    );
    if (!stillExists) {
      _selectedStepId = _defaultSelectedStepId();
    }
  }

  int? _defaultSelectedStepId() {
    if (widget.currentStepId != null &&
        widget.journeySteps.any((step) => step.id == widget.currentStepId)) {
      return widget.currentStepId;
    }

    return widget.journeySteps.isNotEmpty ? widget.journeySteps.first.id : null;
  }

  EventJourneyStep? get _selectedStep {
    if (_selectedStepId == null) return null;

    for (final step in widget.journeySteps) {
      if (step.id == _selectedStepId) {
        return step;
      }
    }

    return null;
  }

  bool get _showLivePositions {
    return widget.currentStepId != null &&
        _selectedStepId == widget.currentStepId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionsBloc, UserPositionsState>(
      builder: (context, posState) {
        final imagesState = context.watch<EventMapImagesBloc>().state;
        final hasGeolocatedImages =
            imagesState is EventMapImagesLoaded &&
            imagesState.images.isNotEmpty;

        final selectedJourney = _selectedStep?.journey;
        final visibleUserPositions =
            _showLivePositions ? posState.userPositions : const [];

        if (selectedJourney == null &&
            visibleUserPositions.isEmpty &&
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
              child: Column(
                children: [
                  if (widget.journeySteps.length > 1) ...[
                    _buildStepSelector(context),
                    const SizedBox(height: 10),
                  ],
                  Expanded(
                    child: _MapCard(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          JourneyMap(
                            key: ValueKey(
                              'journey-map-${selectedJourney?.id}-${_showLivePositions ? 1 : 0}',
                            ),
                            journey: selectedJourney,
                            showLivePositions: _showLivePositions,
                            controller: _mapController,
                            onMapLoaded: widget.onMapLoaded,
                            onMapInteractionStart: widget.onMapInteractionStart,
                          ),
                          _buildCarouselOverlay(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepSelector(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = [...widget.journeySteps]
      ..sort((a, b) => a.position - b.position);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final step = steps[index];
          final selected = step.id == _selectedStepId;
          final isCurrent = step.id == widget.currentStepId;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStepId = step.id;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color:
                    selected
                        ? scheme.secondary.withValues(alpha: 0.18)
                        : scheme.primaryContainer.withValues(alpha: 0.45),
                border: Border.all(
                  color:
                      selected
                          ? scheme.secondary.withValues(alpha: 0.55)
                          : scheme.onPrimary.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    step.name ?? 'Etape ${step.position}',
                    style: TextStyle(
                      color: selected ? scheme.secondary : scheme.onPrimary,
                      fontSize: 12,
                      fontVariations: const [FontVariation.weight(650)],
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
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
                child:
                    show
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
