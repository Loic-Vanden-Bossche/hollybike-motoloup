// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoJSON _$GeoJSONFromJson(Map<String, dynamic> json) => _GeoJSON(
  bbox:
      (json['bbox'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
);

Map<String, dynamic> _$GeoJSONToJson(_GeoJSON instance) => <String, dynamic>{
  'bbox': instance.bbox,
};
