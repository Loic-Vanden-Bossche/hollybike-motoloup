// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocated_event_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeolocatedEventImage _$GeolocatedEventImageFromJson(
  Map<String, dynamic> json,
) => _GeolocatedEventImage(
  id: (json['id'] as num).toInt(),
  key: json['key'] as String,
  url: json['url'] as String,
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  takenDateTime:
      json['taken_date_time'] == null
          ? null
          : DateTime.parse(json['taken_date_time'] as String),
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GeolocatedEventImageToJson(
  _GeolocatedEventImage instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
  'taken_date_time': instance.takenDateTime?.toIso8601String(),
  'position': instance.position,
};
