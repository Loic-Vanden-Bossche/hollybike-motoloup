// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_updated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketEventUpdated {

 String get type;@JsonKey(name: 'notification_id') int get notificationId; int get id; String get name; String? get description; DateTime get start; String? get image;@JsonKey(name: 'owner_id') int get ownerId;@JsonKey(name: 'owner_name') String get ownerName;
/// Create a copy of WebsocketEventUpdated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketEventUpdatedCopyWith<WebsocketEventUpdated> get copyWith => _$WebsocketEventUpdatedCopyWithImpl<WebsocketEventUpdated>(this as WebsocketEventUpdated, _$identity);

  /// Serializes this WebsocketEventUpdated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketEventUpdated&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.image, image) || other.image == image)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name,description,start,image,ownerId,ownerName);

@override
String toString() {
  return 'WebsocketEventUpdated(type: $type, notificationId: $notificationId, id: $id, name: $name, description: $description, start: $start, image: $image, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class $WebsocketEventUpdatedCopyWith<$Res>  {
  factory $WebsocketEventUpdatedCopyWith(WebsocketEventUpdated value, $Res Function(WebsocketEventUpdated) _then) = _$WebsocketEventUpdatedCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name, String? description, DateTime start, String? image,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName
});




}
/// @nodoc
class _$WebsocketEventUpdatedCopyWithImpl<$Res>
    implements $WebsocketEventUpdatedCopyWith<$Res> {
  _$WebsocketEventUpdatedCopyWithImpl(this._self, this._then);

  final WebsocketEventUpdated _self;
  final $Res Function(WebsocketEventUpdated) _then;

/// Create a copy of WebsocketEventUpdated
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


/// @nodoc
@JsonSerializable()

class _WebsocketEventUpdated implements WebsocketEventUpdated {
  const _WebsocketEventUpdated({this.type = "UpdateEventNotification", @JsonKey(name: 'notification_id') required this.notificationId, required this.id, required this.name, this.description, required this.start, this.image, @JsonKey(name: 'owner_id') required this.ownerId, @JsonKey(name: 'owner_name') required this.ownerName});
  factory _WebsocketEventUpdated.fromJson(Map<String, dynamic> json) => _$WebsocketEventUpdatedFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  int id;
@override final  String name;
@override final  String? description;
@override final  DateTime start;
@override final  String? image;
@override@JsonKey(name: 'owner_id') final  int ownerId;
@override@JsonKey(name: 'owner_name') final  String ownerName;

/// Create a copy of WebsocketEventUpdated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketEventUpdatedCopyWith<_WebsocketEventUpdated> get copyWith => __$WebsocketEventUpdatedCopyWithImpl<_WebsocketEventUpdated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketEventUpdatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketEventUpdated&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.image, image) || other.image == image)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name,description,start,image,ownerId,ownerName);

@override
String toString() {
  return 'WebsocketEventUpdated(type: $type, notificationId: $notificationId, id: $id, name: $name, description: $description, start: $start, image: $image, ownerId: $ownerId, ownerName: $ownerName)';
}


}

/// @nodoc
abstract mixin class _$WebsocketEventUpdatedCopyWith<$Res> implements $WebsocketEventUpdatedCopyWith<$Res> {
  factory _$WebsocketEventUpdatedCopyWith(_WebsocketEventUpdated value, $Res Function(_WebsocketEventUpdated) _then) = __$WebsocketEventUpdatedCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name, String? description, DateTime start, String? image,@JsonKey(name: 'owner_id') int ownerId,@JsonKey(name: 'owner_name') String ownerName
});




}
/// @nodoc
class __$WebsocketEventUpdatedCopyWithImpl<$Res>
    implements _$WebsocketEventUpdatedCopyWith<$Res> {
  __$WebsocketEventUpdatedCopyWithImpl(this._self, this._then);

  final _WebsocketEventUpdated _self;
  final $Res Function(_WebsocketEventUpdated) _then;

/// Create a copy of WebsocketEventUpdated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,Object? description = freezed,Object? start = null,Object? image = freezed,Object? ownerId = null,Object? ownerName = null,}) {
  return _then(_WebsocketEventUpdated(
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
