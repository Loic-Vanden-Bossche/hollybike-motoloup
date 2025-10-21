// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_deleted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketEventDeleted {

 String get type;@JsonKey(name: 'notification_id') int get notificationId; String get name; String? get description;
/// Create a copy of WebsocketEventDeleted
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketEventDeletedCopyWith<WebsocketEventDeleted> get copyWith => _$WebsocketEventDeletedCopyWithImpl<WebsocketEventDeleted>(this as WebsocketEventDeleted, _$identity);

  /// Serializes this WebsocketEventDeleted to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketEventDeleted&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,name,description);

@override
String toString() {
  return 'WebsocketEventDeleted(type: $type, notificationId: $notificationId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $WebsocketEventDeletedCopyWith<$Res>  {
  factory $WebsocketEventDeletedCopyWith(WebsocketEventDeleted value, $Res Function(WebsocketEventDeleted) _then) = _$WebsocketEventDeletedCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, String name, String? description
});




}
/// @nodoc
class _$WebsocketEventDeletedCopyWithImpl<$Res>
    implements $WebsocketEventDeletedCopyWith<$Res> {
  _$WebsocketEventDeletedCopyWithImpl(this._self, this._then);

  final WebsocketEventDeleted _self;
  final $Res Function(WebsocketEventDeleted) _then;

/// Create a copy of WebsocketEventDeleted
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? notificationId = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketEventDeleted].
extension WebsocketEventDeletedPatterns on WebsocketEventDeleted {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketEventDeleted value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketEventDeleted() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketEventDeleted value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketEventDeleted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketEventDeleted value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketEventDeleted() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketEventDeleted() when $default != null:
return $default(_that.type,_that.notificationId,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _WebsocketEventDeleted():
return $default(_that.type,_that.notificationId,_that.name,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketEventDeleted() when $default != null:
return $default(_that.type,_that.notificationId,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebsocketEventDeleted implements WebsocketEventDeleted {
  const _WebsocketEventDeleted({this.type = "DeleteEventNotification", @JsonKey(name: 'notification_id') required this.notificationId, required this.name, this.description});
  factory _WebsocketEventDeleted.fromJson(Map<String, dynamic> json) => _$WebsocketEventDeletedFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  String name;
@override final  String? description;

/// Create a copy of WebsocketEventDeleted
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketEventDeletedCopyWith<_WebsocketEventDeleted> get copyWith => __$WebsocketEventDeletedCopyWithImpl<_WebsocketEventDeleted>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketEventDeletedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketEventDeleted&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,name,description);

@override
String toString() {
  return 'WebsocketEventDeleted(type: $type, notificationId: $notificationId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$WebsocketEventDeletedCopyWith<$Res> implements $WebsocketEventDeletedCopyWith<$Res> {
  factory _$WebsocketEventDeletedCopyWith(_WebsocketEventDeleted value, $Res Function(_WebsocketEventDeleted) _then) = __$WebsocketEventDeletedCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, String name, String? description
});




}
/// @nodoc
class __$WebsocketEventDeletedCopyWithImpl<$Res>
    implements _$WebsocketEventDeletedCopyWith<$Res> {
  __$WebsocketEventDeletedCopyWithImpl(this._self, this._then);

  final _WebsocketEventDeleted _self;
  final $Res Function(_WebsocketEventDeleted) _then;

/// Create a copy of WebsocketEventDeleted
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,Object? name = null,Object? description = freezed,}) {
  return _then(_WebsocketEventDeleted(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
