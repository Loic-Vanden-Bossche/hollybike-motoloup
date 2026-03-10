/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

part 'event_caller_participation_step_journey.freezed.dart';
part 'event_caller_participation_step_journey.g.dart';

@freezed
sealed class EventCallerParticipationStepJourney
    with _$EventCallerParticipationStepJourney {
  const factory EventCallerParticipationStepJourney({
    required int stepId,
    required UserJourney? journey,
    required bool hasRecordedPositions,
  }) = _EventCallerParticipationStepJourney;

  factory EventCallerParticipationStepJourney.fromJson(JsonMap json) =>
      _$EventCallerParticipationStepJourneyFromJson(json);
}
