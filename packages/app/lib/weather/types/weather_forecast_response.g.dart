// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherForecastResponse _$WeatherForecastResponseFromJson(
  Map<String, dynamic> json,
) => _WeatherForecastResponse(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  generationTimeMs: (json['generationtime_ms'] as num).toDouble(),
  utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
  timezone: json['timezone'] as String,
  timezoneAbbreviation: json['timezone_abbreviation'] as String,
  elevation: (json['elevation'] as num).toDouble(),
  hourlyUnits: HourlyUnits.fromJson(
    json['hourly_units'] as Map<String, dynamic>,
  ),
  hourly: Hourly.fromJson(json['hourly'] as Map<String, dynamic>),
  dailyUnits: DailyUnits.fromJson(json['daily_units'] as Map<String, dynamic>),
  daily: Daily.fromJson(json['daily'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherForecastResponseToJson(
  _WeatherForecastResponse instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'generationtime_ms': instance.generationTimeMs,
  'utc_offset_seconds': instance.utcOffsetSeconds,
  'timezone': instance.timezone,
  'timezone_abbreviation': instance.timezoneAbbreviation,
  'elevation': instance.elevation,
  'hourly_units': instance.hourlyUnits,
  'hourly': instance.hourly,
  'daily_units': instance.dailyUnits,
  'daily': instance.daily,
};

_HourlyUnits _$HourlyUnitsFromJson(Map<String, dynamic> json) => _HourlyUnits(
  time: json['time'] as String,
  temperature2m: json['temperature_2m'] as String,
  weatherCode: json['weather_code'] as String,
);

Map<String, dynamic> _$HourlyUnitsToJson(_HourlyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature2m,
      'weather_code': instance.weatherCode,
    };

_Hourly _$HourlyFromJson(Map<String, dynamic> json) => _Hourly(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature2m:
      (json['temperature_2m'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
  weatherCode:
      (json['weather_code'] as List<dynamic>)
          .map((e) => (e as num?)?.toInt())
          .toList(),
);

Map<String, dynamic> _$HourlyToJson(_Hourly instance) => <String, dynamic>{
  'time': instance.time,
  'temperature_2m': instance.temperature2m,
  'weather_code': instance.weatherCode,
};

_DailyUnits _$DailyUnitsFromJson(Map<String, dynamic> json) => _DailyUnits(
  time: json['time'] as String,
  weatherCode: json['weather_code'] as String,
  temperature2mMax: json['temperature_2m_max'] as String,
  temperature2mMin: json['temperature_2m_min'] as String,
  sunrise: json['sunrise'] as String,
  sunset: json['sunset'] as String,
);

Map<String, dynamic> _$DailyUnitsToJson(_DailyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'weather_code': instance.weatherCode,
      'temperature_2m_max': instance.temperature2mMax,
      'temperature_2m_min': instance.temperature2mMin,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };

_Daily _$DailyFromJson(Map<String, dynamic> json) => _Daily(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  weatherCode:
      (json['weather_code'] as List<dynamic>)
          .map((e) => (e as num?)?.toInt())
          .toList(),
  temperature2mMax:
      (json['temperature_2m_max'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
  temperature2mMin:
      (json['temperature_2m_min'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
  sunrise: (json['sunrise'] as List<dynamic>).map((e) => e as String?).toList(),
  sunset: (json['sunset'] as List<dynamic>).map((e) => e as String?).toList(),
);

Map<String, dynamic> _$DailyToJson(_Daily instance) => <String, dynamic>{
  'time': instance.time,
  'weather_code': instance.weatherCode,
  'temperature_2m_max': instance.temperature2mMax,
  'temperature_2m_min': instance.temperature2mMin,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};
