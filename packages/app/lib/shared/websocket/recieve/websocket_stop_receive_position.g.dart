// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_stop_receive_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketStopReceivePosition _$WebsocketStopReceivePositionFromJson(
  Map<String, dynamic> json,
) => _WebsocketStopReceivePosition(
  type: json['type'] as String,
  userId: (json['user'] as num).toInt(),
);

Map<String, dynamic> _$WebsocketStopReceivePositionToJson(
  _WebsocketStopReceivePosition instance,
) => <String, dynamic>{'type': instance.type, 'user': instance.userId};
