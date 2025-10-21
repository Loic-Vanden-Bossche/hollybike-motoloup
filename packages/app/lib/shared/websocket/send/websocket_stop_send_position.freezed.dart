// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [WebsocketStopSendPosition].
extension WebsocketStopSendPositionPatterns on WebsocketStopSendPosition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketStopSendPosition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketStopSendPosition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketStopSendPosition value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketStopSendPosition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketStopSendPosition value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketStopSendPosition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketStopSendPosition() when $default != null:
return $default(_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type)  $default,) {final _that = this;
switch (_that) {
case _WebsocketStopSendPosition():
return $default(_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketStopSendPosition() when $default != null:
return $default(_that.type);case _:
  return null;

}
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
