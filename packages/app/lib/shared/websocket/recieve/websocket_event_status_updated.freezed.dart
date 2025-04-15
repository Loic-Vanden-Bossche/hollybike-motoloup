// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_status_updated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketEventStatusUpdated {

 String get type; int get id;@JsonKey(name: 'notification_id') int get notificationId; EventStatusState get status; String get name; String? get description; String? get image;
/// Create a copy of WebsocketEventStatusUpdated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketEventStatusUpdatedCopyWith<WebsocketEventStatusUpdated> get copyWith => _$WebsocketEventStatusUpdatedCopyWithImpl<WebsocketEventStatusUpdated>(this as WebsocketEventStatusUpdated, _$identity);

  /// Serializes this WebsocketEventStatusUpdated to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketEventStatusUpdated&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,notificationId,status,name,description,image);

@override
String toString() {
  return 'WebsocketEventStatusUpdated(type: $type, id: $id, notificationId: $notificationId, status: $status, name: $name, description: $description, image: $image)';
}


}

/// @nodoc
abstract mixin class $WebsocketEventStatusUpdatedCopyWith<$Res>  {
  factory $WebsocketEventStatusUpdatedCopyWith(WebsocketEventStatusUpdated value, $Res Function(WebsocketEventStatusUpdated) _then) = _$WebsocketEventStatusUpdatedCopyWithImpl;
@useResult
$Res call({
 String type, int id,@JsonKey(name: 'notification_id') int notificationId, EventStatusState status, String name, String? description, String? image
});




}
/// @nodoc
class _$WebsocketEventStatusUpdatedCopyWithImpl<$Res>
    implements $WebsocketEventStatusUpdatedCopyWith<$Res> {
  _$WebsocketEventStatusUpdatedCopyWithImpl(this._self, this._then);

  final WebsocketEventStatusUpdated _self;
  final $Res Function(WebsocketEventStatusUpdated) _then;

/// Create a copy of WebsocketEventStatusUpdated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? notificationId = null,Object? status = null,Object? name = null,Object? description = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatusState,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketEventStatusUpdated implements WebsocketEventStatusUpdated {
  const _WebsocketEventStatusUpdated({this.type = "EventStatusUpdateNotification", required this.id, @JsonKey(name: 'notification_id') required this.notificationId, required this.status, required this.name, this.description, this.image});
  factory _WebsocketEventStatusUpdated.fromJson(Map<String, dynamic> json) => _$WebsocketEventStatusUpdatedFromJson(json);

@override@JsonKey() final  String type;
@override final  int id;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  EventStatusState status;
@override final  String name;
@override final  String? description;
@override final  String? image;

/// Create a copy of WebsocketEventStatusUpdated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketEventStatusUpdatedCopyWith<_WebsocketEventStatusUpdated> get copyWith => __$WebsocketEventStatusUpdatedCopyWithImpl<_WebsocketEventStatusUpdated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketEventStatusUpdatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketEventStatusUpdated&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,notificationId,status,name,description,image);

@override
String toString() {
  return 'WebsocketEventStatusUpdated(type: $type, id: $id, notificationId: $notificationId, status: $status, name: $name, description: $description, image: $image)';
}


}

/// @nodoc
abstract mixin class _$WebsocketEventStatusUpdatedCopyWith<$Res> implements $WebsocketEventStatusUpdatedCopyWith<$Res> {
  factory _$WebsocketEventStatusUpdatedCopyWith(_WebsocketEventStatusUpdated value, $Res Function(_WebsocketEventStatusUpdated) _then) = __$WebsocketEventStatusUpdatedCopyWithImpl;
@override @useResult
$Res call({
 String type, int id,@JsonKey(name: 'notification_id') int notificationId, EventStatusState status, String name, String? description, String? image
});




}
/// @nodoc
class __$WebsocketEventStatusUpdatedCopyWithImpl<$Res>
    implements _$WebsocketEventStatusUpdatedCopyWith<$Res> {
  __$WebsocketEventStatusUpdatedCopyWithImpl(this._self, this._then);

  final _WebsocketEventStatusUpdated _self;
  final $Res Function(_WebsocketEventStatusUpdated) _then;

/// Create a copy of WebsocketEventStatusUpdated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? notificationId = null,Object? status = null,Object? name = null,Object? description = freezed,Object? image = freezed,}) {
  return _then(_WebsocketEventStatusUpdated(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatusState,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
