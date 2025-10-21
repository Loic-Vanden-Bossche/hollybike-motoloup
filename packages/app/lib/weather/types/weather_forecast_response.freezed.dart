// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_forecast_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherForecastResponse {

 double get latitude; double get longitude;@JsonKey(name: 'generationtime_ms') double get generationTimeMs;@JsonKey(name: 'utc_offset_seconds') int get utcOffsetSeconds; String get timezone;@JsonKey(name: 'timezone_abbreviation') String get timezoneAbbreviation; double get elevation;@JsonKey(name: 'hourly_units') HourlyUnits get hourlyUnits; Hourly get hourly;@JsonKey(name: 'daily_units') DailyUnits get dailyUnits; Daily get daily;
/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherForecastResponseCopyWith<WeatherForecastResponse> get copyWith => _$WeatherForecastResponseCopyWithImpl<WeatherForecastResponse>(this as WeatherForecastResponse, _$identity);

  /// Serializes this WeatherForecastResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherForecastResponse&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationTimeMs, generationTimeMs) || other.generationTimeMs == generationTimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.hourlyUnits, hourlyUnits) || other.hourlyUnits == hourlyUnits)&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationTimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,hourlyUnits,hourly,dailyUnits,daily);

@override
String toString() {
  return 'WeatherForecastResponse(latitude: $latitude, longitude: $longitude, generationTimeMs: $generationTimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, hourlyUnits: $hourlyUnits, hourly: $hourly, dailyUnits: $dailyUnits, daily: $daily)';
}


}

/// @nodoc
abstract mixin class $WeatherForecastResponseCopyWith<$Res>  {
  factory $WeatherForecastResponseCopyWith(WeatherForecastResponse value, $Res Function(WeatherForecastResponse) _then) = _$WeatherForecastResponseCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationTimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits, Hourly hourly,@JsonKey(name: 'daily_units') DailyUnits dailyUnits, Daily daily
});


