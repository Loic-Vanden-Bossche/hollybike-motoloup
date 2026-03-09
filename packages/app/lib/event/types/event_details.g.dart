// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDetails _$EventDetailsFromJson(
  Map<String, dynamic> json,
) => _EventDetails(
  event: Event.fromJson(json['event'] as Map<String, dynamic>),
  journeySteps:
      (json['journey_steps'] as List<dynamic>?)
          ?.map((e) => EventJourneyStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentStepId: (json['current_step_id'] as num?)?.toInt(),
  currentJourney:
      json['current_journey'] == null
          ? null
          : MinimalJourney.fromJson(
            json['current_journey'] as Map<String, dynamic>,
          ),
  callerParticipation:
      json['callerParticipation'] == null
          ? null
          : EventCallerParticipation.fromJson(
            json['callerParticipation'] as Map<String, dynamic>,
          ),
  previewParticipants:
      (json['previewParticipants'] as List<dynamic>)
          .map((e) => EventParticipation.fromJson(e as Map<String, dynamic>))
          .toList(),
  previewParticipantsCount: (json['previewParticipantsCount'] as num).toInt(),
  expenses:
      (json['expenses'] as List<dynamic>?)
          ?.map((e) => EventExpense.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalExpense: (json['totalExpense'] as num?)?.toInt(),
);

Map<String, dynamic> _$EventDetailsToJson(_EventDetails instance) =>
    <String, dynamic>{
      'event': instance.event,
      'journey_steps': instance.journeySteps,
      'current_step_id': instance.currentStepId,
      'current_journey': instance.currentJourney,
      'callerParticipation': instance.callerParticipation,
      'previewParticipants': instance.previewParticipants,
      'previewParticipantsCount': instance.previewParticipantsCount,
      'expenses': instance.expenses,
      'totalExpense': instance.totalExpense,
    };
