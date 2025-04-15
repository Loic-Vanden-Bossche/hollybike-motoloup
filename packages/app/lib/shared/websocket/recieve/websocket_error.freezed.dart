// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketError {

 String get message; String get type;
/// Create a copy of WebsocketError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketErrorCopyWith<WebsocketError> get copyWith => _$WebsocketErrorCopyWithImpl<WebsocketError>(this as WebsocketError, _$identity);

  /// Serializes this WebsocketError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketError&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,type);

@override
String toString() {
  return 'WebsocketError(message: $message, type: $type)';
}


}

/// @nodoc
abstract mixin class $WebsocketErrorCopyWith<$Res>  {
  factory $WebsocketErrorCopyWith(WebsocketError value, $Res Function(WebsocketError) _then) = _$WebsocketErrorCopyWithImpl;
@useResult
$Res call({
 String message, String type
});




}
/// @nodoc
class _$WebsocketErrorCopyWithImpl<$Res>
    implements $WebsocketErrorCopyWith<$Res> {
  _$WebsocketErrorCopyWithImpl(this._self, this._then);

  final WebsocketError _self;
  final $Res Function(WebsocketError) _then;

/// Create a copy of WebsocketError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? type = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketError implements WebsocketError {
  const _WebsocketError({required this.message, this.type = "subscribed"});
  factory _WebsocketError.fromJson(Map<String, dynamic> json) => _$WebsocketErrorFromJson(json);

@override final  String message;
@override@JsonKey() final  String type;

/// Create a copy of WebsocketError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketErrorCopyWith<_WebsocketError> get copyWith => __$WebsocketErrorCopyWithImpl<_WebsocketError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketError&&(identical(other.message, message) || other.message == message)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,type);

@override
String toString() {
  return 'WebsocketError(message: $message, type: $type)';
}


}

/// @nodoc
abstract mixin class _$WebsocketErrorCopyWith<$Res> implements $WebsocketErrorCopyWith<$Res> {
  factory _$WebsocketErrorCopyWith(_WebsocketError value, $Res Function(_WebsocketError) _then) = __$WebsocketErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, String type
});




}
/// @nodoc
class __$WebsocketErrorCopyWithImpl<$Res>
    implements _$WebsocketErrorCopyWith<$Res> {
  __$WebsocketErrorCopyWithImpl(this._self, this._then);

  final _WebsocketError _self;
  final $Res Function(_WebsocketError) _then;

/// Create a copy of WebsocketError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? type = null,}) {
  return _then(_WebsocketError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
