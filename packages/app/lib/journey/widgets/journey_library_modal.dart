/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_event.dart';
import 'package:hollybike/journey/bloc/journeys_library_bloc/journeys_library_state.dart';
import 'package:hollybike/journey/widgets/journey_library.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';

import '../../event/bloc/event_journey_bloc/event_journey_event.dart';
import '../bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../type/journey.dart';

class JourneyLibraryModal extends StatefulWidget {
  final Event event;
  final void Function()? onJourneyAdded;

  const JourneyLibraryModal({
    super.key,
    required this.event,
    this.onJourneyAdded,
  });

  @override
  State<JourneyLibraryModal> createState() => _JourneyLibraryModalState();
}

class _JourneyLibraryModalState extends State<JourneyLibraryModal> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<JourneysLibraryBloc>(context).add(RefreshJourneysLibrary());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      maxContentHeight: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Sélectionner un parcours',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.onPrimary.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: scheme.onPrimary.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Library content
          BlocBuilder<JourneysLibraryBloc, JourneysLibraryState>(
            builder: (context, state) {
              final isEmpty = state.journeys.isEmpty;
              final isLoading =
                  state is JourneysLibraryPageLoadInProgress ||
                  state is JourneysLibraryInitial;
              final isShrunk =
                  (isLoading && isEmpty) || (isEmpty && !isLoading);

              return AnimatedContainer(
                constraints: BoxConstraints(maxHeight: isShrunk ? 140 : 400),
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                child: _buildLibrary(state.journeys, isLoading && isEmpty),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLibrary(List<Journey> journeys, bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.secondary,
          strokeWidth: 2.5,
        ),
      );
    }

    return ThemedRefreshIndicator(
      onRefresh: _onRefresh,
      child: JourneyLibrary(
        event: widget.event,
        onAddJourney: _onAddJourney,
        onSelected: _onSelectedJourney,
        journeys: journeys,
      ),
    );
  }

  Future<void> _onRefresh() {
    final bloc = BlocProvider.of<JourneysLibraryBloc>(context);
    bloc.add(RefreshJourneysLibrary());
    return bloc.firstWhenNotLoading;
  }

  void _onAddJourney() async {
    Navigator.of(context).pop();
    if (widget.onJourneyAdded != null) {
      widget.onJourneyAdded!();
    }
  }

  void _onSelectedJourney(Journey journey) {
    if (widget.onJourneyAdded != null) {
      widget.onJourneyAdded!();
    }
    BlocProvider.of<EventJourneyBloc>(
      context,
    ).add(AttachJourneyToEvent(journey: journey, eventId: widget.event.id));
    Navigator.of(context).pop();
  }
}
