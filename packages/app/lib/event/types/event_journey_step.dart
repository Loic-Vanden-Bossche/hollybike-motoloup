/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/journey/type/minimal_journey.dart';

import '../../shared/types/json_map.dart';

class EventJourneyStep {
  final int id;
  final int journeyId;
  final String? name;
  final int position;
  final bool isCurrent;
  final MinimalJourney journey;

  const EventJourneyStep({
    required this.id,
    required this.journeyId,
    required this.name,
    required this.position,
    required this.isCurrent,
    required this.journey,
  });

  factory EventJourneyStep.fromJson(JsonMap json) {
    return EventJourneyStep(
      id: json['id'] as int,
      journeyId: json['journey_id'] as int,
      name: json['name'] as String?,
      position: json['position'] as int,
      isCurrent: json['is_current'] as bool,
      journey: MinimalJourney.fromJson(json['journey'] as JsonMap),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'journey_id': journeyId,
      'name': name,
      'position': position,
      'is_current': isCurrent,
      'journey': journey.toJson(),
    };
  }
}
