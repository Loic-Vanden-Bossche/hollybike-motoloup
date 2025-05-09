/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../user_journey/type/user_journey.dart';
import '../../../shared/types/json_map.dart';
import 'event_role.dart';

part 'event_caller_participation.freezed.dart';
part 'event_caller_participation.g.dart';

@freezed
sealed class EventCallerParticipation with _$EventCallerParticipation {
  const factory EventCallerParticipation({
    required int userId,
    required bool isImagesPublic,
    required EventRole role,
    required DateTime joinedDateTime,
    required UserJourney? journey,
    required bool hasRecordedPositions,
  }) = _EventCallerParticipation;

  factory EventCallerParticipation.fromJson(JsonMap json) =>
      _$EventCallerParticipationFromJson(json);
}
