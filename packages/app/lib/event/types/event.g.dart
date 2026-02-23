// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  owner: MinimalUser.fromJson(json['owner'] as Map<String, dynamic>),
  status: $enumDecode(_$EventStatusStateEnumMap, json['status']),
  startDate: DateTime.parse(json['start_date_time'] as String),
  endDate:
      json['end_date_time'] == null
          ? null
          : DateTime.parse(json['end_date_time'] as String),
  createdAt: DateTime.parse(json['create_date_time'] as String),
  updatedAt: DateTime.parse(json['update_date_time'] as String),
  description: json['description'] as String?,
  image: json['image'] as String?,
  imageKey: json['image_key'] as String?,
  budget: (json['budget'] as num?)?.toInt(),
  participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
  distance: (json['distance'] as num?)?.toInt(),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'owner': instance.owner,
  'status': _$EventStatusStateEnumMap[instance.status]!,
  'start_date_time': instance.startDate.toIso8601String(),
  'end_date_time': instance.endDate?.toIso8601String(),
  'create_date_time': instance.createdAt.toIso8601String(),
  'update_date_time': instance.updatedAt.toIso8601String(),
  'description': instance.description,
  'image': instance.image,
  'image_key': instance.imageKey,
  'budget': instance.budget,
  'participants_count': instance.participantsCount,
  'distance': instance.distance,
};

const _$EventStatusStateEnumMap = {
  EventStatusState.pending: 'Pending',
  EventStatusState.scheduled: 'Scheduled',
  EventStatusState.canceled: 'Cancelled',
  EventStatusState.finished: 'Finished',
  EventStatusState.now: 'Now',
};
