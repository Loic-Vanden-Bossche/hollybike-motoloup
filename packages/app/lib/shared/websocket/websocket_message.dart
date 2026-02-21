/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'websocket_message.freezed.dart';
part 'websocket_message.g.dart';

abstract class WebsocketBody {
  final String type = '';
  Map<String, dynamic> toJson();
}

@Freezed(genericArgumentFactories: true)
sealed class WebsocketMessage<T extends WebsocketBody>
    with _$WebsocketMessage<T> {
  const factory WebsocketMessage({required String channel, required T data}) =
      _WebsocketMessage<T>;

  factory WebsocketMessage.fromJson(
    JsonMap json,
    T Function(Object? json) fromJsonT,
  ) => _$WebsocketMessageFromJson(json, fromJsonT);
}
