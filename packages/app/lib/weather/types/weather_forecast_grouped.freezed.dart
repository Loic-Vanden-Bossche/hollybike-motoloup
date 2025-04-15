// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_forecast_grouped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherForecastGrouped {

 List<DailyWeatherGrouped> get dailyWeather;
/// Create a copy of WeatherForecastGrouped
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherForecastGroupedCopyWith<WeatherForecastGrouped> get copyWith => _$WeatherForecastGroupedCopyWithImpl<WeatherForecastGrouped>(this as WeatherForecastGrouped, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherForecastGrouped&&const DeepCollectionEquality().equals(other.dailyWeather, dailyWeather));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dailyWeather));

@override
String toString() {
  return 'WeatherForecastGrouped(dailyWeather: $dailyWeather)';
}


}

/// @nodoc
abstract mixin class $WeatherForecastGroupedCopyWith<$Res>  {
  factory $WeatherForecastGroupedCopyWith(WeatherForecastGrouped value, $Res Function(WeatherForecastGrouped) _then) = _$WeatherForecastGroupedCopyWithImpl;
@useResult
$Res call({
 List<DailyWeatherGrouped> dailyWeather
});




}
/// @nodoc
class _$WeatherForecastGroupedCopyWithImpl<$Res>
    implements $WeatherForecastGroupedCopyWith<$Res> {
  _$WeatherForecastGroupedCopyWithImpl(this._self, this._then);

  final WeatherForecastGrouped _self;
  final $Res Function(WeatherForecastGrouped) _then;

/// Create a copy of WeatherForecastGrouped
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyWeather = null,}) {
  return _then(_self.copyWith(
dailyWeather: null == dailyWeather ? _self.dailyWeather : dailyWeather // ignore: cast_nullable_to_non_nullable
as List<DailyWeatherGrouped>,
  ));
}

}


/// @nodoc


class _WeatherForecastGrouped implements WeatherForecastGrouped {
  const _WeatherForecastGrouped({required final  List<DailyWeatherGrouped> dailyWeather}): _dailyWeather = dailyWeather;
  

 final  List<DailyWeatherGrouped> _dailyWeather;
@override List<DailyWeatherGrouped> get dailyWeather {
  if (_dailyWeather is EqualUnmodifiableListView) return _dailyWeather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyWeather);
}


/// Create a copy of WeatherForecastGrouped
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherForecastGroupedCopyWith<_WeatherForecastGrouped> get copyWith => __$WeatherForecastGroupedCopyWithImpl<_WeatherForecastGrouped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherForecastGrouped&&const DeepCollectionEquality().equals(other._dailyWeather, _dailyWeather));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dailyWeather));

@override
String toString() {
  return 'WeatherForecastGrouped(dailyWeather: $dailyWeather)';
}


}

/// @nodoc
abstract mixin class _$WeatherForecastGroupedCopyWith<$Res> implements $WeatherForecastGroupedCopyWith<$Res> {
  factory _$WeatherForecastGroupedCopyWith(_WeatherForecastGrouped value, $Res Function(_WeatherForecastGrouped) _then) = __$WeatherForecastGroupedCopyWithImpl;
@override @useResult
$Res call({
 List<DailyWeatherGrouped> dailyWeather
});




}
/// @nodoc
class __$WeatherForecastGroupedCopyWithImpl<$Res>
    implements _$WeatherForecastGroupedCopyWith<$Res> {
  __$WeatherForecastGroupedCopyWithImpl(this._self, this._then);

  final _WeatherForecastGrouped _self;
  final $Res Function(_WeatherForecastGrouped) _then;

/// Create a copy of WeatherForecastGrouped
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyWeather = null,}) {
  return _then(_WeatherForecastGrouped(
dailyWeather: null == dailyWeather ? _self._dailyWeather : dailyWeather // ignore: cast_nullable_to_non_nullable
as List<DailyWeatherGrouped>,
  ));
}


}

/// @nodoc
mixin _$DailyWeatherGrouped {

 String get date; String get maxTemperature; String get minTemperature; WeatherCondition get weatherCondition; List<HourlyWeather> get hourlyWeather;
/// Create a copy of DailyWeatherGrouped
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyWeatherGroupedCopyWith<DailyWeatherGrouped> get copyWith => _$DailyWeatherGroupedCopyWithImpl<DailyWeatherGrouped>(this as DailyWeatherGrouped, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyWeatherGrouped&&(identical(other.date, date) || other.date == date)&&(identical(other.maxTemperature, maxTemperature) || other.maxTemperature == maxTemperature)&&(identical(other.minTemperature, minTemperature) || other.minTemperature == minTemperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&const DeepCollectionEquality().equals(other.hourlyWeather, hourlyWeather));
}


@override
int get hashCode => Object.hash(runtimeType,date,maxTemperature,minTemperature,weatherCondition,const DeepCollectionEquality().hash(hourlyWeather));

@override
String toString() {
  return 'DailyWeatherGrouped(date: $date, maxTemperature: $maxTemperature, minTemperature: $minTemperature, weatherCondition: $weatherCondition, hourlyWeather: $hourlyWeather)';
}


}

