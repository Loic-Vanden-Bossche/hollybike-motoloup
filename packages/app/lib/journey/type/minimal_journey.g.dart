// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MinimalJourney _$MinimalJourneyFromJson(Map<String, dynamic> json) =>
    _MinimalJourney(
      id: (json['id'] as num).toInt(),
      file: json['file'] as String?,
      start:
          json['start'] == null
              ? null
              : Position.fromJson(json['start'] as Map<String, dynamic>),
      end:
          json['end'] == null
              ? null
              : Position.fromJson(json['end'] as Map<String, dynamic>),
      destination:
          json['destination'] == null
              ? null
              : Position.fromJson(json['destination'] as Map<String, dynamic>),
      totalDistance: (json['totalDistance'] as num?)?.toInt(),
      minElevation: (json['minElevation'] as num?)?.toInt(),
      maxElevation: (json['maxElevation'] as num?)?.toInt(),
      totalElevationGain: (json['totalElevationGain'] as num?)?.toInt(),
      totalElevationLoss: (json['totalElevationLoss'] as num?)?.toInt(),
      previewImage: json['preview_image'] as String?,
      previewImageKey: json['preview_image_key'] as String?,
    );

Map<String, dynamic> _$MinimalJourneyToJson(_MinimalJourney instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'start': instance.start,
      'end': instance.end,
      'destination': instance.destination,
      'totalDistance': instance.totalDistance,
      'minElevation': instance.minElevation,
      'maxElevation': instance.maxElevation,
      'totalElevationGain': instance.totalElevationGain,
      'totalElevationLoss': instance.totalElevationLoss,
      'preview_image': instance.previewImage,
      'preview_image_key': instance.previewImageKey,
    };
