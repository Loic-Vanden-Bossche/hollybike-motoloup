// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_caller_participation_step_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventCallerParticipationStepJourney
_$EventCallerParticipationStepJourneyFromJson(Map<String, dynamic> json) =>
    _EventCallerParticipationStepJourney(
      stepId: (json['stepId'] as num).toInt(),
      journey:
          json['journey'] == null
              ? null
              : UserJourney.fromJson(json['journey'] as Map<String, dynamic>),
      hasRecordedPositions: json['hasRecordedPositions'] as bool,
    );

Map<String, dynamic> _$EventCallerParticipationStepJourneyToJson(
  _EventCallerParticipationStepJourney instance,
) => <String, dynamic>{
  'stepId': instance.stepId,
  'journey': instance.journey,
  'hasRecordedPositions': instance.hasRecordedPositions,
};
