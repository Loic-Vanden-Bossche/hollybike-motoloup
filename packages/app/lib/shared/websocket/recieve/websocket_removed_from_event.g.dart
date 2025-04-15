// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_removed_from_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketRemovedFromEvent _$WebsocketRemovedFromEventFromJson(
  Map<String, dynamic> json,
) => _WebsocketRemovedFromEvent(
  type: json['type'] as String? ?? "RemovedFromEventNotification",
  notificationId: (json['notification_id'] as num).toInt(),
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$WebsocketRemovedFromEventToJson(
  _WebsocketRemovedFromEvent instance,
) => <String, dynamic>{
  'type': instance.type,
  'notification_id': instance.notificationId,
  'id': instance.id,
  'name': instance.name,
};