$HourlyUnitsCopyWith<$Res> get hourlyUnits;$HourlyCopyWith<$Res> get hourly;$DailyUnitsCopyWith<$Res> get dailyUnits;$DailyCopyWith<$Res> get daily;

}
/// @nodoc
class _$WeatherForecastResponseCopyWithImpl<$Res>
    implements $WeatherForecastResponseCopyWith<$Res> {
  _$WeatherForecastResponseCopyWithImpl(this._self, this._then);

  final WeatherForecastResponse _self;
  final $Res Function(WeatherForecastResponse) _then;

/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? generationTimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? hourlyUnits = null,Object? hourly = null,Object? dailyUnits = null,Object? daily = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationTimeMs: null == generationTimeMs ? _self.generationTimeMs : generationTimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,hourlyUnits: null == hourlyUnits ? _self.hourlyUnits : hourlyUnits // ignore: cast_nullable_to_non_nullable
as HourlyUnits,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as Hourly,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as DailyUnits,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as Daily,
  ));
}
/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<$Res> get hourlyUnits {
  
  return $HourlyUnitsCopyWith<$Res>(_self.hourlyUnits, (value) {
    return _then(_self.copyWith(hourlyUnits: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyCopyWith<$Res> get hourly {
  
  return $HourlyCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<$Res> get dailyUnits {
  
  return $DailyUnitsCopyWith<$Res>(_self.dailyUnits, (value) {
    return _then(_self.copyWith(dailyUnits: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCopyWith<$Res> get daily {
  
  return $DailyCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeatherForecastResponse].
extension WeatherForecastResponsePatterns on WeatherForecastResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherForecastResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherForecastResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherForecastResponse value)  $default,){
final _that = this;
switch (_that) {
case _WeatherForecastResponse():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherForecastResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherForecastResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherForecastResponse() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.hourlyUnits,_that.hourly,_that.dailyUnits,_that.daily);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)  $default,) {final _that = this;
switch (_that) {
case _WeatherForecastResponse():
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.hourlyUnits,_that.hourly,_that.dailyUnits,_that.daily);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude, @JsonKey(name: 'generationtime_ms')  double generationTimeMs, @JsonKey(name: 'utc_offset_seconds')  int utcOffsetSeconds,  String timezone, @JsonKey(name: 'timezone_abbreviation')  String timezoneAbbreviation,  double elevation, @JsonKey(name: 'hourly_units')  HourlyUnits hourlyUnits,  Hourly hourly, @JsonKey(name: 'daily_units')  DailyUnits dailyUnits,  Daily daily)?  $default,) {final _that = this;
switch (_that) {
case _WeatherForecastResponse() when $default != null:
return $default(_that.latitude,_that.longitude,_that.generationTimeMs,_that.utcOffsetSeconds,_that.timezone,_that.timezoneAbbreviation,_that.elevation,_that.hourlyUnits,_that.hourly,_that.dailyUnits,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherForecastResponse implements WeatherForecastResponse {
  const _WeatherForecastResponse({required this.latitude, required this.longitude, @JsonKey(name: 'generationtime_ms') required this.generationTimeMs, @JsonKey(name: 'utc_offset_seconds') required this.utcOffsetSeconds, required this.timezone, @JsonKey(name: 'timezone_abbreviation') required this.timezoneAbbreviation, required this.elevation, @JsonKey(name: 'hourly_units') required this.hourlyUnits, required this.hourly, @JsonKey(name: 'daily_units') required this.dailyUnits, required this.daily});
  factory _WeatherForecastResponse.fromJson(Map<String, dynamic> json) => _$WeatherForecastResponseFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'generationtime_ms') final  double generationTimeMs;
@override@JsonKey(name: 'utc_offset_seconds') final  int utcOffsetSeconds;
@override final  String timezone;
@override@JsonKey(name: 'timezone_abbreviation') final  String timezoneAbbreviation;
@override final  double elevation;
@override@JsonKey(name: 'hourly_units') final  HourlyUnits hourlyUnits;
@override final  Hourly hourly;
@override@JsonKey(name: 'daily_units') final  DailyUnits dailyUnits;
@override final  Daily daily;

/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherForecastResponseCopyWith<_WeatherForecastResponse> get copyWith => __$WeatherForecastResponseCopyWithImpl<_WeatherForecastResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherForecastResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherForecastResponse&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.generationTimeMs, generationTimeMs) || other.generationTimeMs == generationTimeMs)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.timezoneAbbreviation, timezoneAbbreviation) || other.timezoneAbbreviation == timezoneAbbreviation)&&(identical(other.elevation, elevation) || other.elevation == elevation)&&(identical(other.hourlyUnits, hourlyUnits) || other.hourlyUnits == hourlyUnits)&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.dailyUnits, dailyUnits) || other.dailyUnits == dailyUnits)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,generationTimeMs,utcOffsetSeconds,timezone,timezoneAbbreviation,elevation,hourlyUnits,hourly,dailyUnits,daily);

@override
String toString() {
  return 'WeatherForecastResponse(latitude: $latitude, longitude: $longitude, generationTimeMs: $generationTimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, hourlyUnits: $hourlyUnits, hourly: $hourly, dailyUnits: $dailyUnits, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$WeatherForecastResponseCopyWith<$Res> implements $WeatherForecastResponseCopyWith<$Res> {
  factory _$WeatherForecastResponseCopyWith(_WeatherForecastResponse value, $Res Function(_WeatherForecastResponse) _then) = __$WeatherForecastResponseCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude,@JsonKey(name: 'generationtime_ms') double generationTimeMs,@JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds, String timezone,@JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation, double elevation,@JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits, Hourly hourly,@JsonKey(name: 'daily_units') DailyUnits dailyUnits, Daily daily
});


@override $HourlyUnitsCopyWith<$Res> get hourlyUnits;@override $HourlyCopyWith<$Res> get hourly;@override $DailyUnitsCopyWith<$Res> get dailyUnits;@override $DailyCopyWith<$Res> get daily;

}
/// @nodoc
class __$WeatherForecastResponseCopyWithImpl<$Res>
    implements _$WeatherForecastResponseCopyWith<$Res> {
  __$WeatherForecastResponseCopyWithImpl(this._self, this._then);

  final _WeatherForecastResponse _self;
  final $Res Function(_WeatherForecastResponse) _then;

/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? generationTimeMs = null,Object? utcOffsetSeconds = null,Object? timezone = null,Object? timezoneAbbreviation = null,Object? elevation = null,Object? hourlyUnits = null,Object? hourly = null,Object? dailyUnits = null,Object? daily = null,}) {
  return _then(_WeatherForecastResponse(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,generationTimeMs: null == generationTimeMs ? _self.generationTimeMs : generationTimeMs // ignore: cast_nullable_to_non_nullable
as double,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,timezoneAbbreviation: null == timezoneAbbreviation ? _self.timezoneAbbreviation : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
as String,elevation: null == elevation ? _self.elevation : elevation // ignore: cast_nullable_to_non_nullable
as double,hourlyUnits: null == hourlyUnits ? _self.hourlyUnits : hourlyUnits // ignore: cast_nullable_to_non_nullable
as HourlyUnits,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as Hourly,dailyUnits: null == dailyUnits ? _self.dailyUnits : dailyUnits // ignore: cast_nullable_to_non_nullable
as DailyUnits,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as Daily,
  ));
}

