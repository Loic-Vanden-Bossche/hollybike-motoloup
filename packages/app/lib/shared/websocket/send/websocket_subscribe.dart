/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';
import '../websocket_message.dart';

part 'websocket_subscribe.freezed.dart';
part 'websocket_subscribe.g.dart';

@freezed
sealed class WebsocketSubscribe with _$WebsocketSubscribe implements WebsocketBody {
  const factory WebsocketSubscribe({
    required String token,
    @Default("subscribe") String type,
  }) = _WebsocketSubscribe;

  factory WebsocketSubscribe.fromJson(JsonMap json) =>
      _$WebsocketSubscribeFromJson(json);
}
