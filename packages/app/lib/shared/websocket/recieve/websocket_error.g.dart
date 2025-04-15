// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketError _$WebsocketErrorFromJson(Map<String, dynamic> json) =>
    _WebsocketError(
      message: json['message'] as String,
      type: json['type'] as String? ?? "subscribed",
    );

Map<String, dynamic> _$WebsocketErrorToJson(_WebsocketError instance) =>
    <String, dynamic>{'message': instance.message, 'type': instance.type};
