// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_added_to_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketAddedToEvent {

 String get type;@JsonKey(name: 'notification_id') int get notificationId; int get id; String get name;
/// Create a copy of WebsocketAddedToEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketAddedToEventCopyWith<WebsocketAddedToEvent> get copyWith => _$WebsocketAddedToEventCopyWithImpl<WebsocketAddedToEvent>(this as WebsocketAddedToEvent, _$identity);

  /// Serializes this WebsocketAddedToEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketAddedToEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name);

@override
String toString() {
  return 'WebsocketAddedToEvent(type: $type, notificationId: $notificationId, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $WebsocketAddedToEventCopyWith<$Res>  {
  factory $WebsocketAddedToEventCopyWith(WebsocketAddedToEvent value, $Res Function(WebsocketAddedToEvent) _then) = _$WebsocketAddedToEventCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name
});




}
/// @nodoc
class _$WebsocketAddedToEventCopyWithImpl<$Res>
    implements $WebsocketAddedToEventCopyWith<$Res> {
  _$WebsocketAddedToEventCopyWithImpl(this._self, this._then);

  final WebsocketAddedToEvent _self;
  final $Res Function(WebsocketAddedToEvent) _then;

/// Create a copy of WebsocketAddedToEvent
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

class _WebsocketAddedToEvent implements WebsocketAddedToEvent {
  const _WebsocketAddedToEvent({this.type = "AddedToEventNotification", @JsonKey(name: 'notification_id') required this.notificationId, required this.id, required this.name});
  factory _WebsocketAddedToEvent.fromJson(Map<String, dynamic> json) => _$WebsocketAddedToEventFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(name: 'notification_id') final  int notificationId;
@override final  int id;
@override final  String name;

/// Create a copy of WebsocketAddedToEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketAddedToEventCopyWith<_WebsocketAddedToEvent> get copyWith => __$WebsocketAddedToEventCopyWithImpl<_WebsocketAddedToEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketAddedToEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketAddedToEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,notificationId,id,name);

@override
String toString() {
  return 'WebsocketAddedToEvent(type: $type, notificationId: $notificationId, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WebsocketAddedToEventCopyWith<$Res> implements $WebsocketAddedToEventCopyWith<$Res> {
  factory _$WebsocketAddedToEventCopyWith(_WebsocketAddedToEvent value, $Res Function(_WebsocketAddedToEvent) _then) = __$WebsocketAddedToEventCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'notification_id') int notificationId, int id, String name
});




}
/// @nodoc
class __$WebsocketAddedToEventCopyWithImpl<$Res>
    implements _$WebsocketAddedToEventCopyWith<$Res> {
  __$WebsocketAddedToEventCopyWithImpl(this._self, this._then);

  final _WebsocketAddedToEvent _self;
  final $Res Function(_WebsocketAddedToEvent) _then;

/// Create a copy of WebsocketAddedToEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? notificationId = null,Object? id = null,Object? name = null,}) {
  return _then(_WebsocketAddedToEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
