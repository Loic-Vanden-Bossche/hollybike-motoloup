// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_subscribe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketSubscribe {

 String get token; String get type;
/// Create a copy of WebsocketSubscribe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketSubscribeCopyWith<WebsocketSubscribe> get copyWith => _$WebsocketSubscribeCopyWithImpl<WebsocketSubscribe>(this as WebsocketSubscribe, _$identity);

  /// Serializes this WebsocketSubscribe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketSubscribe&&(identical(other.token, token) || other.token == token)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,type);

@override
String toString() {
  return 'WebsocketSubscribe(token: $token, type: $type)';
}


}

/// @nodoc
abstract mixin class $WebsocketSubscribeCopyWith<$Res>  {
  factory $WebsocketSubscribeCopyWith(WebsocketSubscribe value, $Res Function(WebsocketSubscribe) _then) = _$WebsocketSubscribeCopyWithImpl;
@useResult
$Res call({
 String token, String type
});




}
/// @nodoc
class _$WebsocketSubscribeCopyWithImpl<$Res>
    implements $WebsocketSubscribeCopyWith<$Res> {
  _$WebsocketSubscribeCopyWithImpl(this._self, this._then);

  final WebsocketSubscribe _self;
  final $Res Function(WebsocketSubscribe) _then;

/// Create a copy of WebsocketSubscribe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? type = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketSubscribe].
extension WebsocketSubscribePatterns on WebsocketSubscribe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketSubscribe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketSubscribe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketSubscribe value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketSubscribe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketSubscribe value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketSubscribe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketSubscribe() when $default != null:
return $default(_that.token,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String type)  $default,) {final _that = this;
switch (_that) {
case _WebsocketSubscribe():
return $default(_that.token,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String type)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketSubscribe() when $default != null:
return $default(_that.token,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebsocketSubscribe implements WebsocketSubscribe {
  const _WebsocketSubscribe({required this.token, this.type = "subscribe"});
  factory _WebsocketSubscribe.fromJson(Map<String, dynamic> json) => _$WebsocketSubscribeFromJson(json);

@override final  String token;
@override@JsonKey() final  String type;

/// Create a copy of WebsocketSubscribe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketSubscribeCopyWith<_WebsocketSubscribe> get copyWith => __$WebsocketSubscribeCopyWithImpl<_WebsocketSubscribe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketSubscribeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketSubscribe&&(identical(other.token, token) || other.token == token)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,type);

@override
String toString() {
  return 'WebsocketSubscribe(token: $token, type: $type)';
}


}

/// @nodoc
abstract mixin class _$WebsocketSubscribeCopyWith<$Res> implements $WebsocketSubscribeCopyWith<$Res> {
  factory _$WebsocketSubscribeCopyWith(_WebsocketSubscribe value, $Res Function(_WebsocketSubscribe) _then) = __$WebsocketSubscribeCopyWithImpl;
@override @useResult
$Res call({
 String token, String type
});




}
/// @nodoc
class __$WebsocketSubscribeCopyWithImpl<$Res>
    implements _$WebsocketSubscribeCopyWith<$Res> {
  __$WebsocketSubscribeCopyWithImpl(this._self, this._then);

  final _WebsocketSubscribe _self;
  final $Res Function(_WebsocketSubscribe) _then;

/// Create a copy of WebsocketSubscribe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? type = null,}) {
  return _then(_WebsocketSubscribe(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
