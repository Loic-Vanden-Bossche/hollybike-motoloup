// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketMessage<T> _$WebsocketMessageFromJson<T extends WebsocketBody>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _WebsocketMessage<T>(
  channel: json['channel'] as String,
  data: fromJsonT(json['data']),
);

Map<String, dynamic> _$WebsocketMessageToJson<T extends WebsocketBody>(
  _WebsocketMessage<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'channel': instance.channel,
  'data': toJsonT(instance.data),
};
