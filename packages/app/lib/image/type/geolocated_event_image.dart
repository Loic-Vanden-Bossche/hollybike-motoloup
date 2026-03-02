/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/position.dart';

import '../../shared/types/json_map.dart';

part 'geolocated_event_image.freezed.dart';
part 'geolocated_event_image.g.dart';

@freezed
sealed class GeolocatedEventImage with _$GeolocatedEventImage {
  const factory GeolocatedEventImage({
    required int id,
    required String key,
    required String url,
    required int width,
    required int height,
    @JsonKey(name: "taken_date_time") required DateTime? takenDateTime,
    required Position position,
  }) = _GeolocatedEventImage;

  factory GeolocatedEventImage.fromJson(JsonMap json) =>
      _$GeolocatedEventImageFromJson(json);
}
