// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_subscribed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebsocketSubscribed _$WebsocketSubscribedFromJson(Map<String, dynamic> json) =>
    _WebsocketSubscribed(
      subscribed: json['subscribed'] as bool,
      type: json['type'] as String? ?? "subscribed",
    );

Map<String, dynamic> _$WebsocketSubscribedToJson(
  _WebsocketSubscribed instance,
) => <String, dynamic>{
  'subscribed': instance.subscribed,
  'type': instance.type,
};
