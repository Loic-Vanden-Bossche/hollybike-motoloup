// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDetails _$EventDetailsFromJson(
  Map<String, dynamic> json,
) => _EventDetails(
  event: Event.fromJson(json['event'] as Map<String, dynamic>),
  journey:
      json['journey'] == null
          ? null
          : MinimalJourney.fromJson(json['journey'] as Map<String, dynamic>),
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
      'journey': instance.journey,
      'callerParticipation': instance.callerParticipation,
      'previewParticipants': instance.previewParticipants,
      'previewParticipantsCount': instance.previewParticipantsCount,
      'expenses': instance.expenses,
      'totalExpense': instance.totalExpense,
    };