/// @nodoc
abstract mixin class $DailyWeatherGroupedCopyWith<$Res>  {
  factory $DailyWeatherGroupedCopyWith(DailyWeatherGrouped value, $Res Function(DailyWeatherGrouped) _then) = _$DailyWeatherGroupedCopyWithImpl;
@useResult
$Res call({
 String date, String maxTemperature, String minTemperature, WeatherCondition weatherCondition, List<HourlyWeather> hourlyWeather
});




}
/// @nodoc
class _$DailyWeatherGroupedCopyWithImpl<$Res>
    implements $DailyWeatherGroupedCopyWith<$Res> {
  _$DailyWeatherGroupedCopyWithImpl(this._self, this._then);

  final DailyWeatherGrouped _self;
  final $Res Function(DailyWeatherGrouped) _then;

/// Create a copy of DailyWeatherGrouped
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? maxTemperature = null,Object? minTemperature = null,Object? weatherCondition = null,Object? hourlyWeather = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,maxTemperature: null == maxTemperature ? _self.maxTemperature : maxTemperature // ignore: cast_nullable_to_non_nullable
as String,minTemperature: null == minTemperature ? _self.minTemperature : minTemperature // ignore: cast_nullable_to_non_nullable
as String,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,hourlyWeather: null == hourlyWeather ? _self.hourlyWeather : hourlyWeather // ignore: cast_nullable_to_non_nullable
as List<HourlyWeather>,
  ));
}

}


/// @nodoc


class _DailyWeatherGrouped implements DailyWeatherGrouped {
  const _DailyWeatherGrouped({required this.date, required this.maxTemperature, required this.minTemperature, required this.weatherCondition, required final  List<HourlyWeather> hourlyWeather}): _hourlyWeather = hourlyWeather;
  

@override final  String date;
@override final  String maxTemperature;
@override final  String minTemperature;
@override final  WeatherCondition weatherCondition;
 final  List<HourlyWeather> _hourlyWeather;
@override List<HourlyWeather> get hourlyWeather {
  if (_hourlyWeather is EqualUnmodifiableListView) return _hourlyWeather;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hourlyWeather);
}


/// Create a copy of DailyWeatherGrouped
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyWeatherGroupedCopyWith<_DailyWeatherGrouped> get copyWith => __$DailyWeatherGroupedCopyWithImpl<_DailyWeatherGrouped>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyWeatherGrouped&&(identical(other.date, date) || other.date == date)&&(identical(other.maxTemperature, maxTemperature) || other.maxTemperature == maxTemperature)&&(identical(other.minTemperature, minTemperature) || other.minTemperature == minTemperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&const DeepCollectionEquality().equals(other._hourlyWeather, _hourlyWeather));
}


@override
int get hashCode => Object.hash(runtimeType,date,maxTemperature,minTemperature,weatherCondition,const DeepCollectionEquality().hash(_hourlyWeather));

@override
String toString() {
  return 'DailyWeatherGrouped(date: $date, maxTemperature: $maxTemperature, minTemperature: $minTemperature, weatherCondition: $weatherCondition, hourlyWeather: $hourlyWeather)';
}


}

/// @nodoc
abstract mixin class _$DailyWeatherGroupedCopyWith<$Res> implements $DailyWeatherGroupedCopyWith<$Res> {
  factory _$DailyWeatherGroupedCopyWith(_DailyWeatherGrouped value, $Res Function(_DailyWeatherGrouped) _then) = __$DailyWeatherGroupedCopyWithImpl;
@override @useResult
$Res call({
 String date, String maxTemperature, String minTemperature, WeatherCondition weatherCondition, List<HourlyWeather> hourlyWeather
});




}
/// @nodoc
class __$DailyWeatherGroupedCopyWithImpl<$Res>
    implements _$DailyWeatherGroupedCopyWith<$Res> {
  __$DailyWeatherGroupedCopyWithImpl(this._self, this._then);

  final _DailyWeatherGrouped _self;
  final $Res Function(_DailyWeatherGrouped) _then;

/// Create a copy of DailyWeatherGrouped
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? maxTemperature = null,Object? minTemperature = null,Object? weatherCondition = null,Object? hourlyWeather = null,}) {
  return _then(_DailyWeatherGrouped(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,maxTemperature: null == maxTemperature ? _self.maxTemperature : maxTemperature // ignore: cast_nullable_to_non_nullable
as String,minTemperature: null == minTemperature ? _self.minTemperature : minTemperature // ignore: cast_nullable_to_non_nullable
as String,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,hourlyWeather: null == hourlyWeather ? _self._hourlyWeather : hourlyWeather // ignore: cast_nullable_to_non_nullable
as List<HourlyWeather>,
  ));
}


}