/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<$Res> get hourlyUnits {
  
  return $HourlyUnitsCopyWith<$Res>(_self.hourlyUnits, (value) {
    return _then(_self.copyWith(hourlyUnits: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlyCopyWith<$Res> get hourly {
  
  return $HourlyCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<$Res> get dailyUnits {
  
  return $DailyUnitsCopyWith<$Res>(_self.dailyUnits, (value) {
    return _then(_self.copyWith(dailyUnits: value));
  });
}/// Create a copy of WeatherForecastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyCopyWith<$Res> get daily {
  
  return $DailyCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// @nodoc
mixin _$HourlyUnits {

 String get time;@JsonKey(name: 'temperature_2m') String get temperature2m;@JsonKey(name: 'weather_code') String get weatherCode;
/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyUnitsCopyWith<HourlyUnits> get copyWith => _$HourlyUnitsCopyWithImpl<HourlyUnits>(this as HourlyUnits, _$identity);

  /// Serializes this HourlyUnits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2m, temperature2m) || other.temperature2m == temperature2m)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2m,weatherCode);

@override
String toString() {
  return 'HourlyUnits(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class $HourlyUnitsCopyWith<$Res>  {
  factory $HourlyUnitsCopyWith(HourlyUnits value, $Res Function(HourlyUnits) _then) = _$HourlyUnitsCopyWithImpl;
@useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m') String temperature2m,@JsonKey(name: 'weather_code') String weatherCode
});




}
/// @nodoc
class _$HourlyUnitsCopyWithImpl<$Res>
    implements $HourlyUnitsCopyWith<$Res> {
  _$HourlyUnitsCopyWithImpl(this._self, this._then);

  final HourlyUnits _self;
  final $Res Function(HourlyUnits) _then;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2m = null,Object? weatherCode = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as String,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyUnits].
extension HourlyUnitsPatterns on HourlyUnits {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyUnits value)  $default,){
final _that = this;
switch (_that) {
case _HourlyUnits():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyUnits value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m, @JsonKey(name: 'weather_code')  String weatherCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that.time,_that.temperature2m,_that.weatherCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m, @JsonKey(name: 'weather_code')  String weatherCode)  $default,) {final _that = this;
switch (_that) {
case _HourlyUnits():
return $default(_that.time,_that.temperature2m,_that.weatherCode);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time, @JsonKey(name: 'temperature_2m')  String temperature2m, @JsonKey(name: 'weather_code')  String weatherCode)?  $default,) {final _that = this;
switch (_that) {
case _HourlyUnits() when $default != null:
return $default(_that.time,_that.temperature2m,_that.weatherCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyUnits implements HourlyUnits {
  const _HourlyUnits({required this.time, @JsonKey(name: 'temperature_2m') required this.temperature2m, @JsonKey(name: 'weather_code') required this.weatherCode});
  factory _HourlyUnits.fromJson(Map<String, dynamic> json) => _$HourlyUnitsFromJson(json);

@override final  String time;
@override@JsonKey(name: 'temperature_2m') final  String temperature2m;
@override@JsonKey(name: 'weather_code') final  String weatherCode;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyUnitsCopyWith<_HourlyUnits> get copyWith => __$HourlyUnitsCopyWithImpl<_HourlyUnits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyUnitsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature2m, temperature2m) || other.temperature2m == temperature2m)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature2m,weatherCode);

@override
String toString() {
  return 'HourlyUnits(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class _$HourlyUnitsCopyWith<$Res> implements $HourlyUnitsCopyWith<$Res> {
  factory _$HourlyUnitsCopyWith(_HourlyUnits value, $Res Function(_HourlyUnits) _then) = __$HourlyUnitsCopyWithImpl;
@override @useResult
$Res call({
 String time,@JsonKey(name: 'temperature_2m') String temperature2m,@JsonKey(name: 'weather_code') String weatherCode
});




}
/// @nodoc
class __$HourlyUnitsCopyWithImpl<$Res>
    implements _$HourlyUnitsCopyWith<$Res> {
  __$HourlyUnitsCopyWithImpl(this._self, this._then);

  final _HourlyUnits _self;
  final $Res Function(_HourlyUnits) _then;

/// Create a copy of HourlyUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2m = null,Object? weatherCode = null,}) {
  return _then(_HourlyUnits(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as String,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Hourly {

 List<String> get time;@JsonKey(name: 'temperature_2m') List<double?> get temperature2m;@JsonKey(name: 'weather_code') List<int?> get weatherCode;
/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyCopyWith<Hourly> get copyWith => _$HourlyCopyWithImpl<Hourly>(this as Hourly, _$identity);

  /// Serializes this Hourly to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hourly&&const DeepCollectionEquality().equals(other.time, time)&&const DeepCollectionEquality().equals(other.temperature2m, temperature2m)&&const DeepCollectionEquality().equals(other.weatherCode, weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(time),const DeepCollectionEquality().hash(temperature2m),const DeepCollectionEquality().hash(weatherCode));

@override
String toString() {
  return 'Hourly(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class $HourlyCopyWith<$Res>  {
  factory $HourlyCopyWith(Hourly value, $Res Function(Hourly) _then) = _$HourlyCopyWithImpl;
@useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m') List<double?> temperature2m,@JsonKey(name: 'weather_code') List<int?> weatherCode
});




}
/// @nodoc
class _$HourlyCopyWithImpl<$Res>
    implements $HourlyCopyWith<$Res> {
  _$HourlyCopyWithImpl(this._self, this._then);

  final Hourly _self;
  final $Res Function(Hourly) _then;

/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature2m = null,Object? weatherCode = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2m: null == temperature2m ? _self.temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as List<double?>,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as List<int?>,
  ));
}

}


/// Adds pattern-matching-related methods to [Hourly].
extension HourlyPatterns on Hourly {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hourly value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hourly value)  $default,){
final _that = this;
switch (_that) {
case _Hourly():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hourly value)?  $default,){
final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double?> temperature2m, @JsonKey(name: 'weather_code')  List<int?> weatherCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that.time,_that.temperature2m,_that.weatherCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double?> temperature2m, @JsonKey(name: 'weather_code')  List<int?> weatherCode)  $default,) {final _that = this;
switch (_that) {
case _Hourly():
return $default(_that.time,_that.temperature2m,_that.weatherCode);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> time, @JsonKey(name: 'temperature_2m')  List<double?> temperature2m, @JsonKey(name: 'weather_code')  List<int?> weatherCode)?  $default,) {final _that = this;
switch (_that) {
case _Hourly() when $default != null:
return $default(_that.time,_that.temperature2m,_that.weatherCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hourly implements Hourly {
  const _Hourly({required final  List<String> time, @JsonKey(name: 'temperature_2m') required final  List<double?> temperature2m, @JsonKey(name: 'weather_code') required final  List<int?> weatherCode}): _time = time,_temperature2m = temperature2m,_weatherCode = weatherCode;
  factory _Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

 final  List<String> _time;
@override List<String> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<double?> _temperature2m;
@override@JsonKey(name: 'temperature_2m') List<double?> get temperature2m {
  if (_temperature2m is EqualUnmodifiableListView) return _temperature2m;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2m);
}

 final  List<int?> _weatherCode;
@override@JsonKey(name: 'weather_code') List<int?> get weatherCode {
  if (_weatherCode is EqualUnmodifiableListView) return _weatherCode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weatherCode);
}


/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyCopyWith<_Hourly> get copyWith => __$HourlyCopyWithImpl<_Hourly>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hourly&&const DeepCollectionEquality().equals(other._time, _time)&&const DeepCollectionEquality().equals(other._temperature2m, _temperature2m)&&const DeepCollectionEquality().equals(other._weatherCode, _weatherCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_temperature2m),const DeepCollectionEquality().hash(_weatherCode));

@override
String toString() {
  return 'Hourly(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
}


}

/// @nodoc
abstract mixin class _$HourlyCopyWith<$Res> implements $HourlyCopyWith<$Res> {
  factory _$HourlyCopyWith(_Hourly value, $Res Function(_Hourly) _then) = __$HourlyCopyWithImpl;
@override @useResult
$Res call({
 List<String> time,@JsonKey(name: 'temperature_2m') List<double?> temperature2m,@JsonKey(name: 'weather_code') List<int?> weatherCode
});




}
/// @nodoc
class __$HourlyCopyWithImpl<$Res>
    implements _$HourlyCopyWith<$Res> {
  __$HourlyCopyWithImpl(this._self, this._then);

  final _Hourly _self;
  final $Res Function(_Hourly) _then;

/// Create a copy of Hourly
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature2m = null,Object? weatherCode = null,}) {
  return _then(_Hourly(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<String>,temperature2m: null == temperature2m ? _self._temperature2m : temperature2m // ignore: cast_nullable_to_non_nullable
as List<double?>,weatherCode: null == weatherCode ? _self._weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as List<int?>,
  ));
}


}


