// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_removed_from_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketRemovedFromEvent {

 String get type;@JsonKey(name: 'notification_id') int get notificationId; int get id; String get name;
/// Create a copy of WebsocketRemovedFromEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketRemovedFromEventCopyWith<WebsocketRemovedFromEvent> get copyWith => _$WebsocketRemovedFromEventCopyWithImpl<WebsocketRemovedFromEvent>(this as WebsocketRemovedFromEvent, _$identity);

  /// Serializes this WebsocketRemovedFromEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketRemovedFromEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name);

@override
String toString() {
  return 'WebsocketRemovedFromEvent(type: $type, notificationId: $notificationId, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $WebsocketRemovedFromEventCopyWith<$Res>  {
  factory $WebsocketRemovedFromEventCopyWith(WebsocketRemovedFromEvent value, $Res Function(WebsocketRemovedFromEvent) _then) = _$WebsocketRemovedFromEventCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name
});




}
/// @nodoc
class _$WebsocketRemovedFromEventCopyWithImpl<$Res>
    implements $WebsocketRemovedFromEventCopyWith<$Res> {
  _$WebsocketRemovedFromEventCopyWithImpl(this._self, this._then);

  final WebsocketRemovedFromEvent _self;
  final $Res Function(WebsocketRemovedFromEvent) _then;

/// Create a copy of WebsocketRemovedFromEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketRemovedFromEvent implements WebsocketRemovedFromEvent {
  const _WebsocketRemovedFromEvent({this.type = "RemovedFromEventNotification", @JsonKey(name: 'notification_id') required this.notificationId, required this.id, required this.name});
  factory _WebsocketRemovedFromEvent.fromJson(Map<String, dynamic> json) => _$WebsocketRemovedFromEventFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  int id;
@override final  String name;

/// Create a copy of WebsocketRemovedFromEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketRemovedFromEventCopyWith<_WebsocketRemovedFromEvent> get copyWith => __$WebsocketRemovedFromEventCopyWithImpl<_WebsocketRemovedFromEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketRemovedFromEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketRemovedFromEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name);

@override
String toString() {
  return 'WebsocketRemovedFromEvent(type: $type, notificationId: $notificationId, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WebsocketRemovedFromEventCopyWith<$Res> implements $WebsocketRemovedFromEventCopyWith<$Res> {
  factory _$WebsocketRemovedFromEventCopyWith(_WebsocketRemovedFromEvent value, $Res Function(_WebsocketRemovedFromEvent) _then) = __$WebsocketRemovedFromEventCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name
});




}
/// @nodoc
class __$WebsocketRemovedFromEventCopyWithImpl<$Res>
    implements _$WebsocketRemovedFromEventCopyWith<$Res> {
  __$WebsocketRemovedFromEventCopyWithImpl(this._self, this._then);

  final _WebsocketRemovedFromEvent _self;
  final $Res Function(_WebsocketRemovedFromEvent) _then;

/// Create a copy of WebsocketRemovedFromEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,}) {
  return _then(_WebsocketRemovedFromEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
