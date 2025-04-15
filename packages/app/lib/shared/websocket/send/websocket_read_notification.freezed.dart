// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
