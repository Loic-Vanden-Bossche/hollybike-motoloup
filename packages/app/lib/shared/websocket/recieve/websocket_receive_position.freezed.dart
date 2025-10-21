// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_receive_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketReceivePosition {

 String get type; double get latitude; double get longitude; double get altitude; DateTime get time; double get speed;@JsonKey(name: "user") int get userId;
/// Create a copy of WebsocketReceivePosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketReceivePositionCopyWith<WebsocketReceivePosition> get copyWith => _$WebsocketReceivePositionCopyWithImpl<WebsocketReceivePosition>(this as WebsocketReceivePosition, _$identity);

  /// Serializes this WebsocketReceivePosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketReceivePosition&&(identical(other.type, type) || other.type == type)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.time, time) || other.time == time)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,latitude,longitude,altitude,time,speed,userId);

@override
String toString() {
  return 'WebsocketReceivePosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, time: $time, speed: $speed, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $WebsocketReceivePositionCopyWith<$Res>  {
  factory $WebsocketReceivePositionCopyWith(WebsocketReceivePosition value, $Res Function(WebsocketReceivePosition) _then) = _$WebsocketReceivePositionCopyWithImpl;
@useResult
$Res call({
 String type, double latitude, double longitude, double altitude, DateTime time, double speed,@JsonKey(name: "user") int userId
});




}
/// @nodoc
class _$WebsocketReceivePositionCopyWithImpl<$Res>
    implements $WebsocketReceivePositionCopyWith<$Res> {
  _$WebsocketReceivePositionCopyWithImpl(this._self, this._then);

  final WebsocketReceivePosition _self;
  final $Res Function(WebsocketReceivePosition) _then;

/// Create a copy of WebsocketReceivePosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? time = null,Object? speed = null,Object? userId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketReceivePosition].
extension WebsocketReceivePositionPatterns on WebsocketReceivePosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketReceivePosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketReceivePosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketReceivePosition value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketReceivePosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketReceivePosition value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketReceivePosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  double latitude,  double longitude,  double altitude,  DateTime time,  double speed, @JsonKey(name: "user")  int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketReceivePosition() when $default != null:
return $default(_that.type,_that.latitude,_that.longitude,_that.altitude,_that.time,_that.speed,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  double latitude,  double longitude,  double altitude,  DateTime time,  double speed, @JsonKey(name: "user")  int userId)  $default,) {final _that = this;
switch (_that) {
case _WebsocketReceivePosition():
return $default(_that.type,_that.latitude,_that.longitude,_that.altitude,_that.time,_that.speed,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  double latitude,  double longitude,  double altitude,  DateTime time,  double speed, @JsonKey(name: "user")  int userId)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketReceivePosition() when $default != null:
return $default(_that.type,_that.latitude,_that.longitude,_that.altitude,_that.time,_that.speed,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebsocketReceivePosition implements WebsocketReceivePosition {
  const _WebsocketReceivePosition({required this.type, required this.latitude, required this.longitude, required this.altitude, required this.time, required this.speed, @JsonKey(name: "user") required this.userId});
  factory _WebsocketReceivePosition.fromJson(Map<String, dynamic> json) => _$WebsocketReceivePositionFromJson(json);

@override final  String type;
@override final  double latitude;
@override final  double longitude;
@override final  double altitude;
@override final  DateTime time;
@override final  double speed;
@override@JsonKey(name: "user") final  int userId;

/// Create a copy of WebsocketReceivePosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketReceivePositionCopyWith<_WebsocketReceivePosition> get copyWith => __$WebsocketReceivePositionCopyWithImpl<_WebsocketReceivePosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketReceivePositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketReceivePosition&&(identical(other.type, type) || other.type == type)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.time, time) || other.time == time)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,latitude,longitude,altitude,time,speed,userId);

@override
String toString() {
  return 'WebsocketReceivePosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, time: $time, speed: $speed, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$WebsocketReceivePositionCopyWith<$Res> implements $WebsocketReceivePositionCopyWith<$Res> {
  factory _$WebsocketReceivePositionCopyWith(_WebsocketReceivePosition value, $Res Function(_WebsocketReceivePosition) _then) = __$WebsocketReceivePositionCopyWithImpl;
@override @useResult
$Res call({
 String type, double latitude, double longitude, double altitude, DateTime time, double speed,@JsonKey(name: "user") int userId
});




}
/// @nodoc
class __$WebsocketReceivePositionCopyWithImpl<$Res>
    implements _$WebsocketReceivePositionCopyWith<$Res> {
  __$WebsocketReceivePositionCopyWithImpl(this._self, this._then);

  final _WebsocketReceivePosition _self;
  final $Res Function(_WebsocketReceivePosition) _then;

/// Create a copy of WebsocketReceivePosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? time = null,Object? speed = null,Object? userId = null,}) {
  return _then(_WebsocketReceivePosition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
