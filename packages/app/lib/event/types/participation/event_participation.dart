/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../user_journey/type/user_journey.dart';
import '../../../shared/types/json_map.dart';
import '../../../user/types/minimal_user.dart';
import 'event_caller_participation.dart';
import 'event_caller_participation_step_journey.dart';
import 'event_role.dart';

part 'event_participation.freezed.dart';
part 'event_participation.g.dart';

@freezed
sealed class EventParticipation with _$EventParticipation {
  const EventParticipation._();

  const factory EventParticipation({
    required MinimalUser user,
    required bool isImagesPublic,
    required EventRole role,
    required DateTime joinedDateTime,
    required UserJourney? journey,
    @Default([]) List<EventCallerParticipationStepJourney> stepJourneys,
  }) = _EventParticipation;

  factory EventParticipation.fromJson(JsonMap json) =>
      _$EventParticipationFromJson(json);

  EventCallerParticipation toEventCallerParticipation() {
    return EventCallerParticipation(
      userId: user.id,
      isImagesPublic: isImagesPublic,
      role: role,
      joinedDateTime: joinedDateTime,
      journey: journey,
      hasRecordedPositions: false,
      stepJourneys: stepJourneys,
    );
  }

  String get roleName {
    switch (role) {
      case EventRole.organizer:
        return 'Organisateur';
      case EventRole.member:
        return 'Participant';
    }
  }
}
