// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_deleted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketEventDeleted _$WebsocketEventDeletedFromJson(
  Map<String, dynamic> json,
) => _WebsocketEventDeleted(
  type: json['type'] as String? ?? "DeleteEventNotification",
  notificationId: (json['notification_id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$WebsocketEventDeletedToJson(
  _WebsocketEventDeleted instance,
) => <String, dynamic>{
  'type': instance.type,
  'notification_id': instance.notificationId,
  'name': instance.name,
  'description': instance.description,
};