/// @nodoc
mixin _$DailyUnits {

 String get time;@JsonKey(name: 'weather_code') String get weatherCode;@JsonKey(name: 'temperature_2m_max') String get temperature2mMax;@JsonKey(name: 'temperature_2m_min') String get temperature2mMin;@JsonKey(name: 'sunrise') String get sunrise;@JsonKey(name: 'sunset') String get sunset;
/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyUnitsCopyWith<DailyUnits> get copyWith => _$DailyUnitsCopyWithImpl<DailyUnits>(this as DailyUnits, _$identity);

  /// Serializes this DailyUnits to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.temperature2mMax, temperature2mMax) || other.temperature2mMax == temperature2mMax)&&(identical(other.temperature2mMin, temperature2mMin) || other.temperature2mMin == temperature2mMin)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,weatherCode,temperature2mMax,temperature2mMin,sunrise,sunset);

@override
String toString() {
  return 'DailyUnits(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class $DailyUnitsCopyWith<$Res>  {
  factory $DailyUnitsCopyWith(DailyUnits value, $Res Function(DailyUnits) _then) = _$DailyUnitsCopyWithImpl;
@useResult
$Res call({
 String time,@JsonKey(name: 'weather_code') String weatherCode,@JsonKey(name: 'temperature_2m_max') String temperature2mMax,@JsonKey(name: 'temperature_2m_min') String temperature2mMin,@JsonKey(name: 'sunrise') String sunrise,@JsonKey(name: 'sunset') String sunset
});




}
/// @nodoc
class _$DailyUnitsCopyWithImpl<$Res>
    implements $DailyUnitsCopyWith<$Res> {
  _$DailyUnitsCopyWithImpl(this._self, this._then);

  final DailyUnits _self;
  final $Res Function(DailyUnits) _then;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? weatherCode = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as String,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as String,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as String,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as String,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyUnits].
extension DailyUnitsPatterns on DailyUnits {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyUnits value)  $default,){
final _that = this;
switch (_that) {
case _DailyUnits():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyUnits value)?  $default,){
final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'weather_code')  String weatherCode, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'sunrise')  String sunrise, @JsonKey(name: 'sunset')  String sunset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String time, @JsonKey(name: 'weather_code')  String weatherCode, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'sunrise')  String sunrise, @JsonKey(name: 'sunset')  String sunset)  $default,) {final _that = this;
switch (_that) {
case _DailyUnits():
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String time, @JsonKey(name: 'weather_code')  String weatherCode, @JsonKey(name: 'temperature_2m_max')  String temperature2mMax, @JsonKey(name: 'temperature_2m_min')  String temperature2mMin, @JsonKey(name: 'sunrise')  String sunrise, @JsonKey(name: 'sunset')  String sunset)?  $default,) {final _that = this;
switch (_that) {
case _DailyUnits() when $default != null:
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyUnits implements DailyUnits {
  const _DailyUnits({required this.time, @JsonKey(name: 'weather_code') required this.weatherCode, @JsonKey(name: 'temperature_2m_max') required this.temperature2mMax, @JsonKey(name: 'temperature_2m_min') required this.temperature2mMin, @JsonKey(name: 'sunrise') required this.sunrise, @JsonKey(name: 'sunset') required this.sunset});
  factory _DailyUnits.fromJson(Map<String, dynamic> json) => _$DailyUnitsFromJson(json);

@override final  String time;
@override@JsonKey(name: 'weather_code') final  String weatherCode;
@override@JsonKey(name: 'temperature_2m_max') final  String temperature2mMax;
@override@JsonKey(name: 'temperature_2m_min') final  String temperature2mMin;
@override@JsonKey(name: 'sunrise') final  String sunrise;
@override@JsonKey(name: 'sunset') final  String sunset;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyUnitsCopyWith<_DailyUnits> get copyWith => __$DailyUnitsCopyWithImpl<_DailyUnits>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyUnitsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyUnits&&(identical(other.time, time) || other.time == time)&&(identical(other.weatherCode, weatherCode) || other.weatherCode == weatherCode)&&(identical(other.temperature2mMax, temperature2mMax) || other.temperature2mMax == temperature2mMax)&&(identical(other.temperature2mMin, temperature2mMin) || other.temperature2mMin == temperature2mMin)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,weatherCode,temperature2mMax,temperature2mMin,sunrise,sunset);

@override
String toString() {
  return 'DailyUnits(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class _$DailyUnitsCopyWith<$Res> implements $DailyUnitsCopyWith<$Res> {
  factory _$DailyUnitsCopyWith(_DailyUnits value, $Res Function(_DailyUnits) _then) = __$DailyUnitsCopyWithImpl;
@override @useResult
$Res call({
 String time,@JsonKey(name: 'weather_code') String weatherCode,@JsonKey(name: 'temperature_2m_max') String temperature2mMax,@JsonKey(name: 'temperature_2m_min') String temperature2mMin,@JsonKey(name: 'sunrise') String sunrise,@JsonKey(name: 'sunset') String sunset
});




}
/// @nodoc
class __$DailyUnitsCopyWithImpl<$Res>
    implements _$DailyUnitsCopyWith<$Res> {
  __$DailyUnitsCopyWithImpl(this._self, this._then);

  final _DailyUnits _self;
  final $Res Function(_DailyUnits) _then;

/// Create a copy of DailyUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? weatherCode = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_DailyUnits(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as String,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as String,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as String,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as String,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Daily {

 List<String> get time;@JsonKey(name: 'weather_code') List<int?> get weatherCode;@JsonKey(name: 'temperature_2m_max') List<double?> get temperature2mMax;@JsonKey(name: 'temperature_2m_min') List<double?> get temperature2mMin;@JsonKey(name: 'sunrise') List<String?> get sunrise;@JsonKey(name: 'sunset') List<String?> get sunset;
/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyCopyWith<Daily> get copyWith => _$DailyCopyWithImpl<Daily>(this as Daily, _$identity);

  /// Serializes this Daily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Daily&&const DeepCollectionEquality().equals(other.time, time)&&const DeepCollectionEquality().equals(other.weatherCode, weatherCode)&&const DeepCollectionEquality().equals(other.temperature2mMax, temperature2mMax)&&const DeepCollectionEquality().equals(other.temperature2mMin, temperature2mMin)&&const DeepCollectionEquality().equals(other.sunrise, sunrise)&&const DeepCollectionEquality().equals(other.sunset, sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(time),const DeepCollectionEquality().hash(weatherCode),const DeepCollectionEquality().hash(temperature2mMax),const DeepCollectionEquality().hash(temperature2mMin),const DeepCollectionEquality().hash(sunrise),const DeepCollectionEquality().hash(sunset));

@override
String toString() {
  return 'Daily(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class $DailyCopyWith<$Res>  {
  factory $DailyCopyWith(Daily value, $Res Function(Daily) _then) = _$DailyCopyWithImpl;
@useResult
$Res call({
 List<String> time,@JsonKey(name: 'weather_code') List<int?> weatherCode,@JsonKey(name: 'temperature_2m_max') List<double?> temperature2mMax,@JsonKey(name: 'temperature_2m_min') List<double?> temperature2mMin,@JsonKey(name: 'sunrise') List<String?> sunrise,@JsonKey(name: 'sunset') List<String?> sunset
});




}
/// @nodoc
class _$DailyCopyWithImpl<$Res>
    implements $DailyCopyWith<$Res> {
  _$DailyCopyWithImpl(this._self, this._then);

  final Daily _self;
  final $Res Function(Daily) _then;

/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? weatherCode = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<String>,weatherCode: null == weatherCode ? _self.weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as List<int?>,temperature2mMax: null == temperature2mMax ? _self.temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as List<double?>,temperature2mMin: null == temperature2mMin ? _self.temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as List<double?>,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as List<String?>,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as List<String?>,
  ));
}

}


