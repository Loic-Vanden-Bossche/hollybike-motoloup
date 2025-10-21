// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_published.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketEventPublished {

 String get type;@JsonKey(name: 'notification_id') int get notificationId; int get id; String get name; String? get description; DateTime get start; String? get image;@JsonKey(name: 'owner_id') int get ownerId;@JsonKey(name: 'owner_name') String get ownerName;
/// Create a copy of WebsocketEventPublished
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketEventPublishedCopyWith<WebsocketEventPublished> get copyWith => _$WebsocketEventPublishedCopyWithImpl<WebsocketEventPublished>(this as WebsocketEventPublished, _$identity);

  /// Serializes this WebsocketEventPublished to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketEventPublished&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.image, image) || other.image == image)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name,description,start,image,ownerId,ownerName);

@override
String toString() {
  return 'WebsocketEventPublished(type: $type, notificationId: $notificationId, id: $id, name: $name, description: $description, start: $start, image: $image, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class $WebsocketEventPublishedCopyWith<$Res>  {
  factory $WebsocketEventPublishedCopyWith(WebsocketEventPublished value, $Res Function(WebsocketEventPublished) _then) = _$WebsocketEventPublishedCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name, String? description, DateTime start, String? image,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName
});




}
/// @nodoc
class _$WebsocketEventPublishedCopyWithImpl<$Res>
    implements $WebsocketEventPublishedCopyWith<$Res> {
  _$WebsocketEventPublishedCopyWithImpl(this._self, this._then);

  final WebsocketEventPublished _self;
  final $Res Function(WebsocketEventPublished) _then;

/// Create a copy of WebsocketEventPublished
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,Object? description = freezed,Object? start = null,Object? image = freezed,Object? ownerId = null,Object? ownerName = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WebsocketEventPublished].
extension WebsocketEventPublishedPatterns on WebsocketEventPublished {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebsocketEventPublished value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebsocketEventPublished() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebsocketEventPublished value)  $default,){
final _that = this;
switch (_that) {
case _WebsocketEventPublished():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebsocketEventPublished value)?  $default,){
final _that = this;
switch (_that) {
case _WebsocketEventPublished() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  int id,  String name,  String? description,  DateTime start,  String? image, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebsocketEventPublished() when $default != null:
return $default(_that.type,_that.notificationId,_that.id,_that.name,_that.description,_that.start,_that.image,_that.ownerId,_that.ownerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  int id,  String name,  String? description,  DateTime start,  String? image, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName)  $default,) {final _that = this;
switch (_that) {
case _WebsocketEventPublished():
return $default(_that.type,_that.notificationId,_that.id,_that.name,_that.description,_that.start,_that.image,_that.ownerId,_that.ownerName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: 'notification_id')  int notificationId,  int id,  String name,  String? description,  DateTime start,  String? image, @JsonKey(name: 'owner_id')  int ownerId, @JsonKey(name: 'owner_name')  String ownerName)?  $default,) {final _that = this;
switch (_that) {
case _WebsocketEventPublished() when $default != null:
return $default(_that.type,_that.notificationId,_that.id,_that.name,_that.description,_that.start,_that.image,_that.ownerId,_that.ownerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebsocketEventPublished implements WebsocketEventPublished {
  const _WebsocketEventPublished({this.type = "NewEventNotification", @JsonKey(name: 'notification_id') required this.notificationId, required this.id, required this.name, this.description, required this.start, this.image, @JsonKey(name: 'owner_id') required this.ownerId, @JsonKey(name: 'owner_name') required this.ownerName});
  factory _WebsocketEventPublished.fromJson(Map<String, dynamic> json) => _$WebsocketEventPublishedFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  int id;
@override final  String name;
@override final  String? description;
@override final  DateTime start;
@override final  String? image;
@override@JsonKey(name: 'owner_id') final  int ownerId;
@override@JsonKey(name: 'owner_name') final  String ownerName;

/// Create a copy of WebsocketEventPublished
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketEventPublishedCopyWith<_WebsocketEventPublished> get copyWith => __$WebsocketEventPublishedCopyWithImpl<_WebsocketEventPublished>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketEventPublishedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketEventPublished&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.image, image) || other.image == image)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name,description,start,image,ownerId,ownerName);

@override
String toString() {
  return 'WebsocketEventPublished(type: $type, notificationId: $notificationId, id: $id, name: $name, description: $description, start: $start, image: $image, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class _$WebsocketEventPublishedCopyWith<$Res> implements $WebsocketEventPublishedCopyWith<$Res> {
  factory _$WebsocketEventPublishedCopyWith(_WebsocketEventPublished value, $Res Function(_WebsocketEventPublished) _then) = __$WebsocketEventPublishedCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name, String? description, DateTime start, String? image,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName
});




}
/// @nodoc
class __$WebsocketEventPublishedCopyWithImpl<$Res>
    implements _$WebsocketEventPublishedCopyWith<$Res> {
  __$WebsocketEventPublishedCopyWithImpl(this._self, this._then);

  final _WebsocketEventPublished _self;
  final $Res Function(_WebsocketEventPublished) _then;

/// Create a copy of WebsocketEventPublished
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,Object? description = freezed,Object? start = null,Object? image = freezed,Object? ownerId = null,Object? ownerName = null,}) {
  return _then(_WebsocketEventPublished(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as int,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
