// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_stop_send_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketStopSendPosition {

 String get type;
/// Create a copy of WebsocketStopSendPosition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketStopSendPositionCopyWith<WebsocketStopSendPosition> get copyWith => _$WebsocketStopSendPositionCopyWithImpl<WebsocketStopSendPosition>(this as WebsocketStopSendPosition, _$identity);

  /// Serializes this WebsocketStopSendPosition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketStopSendPosition&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'WebsocketStopSendPosition(type: $type)';
}


}

/// @nodoc
abstract mixin class $WebsocketStopSendPositionCopyWith<$Res>  {
  factory $WebsocketStopSendPositionCopyWith(WebsocketStopSendPosition value, $Res Function(WebsocketStopSendPosition) _then) = _$WebsocketStopSendPositionCopyWithImpl;
@useResult
$Res call({
 String type
});




}
/// @nodoc
class _$WebsocketStopSendPositionCopyWithImpl<$Res>
    implements $WebsocketStopSendPositionCopyWith<$Res> {
  _$WebsocketStopSendPositionCopyWithImpl(this._self, this._then);

  final WebsocketStopSendPosition _self;
  final $Res Function(WebsocketStopSendPosition) _then;

/// Create a copy of WebsocketStopSendPosition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketStopSendPosition implements WebsocketStopSendPosition {
  const _WebsocketStopSendPosition({this.type = "stop-send-user-position"});
  factory _WebsocketStopSendPosition.fromJson(Map<String, dynamic> json) => _$WebsocketStopSendPositionFromJson(json);

@override@JsonKey() final  String type;

/// Create a copy of WebsocketStopSendPosition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketStopSendPositionCopyWith<_WebsocketStopSendPosition> get copyWith => __$WebsocketStopSendPositionCopyWithImpl<_WebsocketStopSendPosition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketStopSendPositionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketStopSendPosition&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'WebsocketStopSendPosition(type: $type)';
}


}

/// @nodoc
abstract mixin class _$WebsocketStopSendPositionCopyWith<$Res> implements $WebsocketStopSendPositionCopyWith<$Res> {
  factory _$WebsocketStopSendPositionCopyWith(_WebsocketStopSendPosition value, $Res Function(_WebsocketStopSendPosition) _then) = __$WebsocketStopSendPositionCopyWithImpl;
@override @useResult
$Res call({
 String type
});




}
/// @nodoc
class __$WebsocketStopSendPositionCopyWithImpl<$Res>
    implements _$WebsocketStopSendPositionCopyWith<$Res> {
  __$WebsocketStopSendPositionCopyWithImpl(this._self, this._then);

  final _WebsocketStopSendPosition _self;
  final $Res Function(_WebsocketStopSendPosition) _then;

/// Create a copy of WebsocketStopSendPosition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_WebsocketStopSendPosition(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