/// Adds pattern-matching-related methods to [Daily].
extension DailyPatterns on Daily {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Daily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Daily value)  $default,){
final _that = this;
switch (_that) {
case _Daily():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Daily value)?  $default,){
final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'weather_code')  List<int?> weatherCode, @JsonKey(name: 'temperature_2m_max')  List<double?> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double?> temperature2mMin, @JsonKey(name: 'sunrise')  List<String?> sunrise, @JsonKey(name: 'sunset')  List<String?> sunset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> time, @JsonKey(name: 'weather_code')  List<int?> weatherCode, @JsonKey(name: 'temperature_2m_max')  List<double?> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double?> temperature2mMin, @JsonKey(name: 'sunrise')  List<String?> sunrise, @JsonKey(name: 'sunset')  List<String?> sunset)  $default,) {final _that = this;
switch (_that) {
case _Daily():
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> time, @JsonKey(name: 'weather_code')  List<int?> weatherCode, @JsonKey(name: 'temperature_2m_max')  List<double?> temperature2mMax, @JsonKey(name: 'temperature_2m_min')  List<double?> temperature2mMin, @JsonKey(name: 'sunrise')  List<String?> sunrise, @JsonKey(name: 'sunset')  List<String?> sunset)?  $default,) {final _that = this;
switch (_that) {
case _Daily() when $default != null:
return $default(_that.time,_that.weatherCode,_that.temperature2mMax,_that.temperature2mMin,_that.sunrise,_that.sunset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Daily implements Daily {
  const _Daily({required final  List<String> time, @JsonKey(name: 'weather_code') required final  List<int?> weatherCode, @JsonKey(name: 'temperature_2m_max') required final  List<double?> temperature2mMax, @JsonKey(name: 'temperature_2m_min') required final  List<double?> temperature2mMin, @JsonKey(name: 'sunrise') required final  List<String?> sunrise, @JsonKey(name: 'sunset') required final  List<String?> sunset}): _time = time,_weatherCode = weatherCode,_temperature2mMax = temperature2mMax,_temperature2mMin = temperature2mMin,_sunrise = sunrise,_sunset = sunset;
  factory _Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

 final  List<String> _time;
@override List<String> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<int?> _weatherCode;
@override@JsonKey(name: 'weather_code') List<int?> get weatherCode {
  if (_weatherCode is EqualUnmodifiableListView) return _weatherCode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weatherCode);
}

 final  List<double?> _temperature2mMax;
@override@JsonKey(name: 'temperature_2m_max') List<double?> get temperature2mMax {
  if (_temperature2mMax is EqualUnmodifiableListView) return _temperature2mMax;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2mMax);
}

 final  List<double?> _temperature2mMin;
@override@JsonKey(name: 'temperature_2m_min') List<double?> get temperature2mMin {
  if (_temperature2mMin is EqualUnmodifiableListView) return _temperature2mMin;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperature2mMin);
}

 final  List<String?> _sunrise;
@override@JsonKey(name: 'sunrise') List<String?> get sunrise {
  if (_sunrise is EqualUnmodifiableListView) return _sunrise;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sunrise);
}

 final  List<String?> _sunset;
