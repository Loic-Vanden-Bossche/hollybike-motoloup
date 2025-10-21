// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_read_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketReadNotification {

 String get type;@JsonKey(name: 'notification') int get notificationId;
/// Create a copy of WebsocketReadNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketReadNotificationCopyWith<WebsocketReadNotification> get copyWith => _$WebsocketReadNotificationCopyWithImpl<WebsocketReadNotification>(this as WebsocketReadNotification, _$identity);

  /// Serializes this WebsocketReadNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketReadNotification&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId);

@override
String toString() {
  return 'WebsocketReadNotification(type: $type, notificationId: $notificationId)';
}


}

/// @nodoc
abstract mixin class $WebsocketReadNotificationCopyWith<$Res>  {
  factory $WebsocketReadNotificationCopyWith(WebsocketReadNotification value, $Res Function(WebsocketReadNotification) _then) = _$WebsocketReadNotificationCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification') int notificationId
});




}
/// @nodoc
class _$WebsocketReadNotificationCopyWithImpl<$Res>
    implements $WebsocketReadNotificationCopyWith<$Res> {
  _$WebsocketReadNotificationCopyWithImpl(this._self, this._then);

  final WebsocketReadNotification _self;
  final $Res Function(WebsocketReadNotification) _then;

/// Create a copy of WebsocketReadNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? notificationId = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketReadNotification].
extension WebsocketReadNotificationPatterns on WebsocketReadNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketReadNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketReadNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketReadNotification value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketReadNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketReadNotification value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketReadNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification')  int notificationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketReadNotification() when $default != null:
return $default(_that.type,_that.notificationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification')  int notificationId)  $default,) {final _that = this;
switch (_that) {
case _WebsocketReadNotification():
return $default(_that.type,_that.notificationId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: 'notification')  int notificationId)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketReadNotification() when $default != null:
return $default(_that.type,_that.notificationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebsocketReadNotification implements WebsocketReadNotification {
  const _WebsocketReadNotification({this.type = "read-notification", @JsonKey(name: 'notification') required this.notificationId});
  factory _WebsocketReadNotification.fromJson(Map<String, dynamic> json) => _$WebsocketReadNotificationFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification') final  int notificationId;

/// Create a copy of WebsocketReadNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketReadNotificationCopyWith<_WebsocketReadNotification> get copyWith => __$WebsocketReadNotificationCopyWithImpl<_WebsocketReadNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketReadNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketReadNotification&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId);

@override
String toString() {
  return 'WebsocketReadNotification(type: $type, notificationId: $notificationId)';
}


}

/// @nodoc
abstract mixin class _$WebsocketReadNotificationCopyWith<$Res> implements $WebsocketReadNotificationCopyWith<$Res> {
  factory _$WebsocketReadNotificationCopyWith(_WebsocketReadNotification value, $Res Function(_WebsocketReadNotification) _then) = __$WebsocketReadNotificationCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification') int notificationId
});




}
/// @nodoc
class __$WebsocketReadNotificationCopyWithImpl<$Res>
    implements _$WebsocketReadNotificationCopyWith<$Res> {
  __$WebsocketReadNotificationCopyWithImpl(this._self, this._then);

  final _WebsocketReadNotification _self;
  final $Res Function(_WebsocketReadNotification) _then;

/// Create a copy of WebsocketReadNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,}) {
  return _then(_WebsocketReadNotification(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
