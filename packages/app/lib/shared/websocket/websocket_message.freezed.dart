// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketMessage<T extends WebsocketBody> {

 String get channel; T get data;
/// Create a copy of WebsocketMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketMessageCopyWith<T, WebsocketMessage<T>> get copyWith => _$WebsocketMessageCopyWithImpl<T, WebsocketMessage<T>>(this as WebsocketMessage<T>, _$identity);

  /// Serializes this WebsocketMessage to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketMessage<T>&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channel,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WebsocketMessage<$T>(channel: $channel, data: $data)';
}


}

/// @nodoc
abstract mixin class $WebsocketMessageCopyWith<T extends WebsocketBody,$Res>  {
  factory $WebsocketMessageCopyWith(WebsocketMessage<T> value, $Res Function(WebsocketMessage<T>) _then) = _$WebsocketMessageCopyWithImpl;
@useResult
$Res call({
 String channel, T data
});




}
/// @nodoc
class _$WebsocketMessageCopyWithImpl<T extends WebsocketBody,$Res>
    implements $WebsocketMessageCopyWith<T, $Res> {
  _$WebsocketMessageCopyWithImpl(this._self, this._then);

  final WebsocketMessage<T> _self;
  final $Res Function(WebsocketMessage<T>) _then;

/// Create a copy of WebsocketMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,Object? data = null,}) {
  return _then(_self.copyWith(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketMessage].
extension WebsocketMessagePatterns<T extends WebsocketBody> on WebsocketMessage<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketMessage<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketMessage<T> value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketMessage<T> value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String channel,  T data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketMessage() when $default != null:
return $default(_that.channel,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String channel,  T data)  $default,) {final _that = this;
switch (_that) {
case _WebsocketMessage():
return $default(_that.channel,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String channel,  T data)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketMessage() when $default != null:
return $default(_that.channel,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _WebsocketMessage<T extends WebsocketBody> implements WebsocketMessage<T> {
  const _WebsocketMessage({required this.channel, required this.data});
  factory _WebsocketMessage.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$WebsocketMessageFromJson(json,fromJsonT);

@override final  String channel;
@override final  T data;

/// Create a copy of WebsocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketMessageCopyWith<T, _WebsocketMessage<T>> get copyWith => __$WebsocketMessageCopyWithImpl<T, _WebsocketMessage<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$WebsocketMessageToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketMessage<T>&&(identical(other.channel, channel) || other.channel == channel)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channel,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WebsocketMessage<$T>(channel: $channel, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WebsocketMessageCopyWith<T extends WebsocketBody,$Res> implements $WebsocketMessageCopyWith<T, $Res> {
  factory _$WebsocketMessageCopyWith(_WebsocketMessage<T> value, $Res Function(_WebsocketMessage<T>) _then) = __$WebsocketMessageCopyWithImpl;
@override @useResult
$Res call({
 String channel, T data
});




}
/// @nodoc
class __$WebsocketMessageCopyWithImpl<T extends WebsocketBody,$Res>
    implements _$WebsocketMessageCopyWith<T, $Res> {
  __$WebsocketMessageCopyWithImpl(this._self, this._then);

  final _WebsocketMessage<T> _self;
  final $Res Function(_WebsocketMessage<T>) _then;

/// Create a copy of WebsocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? data = null,}) {
  return _then(_WebsocketMessage<T>(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

// dart format on
