// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventParticipation _$EventParticipationFromJson(Map<String, dynamic> json) =>
    _EventParticipation(
      user: MinimalUser.fromJson(json['user'] as Map<String, dynamic>),
      isImagesPublic: json['isImagesPublic'] as bool,
      role: $enumDecode(_$EventRoleEnumMap, json['role']),
      joinedDateTime: DateTime.parse(json['joinedDateTime'] as String),
      journey:
          json['journey'] == null
              ? null
              : UserJourney.fromJson(json['journey'] as Map<String, dynamic>),
      stepJourneys:
          (json['stepJourneys'] as List<dynamic>?)
              ?.map(
                (e) => EventCallerParticipationStepJourney.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EventParticipationToJson(_EventParticipation instance) =>
    <String, dynamic>{
      'user': instance.user,
      'isImagesPublic': instance.isImagesPublic,
      'role': _$EventRoleEnumMap[instance.role]!,
      'joinedDateTime': instance.joinedDateTime.toIso8601String(),
      'journey': instance.journey,
      'stepJourneys': instance.stepJourneys,
    };

const _$EventRoleEnumMap = {
  EventRole.organizer: 'Organizer',
  EventRole.member: 'Member',
};
