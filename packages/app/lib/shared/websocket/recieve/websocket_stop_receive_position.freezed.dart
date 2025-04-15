// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_stop_receive_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketStopReceivePosition {

 String get type;@JsonKey(name: "user") int get userId;
/// Create a copy of WebsocketStopReceivePosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketStopReceivePositionCopyWith<WebsocketStopReceivePosition> get copyWith => _$WebsocketStopReceivePositionCopyWithImpl<WebsocketStopReceivePosition>(this as WebsocketStopReceivePosition, _$identity);

  /// Serializes this WebsocketStopReceivePosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketStopReceivePosition&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,userId);

@override
String toString() {
  return 'WebsocketStopReceivePosition(type: $type, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $WebsocketStopReceivePositionCopyWith<$Res>  {
  factory $WebsocketStopReceivePositionCopyWith(WebsocketStopReceivePosition value, $Res Function(WebsocketStopReceivePosition) _then) = _$WebsocketStopReceivePositionCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: "user") int userId
});




}
/// @nodoc
class _$WebsocketStopReceivePositionCopyWithImpl<$Res>
    implements $WebsocketStopReceivePositionCopyWith<$Res> {
  _$WebsocketStopReceivePositionCopyWithImpl(this._self, this._then);

  final WebsocketStopReceivePosition _self;
  final $Res Function(WebsocketStopReceivePosition) _then;

/// Create a copy of WebsocketStopReceivePosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? userId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketStopReceivePosition implements WebsocketStopReceivePosition {
  const _WebsocketStopReceivePosition({required this.type, @JsonKey(name: "user") required this.userId});
  factory _WebsocketStopReceivePosition.fromJson(Map<String, dynamic> json) => _$WebsocketStopReceivePositionFromJson(json);

@override final  String type;
@override@JsonKey(name: "user") final  int userId;

/// Create a copy of WebsocketStopReceivePosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketStopReceivePositionCopyWith<_WebsocketStopReceivePosition> get copyWith => __$WebsocketStopReceivePositionCopyWithImpl<_WebsocketStopReceivePosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketStopReceivePositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketStopReceivePosition&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,userId);

@override
String toString() {
  return 'WebsocketStopReceivePosition(type: $type, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$WebsocketStopReceivePositionCopyWith<$Res> implements $WebsocketStopReceivePositionCopyWith<$Res> {
  factory _$WebsocketStopReceivePositionCopyWith(_WebsocketStopReceivePosition value, $Res Function(_WebsocketStopReceivePosition) _then) = __$WebsocketStopReceivePositionCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: "user") int userId
});




}
/// @nodoc
class __$WebsocketStopReceivePositionCopyWithImpl<$Res>
    implements _$WebsocketStopReceivePositionCopyWith<$Res> {
  __$WebsocketStopReceivePositionCopyWithImpl(this._self, this._then);

  final _WebsocketStopReceivePosition _self;
  final $Res Function(_WebsocketStopReceivePosition) _then;

/// Create a copy of WebsocketStopReceivePosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? userId = null,}) {
  return _then(_WebsocketStopReceivePosition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
