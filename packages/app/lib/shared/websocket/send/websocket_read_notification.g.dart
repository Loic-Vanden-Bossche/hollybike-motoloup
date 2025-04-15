// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_read_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketReadNotification _$WebsocketReadNotificationFromJson(
  Map<String, dynamic> json,
) => _WebsocketReadNotification(
  type: json['type'] as String? ?? "read-notification",
  notificationId: (json['notification'] as num).toInt(),
);

Map<String, dynamic> _$WebsocketReadNotificationToJson(
  _WebsocketReadNotification instance,
) => <String, dynamic>{
  'type': instance.type,
  'notification': instance.notificationId,
};
