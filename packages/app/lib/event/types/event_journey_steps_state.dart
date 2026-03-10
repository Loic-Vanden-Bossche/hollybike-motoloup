/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';

import '../../shared/types/json_map.dart';

class EventJourneyStepsState {
  final List<EventJourneyStep> journeySteps;
  final int? currentStepId;
  final MinimalJourney? currentJourney;

  const EventJourneyStepsState({
    required this.journeySteps,
    required this.currentStepId,
    required this.currentJourney,
  });

  factory EventJourneyStepsState.fromJson(JsonMap json) {
    final stepsJson = (json['journey_steps'] as List?) ?? const [];
    return EventJourneyStepsState(
      journeySteps:
          stepsJson
              .whereType<JsonMap>()
              .map(EventJourneyStep.fromJson)
              .toList(),
      currentStepId: json['current_step_id'] as int?,
      currentJourney:
          json['current_journey'] == null
              ? null
              : MinimalJourney.fromJson(json['current_journey'] as JsonMap),
    );
  }
}