/// @nodoc
mixin _$HourlyWeather {

 String get time; DateTime get rawTime; String get temperature; WeatherCondition get weatherCondition; bool get isDay;
/// Create a copy of HourlyWeather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyWeatherCopyWith<HourlyWeather> get copyWith => _$HourlyWeatherCopyWithImpl<HourlyWeather>(this as HourlyWeather, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyWeather&&(identical(other.time, time) || other.time == time)&&(identical(other.rawTime, rawTime) || other.rawTime == rawTime)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}


@override
int get hashCode => Object.hash(runtimeType,time,rawTime,temperature,weatherCondition,isDay);

@override
String toString() {
  return 'HourlyWeather(time: $time, rawTime: $rawTime, temperature: $temperature, weatherCondition: $weatherCondition, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class $HourlyWeatherCopyWith<$Res>  {
  factory $HourlyWeatherCopyWith(HourlyWeather value, $Res Function(HourlyWeather) _then) = _$HourlyWeatherCopyWithImpl;
@useResult
$Res call({
 String time, DateTime rawTime, String temperature, WeatherCondition weatherCondition, bool isDay
});




}
/// @nodoc
class _$HourlyWeatherCopyWithImpl<$Res>
    implements $HourlyWeatherCopyWith<$Res> {
  _$HourlyWeatherCopyWithImpl(this._self, this._then);

  final HourlyWeather _self;
  final $Res Function(HourlyWeather) _then;

/// Create a copy of HourlyWeather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? rawTime = null,Object? temperature = null,Object? weatherCondition = null,Object? isDay = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,rawTime: null == rawTime ? _self.rawTime : rawTime // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as String,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _HourlyWeather implements HourlyWeather {
  const _HourlyWeather({required this.time, required this.rawTime, required this.temperature, required this.weatherCondition, required this.isDay});
  

@override final  String time;
@override final  DateTime rawTime;
@override final  String temperature;
@override final  WeatherCondition weatherCondition;
@override final  bool isDay;

/// Create a copy of HourlyWeather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyWeatherCopyWith<_HourlyWeather> get copyWith => __$HourlyWeatherCopyWithImpl<_HourlyWeather>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyWeather&&(identical(other.time, time) || other.time == time)&&(identical(other.rawTime, rawTime) || other.rawTime == rawTime)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.weatherCondition, weatherCondition) || other.weatherCondition == weatherCondition)&&(identical(other.isDay, isDay) || other.isDay == isDay));
}


@override
int get hashCode => Object.hash(runtimeType,time,rawTime,temperature,weatherCondition,isDay);

@override
String toString() {
  return 'HourlyWeather(time: $time, rawTime: $rawTime, temperature: $temperature, weatherCondition: $weatherCondition, isDay: $isDay)';
}


}

/// @nodoc
abstract mixin class _$HourlyWeatherCopyWith<$Res> implements $HourlyWeatherCopyWith<$Res> {
  factory _$HourlyWeatherCopyWith(_HourlyWeather value, $Res Function(_HourlyWeather) _then) = __$HourlyWeatherCopyWithImpl;
@override @useResult
$Res call({
 String time, DateTime rawTime, String temperature, WeatherCondition weatherCondition, bool isDay
});




}
/// @nodoc
class __$HourlyWeatherCopyWithImpl<$Res>
    implements _$HourlyWeatherCopyWith<$Res> {
  __$HourlyWeatherCopyWithImpl(this._self, this._then);

  final _HourlyWeather _self;
  final $Res Function(_HourlyWeather) _then;

/// Create a copy of HourlyWeather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? rawTime = null,Object? temperature = null,Object? weatherCondition = null,Object? isDay = null,}) {
  return _then(_HourlyWeather(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,rawTime: null == rawTime ? _self.rawTime : rawTime // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as String,weatherCondition: null == weatherCondition ? _self.weatherCondition : weatherCondition // ignore: cast_nullable_to_non_nullable
as WeatherCondition,isDay: null == isDay ? _self.isDay : isDay // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
