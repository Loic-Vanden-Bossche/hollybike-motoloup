// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Position {

 double get latitude; double get longitude; double? get altitude;@JsonKey(name: "place_name") String? get placeName;@JsonKey(name: "place_type") String get placeType;@JsonKey(name: "city_name") String? get cityName;@JsonKey(name: "country_name") String? get countryName;@JsonKey(name: "county_name") String? get countyName;@JsonKey(name: "state_name") String? get stateName;
/// Create a copy of Position
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PositionCopyWith<Position> get copyWith => _$PositionCopyWithImpl<Position>(this as Position, _$identity);

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Position&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countyName, countyName) || other.countyName == countyName)&&(identical(other.stateName, stateName) || other.stateName == stateName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,altitude,placeName,placeType,cityName,countryName,countyName,stateName);

@override
String toString() {
  return 'Position(latitude: $latitude, longitude: $longitude, altitude: $altitude, placeName: $placeName, placeType: $placeType, cityName: $cityName, countryName: $countryName, countyName: $countyName, stateName: $stateName)';
}


}

/// @nodoc
abstract mixin class $PositionCopyWith<$Res>  {
  factory $PositionCopyWith(Position value, $Res Function(Position) _then) = _$PositionCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double? altitude,@JsonKey(name: "place_name") String? placeName,@JsonKey(name: "place_type") String placeType,@JsonKey(name: "city_name") String? cityName,@JsonKey(name: "country_name") String? countryName,@JsonKey(name: "county_name") String? countyName,@JsonKey(name: "state_name") String? stateName
});




}
/// @nodoc
class _$PositionCopyWithImpl<$Res>
    implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._self, this._then);

  final Position _self;
  final $Res Function(Position) _then;

/// Create a copy of Position
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? altitude = freezed,Object? placeName = freezed,Object? placeType = null,Object? cityName = freezed,Object? countryName = freezed,Object? countyName = freezed,Object? stateName = freezed,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,placeType: null == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countyName: freezed == countyName ? _self.countyName : countyName // ignore: cast_nullable_to_non_nullable
as String?,stateName: freezed == stateName ? _self.stateName : stateName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Position].
extension PositionPatterns on Position {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Position value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Position() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Position value)  $default,){
final _that = this;
switch (_that) {
case _Position():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Position value)?  $default,){
final _that = this;
switch (_that) {
case _Position() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double? altitude, @JsonKey(name: "place_name")  String? placeName, @JsonKey(name: "place_type")  String placeType, @JsonKey(name: "city_name")  String? cityName, @JsonKey(name: "country_name")  String? countryName, @JsonKey(name: "county_name")  String? countyName, @JsonKey(name: "state_name")  String? stateName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Position() when $default != null:
return $default(_that.latitude,_that.longitude,_that.altitude,_that.placeName,_that.placeType,_that.cityName,_that.countryName,_that.countyName,_that.stateName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double? altitude, @JsonKey(name: "place_name")  String? placeName, @JsonKey(name: "place_type")  String placeType, @JsonKey(name: "city_name")  String? cityName, @JsonKey(name: "country_name")  String? countryName, @JsonKey(name: "county_name")  String? countyName, @JsonKey(name: "state_name")  String? stateName)  $default,) {final _that = this;
switch (_that) {
case _Position():
return $default(_that.latitude,_that.longitude,_that.altitude,_that.placeName,_that.placeType,_that.cityName,_that.countryName,_that.countyName,_that.stateName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double? altitude, @JsonKey(name: "place_name")  String? placeName, @JsonKey(name: "place_type")  String placeType, @JsonKey(name: "city_name")  String? cityName, @JsonKey(name: "country_name")  String? countryName, @JsonKey(name: "county_name")  String? countyName, @JsonKey(name: "state_name")  String? stateName)?  $default,) {final _that = this;
switch (_that) {
case _Position() when $default != null:
return $default(_that.latitude,_that.longitude,_that.altitude,_that.placeName,_that.placeType,_that.cityName,_that.countryName,_that.countyName,_that.stateName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Position extends Position {
  const _Position({required this.latitude, required this.longitude, required this.altitude, @JsonKey(name: "place_name") required this.placeName, @JsonKey(name: "place_type") required this.placeType, @JsonKey(name: "city_name") required this.cityName, @JsonKey(name: "country_name") required this.countryName, @JsonKey(name: "county_name") required this.countyName, @JsonKey(name: "state_name") required this.stateName}): super._();
  factory _Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

@override final  double latitude;
@override final  double longitude;
@override final  double? altitude;
@override@JsonKey(name: "place_name") final  String? placeName;
@override@JsonKey(name: "place_type") final  String placeType;
@override@JsonKey(name: "city_name") final  String? cityName;
@override@JsonKey(name: "country_name") final  String? countryName;
@override@JsonKey(name: "county_name") final  String? countyName;
@override@JsonKey(name: "state_name") final  String? stateName;

/// Create a copy of Position
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PositionCopyWith<_Position> get copyWith => __$PositionCopyWithImpl<_Position>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Position&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.countryName, countryName) || other.countryName == countryName)&&(identical(other.countyName, countyName) || other.countyName == countyName)&&(identical(other.stateName, stateName) || other.stateName == stateName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,altitude,placeName,placeType,cityName,countryName,countyName,stateName);

@override
String toString() {
  return 'Position(latitude: $latitude, longitude: $longitude, altitude: $altitude, placeName: $placeName, placeType: $placeType, cityName: $cityName, countryName: $countryName, countyName: $countyName, stateName: $stateName)';
}


}

/// @nodoc
abstract mixin class _$PositionCopyWith<$Res> implements $PositionCopyWith<$Res> {
  factory _$PositionCopyWith(_Position value, $Res Function(_Position) _then) = __$PositionCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double? altitude,@JsonKey(name: "place_name") String? placeName,@JsonKey(name: "place_type") String placeType,@JsonKey(name: "city_name") String? cityName,@JsonKey(name: "country_name") String? countryName,@JsonKey(name: "county_name") String? countyName,@JsonKey(name: "state_name") String? stateName
});




}
/// @nodoc
class __$PositionCopyWithImpl<$Res>
    implements _$PositionCopyWith<$Res> {
  __$PositionCopyWithImpl(this._self, this._then);

  final _Position _self;
  final $Res Function(_Position) _then;

/// Create a copy of Position
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? altitude = freezed,Object? placeName = freezed,Object? placeType = null,Object? cityName = freezed,Object? countryName = freezed,Object? countyName = freezed,Object? stateName = freezed,}) {
  return _then(_Position(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: freezed == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double?,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,placeType: null == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,countryName: freezed == countryName ? _self.countryName : countryName // ignore: cast_nullable_to_non_nullable
as String?,countyName: freezed == countyName ? _self.countyName : countyName // ignore: cast_nullable_to_non_nullable
as String?,stateName: freezed == stateName ? _self.stateName : stateName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
