// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_added_to_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketAddedToEvent _$WebsocketAddedToEventFromJson(
  Map<String, dynamic> json,
) => _WebsocketAddedToEvent(
  type: json['type'] as String? ?? "AddedToEventNotification",
  notificationId: (json['notification_id'] as num).toInt(),
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$WebsocketAddedToEventToJson(
  _WebsocketAddedToEvent instance,
) => <String, dynamic>{
  'type': instance.type,
  'notification_id': instance.notificationId,
  'id': instance.id,
  'name': instance.name,
};