@override@JsonKey(name: 'sunset') List<String?> get sunset {
  if (_sunset is EqualUnmodifiableListView) return _sunset;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sunset);
}


/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyCopyWith<_Daily> get copyWith => __$DailyCopyWithImpl<_Daily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Daily&&const DeepCollectionEquality().equals(other._time, _time)&&const DeepCollectionEquality().equals(other._weatherCode, _weatherCode)&&const DeepCollectionEquality().equals(other._temperature2mMax, _temperature2mMax)&&const DeepCollectionEquality().equals(other._temperature2mMin, _temperature2mMin)&&const DeepCollectionEquality().equals(other._sunrise, _sunrise)&&const DeepCollectionEquality().equals(other._sunset, _sunset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_weatherCode),const DeepCollectionEquality().hash(_temperature2mMax),const DeepCollectionEquality().hash(_temperature2mMin),const DeepCollectionEquality().hash(_sunrise),const DeepCollectionEquality().hash(_sunset));

@override
String toString() {
  return 'Daily(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin, sunrise: $sunrise, sunset: $sunset)';
}


}

/// @nodoc
abstract mixin class _$DailyCopyWith<$Res> implements $DailyCopyWith<$Res> {
  factory _$DailyCopyWith(_Daily value, $Res Function(_Daily) _then) = __$DailyCopyWithImpl;
@override @useResult
$Res call({
 List<String> time,@JsonKey(name: 'weather_code') List<int?> weatherCode,@JsonKey(name: 'temperature_2m_max') List<double?> temperature2mMax,@JsonKey(name: 'temperature_2m_min') List<double?> temperature2mMin,@JsonKey(name: 'sunrise') List<String?> sunrise,@JsonKey(name: 'sunset') List<String?> sunset
});




}
/// @nodoc
class __$DailyCopyWithImpl<$Res>
    implements _$DailyCopyWith<$Res> {
  __$DailyCopyWithImpl(this._self, this._then);

  final _Daily _self;
  final $Res Function(_Daily) _then;

/// Create a copy of Daily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? weatherCode = null,Object? temperature2mMax = null,Object? temperature2mMin = null,Object? sunrise = null,Object? sunset = null,}) {
  return _then(_Daily(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<String>,weatherCode: null == weatherCode ? _self._weatherCode : weatherCode // ignore: cast_nullable_to_non_nullable
as List<int?>,temperature2mMax: null == temperature2mMax ? _self._temperature2mMax : temperature2mMax // ignore: cast_nullable_to_non_nullable
as List<double?>,temperature2mMin: null == temperature2mMin ? _self._temperature2mMin : temperature2mMin // ignore: cast_nullable_to_non_nullable
as List<double?>,sunrise: null == sunrise ? _self._sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as List<String?>,sunset: null == sunset ? _self._sunset : sunset // ignore: cast_nullable_to_non_nullable
as List<String?>,
  ));
}


}

// dart format on
