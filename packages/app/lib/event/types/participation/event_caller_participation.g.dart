// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_caller_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventCallerParticipation _$EventCallerParticipationFromJson(
  Map<String, dynamic> json,
) => _EventCallerParticipation(
  userId: (json['userId'] as num).toInt(),
  isImagesPublic: json['isImagesPublic'] as bool,
  role: $enumDecode(_$EventRoleEnumMap, json['role']),
  joinedDateTime: DateTime.parse(json['joinedDateTime'] as String),
  journey:
      json['journey'] == null
          ? null
          : UserJourney.fromJson(json['journey'] as Map<String, dynamic>),
  hasRecordedPositions: json['hasRecordedPositions'] as bool,
);

Map<String, dynamic> _$EventCallerParticipationToJson(
  _EventCallerParticipation instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'isImagesPublic': instance.isImagesPublic,
  'role': _$EventRoleEnumMap[instance.role]!,
  'joinedDateTime': instance.joinedDateTime.toIso8601String(),
  'journey': instance.journey,
  'hasRecordedPositions': instance.hasRecordedPositions,
};

const _$EventRoleEnumMap = {
  EventRole.organizer: 'Organizer',
  EventRole.member: 'Member',
};
