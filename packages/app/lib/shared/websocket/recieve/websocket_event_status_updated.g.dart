// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_status_updated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketEventStatusUpdated _$WebsocketEventStatusUpdatedFromJson(
  Map<String, dynamic> json,
) => _WebsocketEventStatusUpdated(
  type: json['type'] as String? ?? "EventStatusUpdateNotification",
  id: (json['id'] as num).toInt(),
  notificationId: (json['notification_id'] as num).toInt(),
  status: $enumDecode(_$EventStatusStateEnumMap, json['status']),
  name: json['name'] as String,
  description: json['description'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$WebsocketEventStatusUpdatedToJson(
  _WebsocketEventStatusUpdated instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'notification_id': instance.notificationId,
  'status': _$EventStatusStateEnumMap[instance.status]!,
  'name': instance.name,
  'description': instance.description,
  'image': instance.image,
};

const _$EventStatusStateEnumMap = {
  EventStatusState.pending: 'Pending',
  EventStatusState.scheduled: 'Scheduled',
  EventStatusState.canceled: 'Cancelled',
  EventStatusState.finished: 'Finished',
  EventStatusState.now: 'Now',
};
