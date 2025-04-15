// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_subscribe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketSubscribe _$WebsocketSubscribeFromJson(Map<String, dynamic> json) =>
    _WebsocketSubscribe(
      token: json['token'] as String,
      type: json['type'] as String? ?? "subscribe",
    );

Map<String, dynamic> _$WebsocketSubscribeToJson(_WebsocketSubscribe instance) =>
    <String, dynamic>{'token': instance.token, 'type': instance.type};
