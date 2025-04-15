// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_send_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketSendPosition {

 String get type; double get latitude; double get longitude; double get altitude; double get heading;@JsonKey(name: "acceleration_x") double get accelerationX;@JsonKey(name: "acceleration_y") double get accelerationY;@JsonKey(name: "acceleration_z") double get accelerationZ; DateTime get time; double get speed;@JsonKey(name: "speed_accuracy") double get speedAccuracy; double get accuracy;
/// Create a copy of WebsocketSendPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketSendPositionCopyWith<WebsocketSendPosition> get copyWith => _$WebsocketSendPositionCopyWithImpl<WebsocketSendPosition>(this as WebsocketSendPosition, _$identity);

  /// Serializes this WebsocketSendPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketSendPosition&&(identical(other.type, type) || other.type == type)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.accelerationX, accelerationX) || other.accelerationX == accelerationX)&&(identical(other.accelerationY, accelerationY) || other.accelerationY == accelerationY)&&(identical(other.accelerationZ, accelerationZ) || other.accelerationZ == accelerationZ)&&(identical(other.time, time) || other.time == time)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.speedAccuracy, speedAccuracy) || other.speedAccuracy == speedAccuracy)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,latitude,longitude,altitude,heading,accelerationX,accelerationY,accelerationZ,time,speed,speedAccuracy,accuracy);

@override
String toString() {
  return 'WebsocketSendPosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, heading: $heading, accelerationX: $accelerationX, accelerationY: $accelerationY, accelerationZ: $accelerationZ, time: $time, speed: $speed, speedAccuracy: $speedAccuracy, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class $WebsocketSendPositionCopyWith<$Res>  {
  factory $WebsocketSendPositionCopyWith(WebsocketSendPosition value, $Res Function(WebsocketSendPosition) _then) = _$WebsocketSendPositionCopyWithImpl;
@useResult
$Res call({
 String type, double latitude, double longitude, double altitude, double heading,@JsonKey(name: "acceleration_x") double accelerationX,@JsonKey(name: "acceleration_y") double accelerationY,@JsonKey(name: "acceleration_z") double accelerationZ, DateTime time, double speed,@JsonKey(name: "speed_accuracy") double speedAccuracy, double accuracy
});




}
/// @nodoc
class _$WebsocketSendPositionCopyWithImpl<$Res>
    implements $WebsocketSendPositionCopyWith<$Res> {
  _$WebsocketSendPositionCopyWithImpl(this._self, this._then);

  final WebsocketSendPosition _self;
  final $Res Function(WebsocketSendPosition) _then;

/// Create a copy of WebsocketSendPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? heading = null,Object? accelerationX = null,Object? accelerationY = null,Object? accelerationZ = null,Object? time = null,Object? speed = null,Object? speedAccuracy = null,Object? accuracy = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double,accelerationX: null == accelerationX ? _self.accelerationX : accelerationX // ignore: cast_nullable_to_non_nullable
as double,accelerationY: null == accelerationY ? _self.accelerationY : accelerationY // ignore: cast_nullable_to_non_nullable
as double,accelerationZ: null == accelerationZ ? _self.accelerationZ : accelerationZ // ignore: cast_nullable_to_non_nullable
as double,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,speedAccuracy: null == speedAccuracy ? _self.speedAccuracy : speedAccuracy // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketSendPosition implements WebsocketSendPosition {
  const _WebsocketSendPosition({this.type = "send-user-position", required this.latitude, required this.longitude, required this.altitude, required this.heading, @JsonKey(name: "acceleration_x") required this.accelerationX, @JsonKey(name: "acceleration_y") required this.accelerationY, @JsonKey(name: "acceleration_z") required this.accelerationZ, required this.time, required this.speed, @JsonKey(name: "speed_accuracy") required this.speedAccuracy, required this.accuracy});
  factory _WebsocketSendPosition.fromJson(Map<String, dynamic> json) => _$WebsocketSendPositionFromJson(json);

@override@JsonKey() final  String type;
@override final  double latitude;
@override final  double longitude;
@override final  double altitude;
@override final  double heading;
@override@JsonKey(name: "acceleration_x") final  double accelerationX;
@override@JsonKey(name: "acceleration_y") final  double accelerationY;
@override@JsonKey(name: "acceleration_z") final  double accelerationZ;
@override final  DateTime time;
@override final  double speed;
@override@JsonKey(name: "speed_accuracy") final  double speedAccuracy;
@override final  double accuracy;

/// Create a copy of WebsocketSendPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketSendPositionCopyWith<_WebsocketSendPosition> get copyWith => __$WebsocketSendPositionCopyWithImpl<_WebsocketSendPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketSendPositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketSendPosition&&(identical(other.type, type) || other.type == type)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitude, altitude) || other.altitude == altitude)&&(identical(other.heading, heading) || other.heading == heading)&&(identical(other.accelerationX, accelerationX) || other.accelerationX == accelerationX)&&(identical(other.accelerationY, accelerationY) || other.accelerationY == accelerationY)&&(identical(other.accelerationZ, accelerationZ) || other.accelerationZ == accelerationZ)&&(identical(other.time, time) || other.time == time)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.speedAccuracy, speedAccuracy) || other.speedAccuracy == speedAccuracy)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,latitude,longitude,altitude,heading,accelerationX,accelerationY,accelerationZ,time,speed,speedAccuracy,accuracy);

@override
String toString() {
  return 'WebsocketSendPosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, heading: $heading, accelerationX: $accelerationX, accelerationY: $accelerationY, accelerationZ: $accelerationZ, time: $time, speed: $speed, speedAccuracy: $speedAccuracy, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class _$WebsocketSendPositionCopyWith<$Res> implements $WebsocketSendPositionCopyWith<$Res> {
  factory _$WebsocketSendPositionCopyWith(_WebsocketSendPosition value, $Res Function(_WebsocketSendPosition) _then) = __$WebsocketSendPositionCopyWithImpl;
@override @useResult
$Res call({
 String type, double latitude, double longitude, double altitude, double heading,@JsonKey(name: "acceleration_x") double accelerationX,@JsonKey(name: "acceleration_y") double accelerationY,@JsonKey(name: "acceleration_z") double accelerationZ, DateTime time, double speed,@JsonKey(name: "speed_accuracy") double speedAccuracy, double accuracy
});




}
/// @nodoc
class __$WebsocketSendPositionCopyWithImpl<$Res>
    implements _$WebsocketSendPositionCopyWith<$Res> {
  __$WebsocketSendPositionCopyWithImpl(this._self, this._then);

  final _WebsocketSendPosition _self;
  final $Res Function(_WebsocketSendPosition) _then;

/// Create a copy of WebsocketSendPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? latitude = null,Object? longitude = null,Object? altitude = null,Object? heading = null,Object? accelerationX = null,Object? accelerationY = null,Object? accelerationZ = null,Object? time = null,Object? speed = null,Object? speedAccuracy = null,Object? accuracy = null,}) {
  return _then(_WebsocketSendPosition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,altitude: null == altitude ? _self.altitude : altitude // ignore: cast_nullable_to_non_nullable
as double,heading: null == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double,accelerationX: null == accelerationX ? _self.accelerationX : accelerationX // ignore: cast_nullable_to_non_nullable
as double,accelerationY: null == accelerationY ? _self.accelerationY : accelerationY // ignore: cast_nullable_to_non_nullable
as double,accelerationZ: null == accelerationZ ? _self.accelerationZ : accelerationZ // ignore: cast_nullable_to_non_nullable
as double,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,speedAccuracy: null == speedAccuracy ? _self.speedAccuracy : speedAccuracy // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
