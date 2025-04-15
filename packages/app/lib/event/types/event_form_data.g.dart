// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventFormData _$EventFormDataFromJson(Map<String, dynamic> json) =>
    _EventFormData(
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate:
          json['end_date'] == null
              ? null
              : DateTime.parse(json['end_date'] as String),
      budget: (json['budget'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventFormDataToJson(_EventFormData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'start_date': dateToJson(instance.startDate),
      'end_date': dateToJson(instance.endDate),
      'budget': instance.budget,
    };
