/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
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

  const EventDetailsMap({
    super.key,
    required this.eventId,
    required this.journey,
    required this.onMapLoaded,
    this.onMapInteractionStart,
  });

  @override
  State<EventDetailsMap> createState() => _EventDetailsMapState();
}

class _EventDetailsMapState extends State<EventDetailsMap> {
  @override
  void initState() {
    super.initState();

    context.read<UserPositionsBloc>().add(
      SubscribeToUserPositions(eventId: widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPositionsBloc, UserPositionsState>(
      builder: (context, state) {
        if (widget.journey == null && state.userPositions.isEmpty) {
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
                child: JourneyMap(
                  journey: widget.journey,
                  onMapLoaded: widget.onMapLoaded,
                  onMapInteractionStart: widget.onMapInteractionStart,
                  userPositions: state.userPositions,
                ),
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
