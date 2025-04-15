// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_subscribed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebsocketSubscribed {

 bool get subscribed; String get type;
/// Create a copy of WebsocketSubscribed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebsocketSubscribedCopyWith<WebsocketSubscribed> get copyWith => _$WebsocketSubscribedCopyWithImpl<WebsocketSubscribed>(this as WebsocketSubscribed, _$identity);

  /// Serializes this WebsocketSubscribed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebsocketSubscribed&&(identical(other.subscribed, subscribed) || other.subscribed == subscribed)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscribed,type);

@override
String toString() {
  return 'WebsocketSubscribed(subscribed: $subscribed, type: $type)';
}


}

/// @nodoc
abstract mixin class $WebsocketSubscribedCopyWith<$Res>  {
  factory $WebsocketSubscribedCopyWith(WebsocketSubscribed value, $Res Function(WebsocketSubscribed) _then) = _$WebsocketSubscribedCopyWithImpl;
@useResult
$Res call({
 bool subscribed, String type
});




}
/// @nodoc
class _$WebsocketSubscribedCopyWithImpl<$Res>
    implements $WebsocketSubscribedCopyWith<$Res> {
  _$WebsocketSubscribedCopyWithImpl(this._self, this._then);

  final WebsocketSubscribed _self;
  final $Res Function(WebsocketSubscribed) _then;

/// Create a copy of WebsocketSubscribed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscribed = null,Object? type = null,}) {
  return _then(_self.copyWith(
subscribed: null == subscribed ? _self.subscribed : subscribed // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _WebsocketSubscribed implements WebsocketSubscribed {
  const _WebsocketSubscribed({required this.subscribed, this.type = "subscribed"});
  factory _WebsocketSubscribed.fromJson(Map<String, dynamic> json) => _$WebsocketSubscribedFromJson(json);

@override final  bool subscribed;
@override@JsonKey() final  String type;

/// Create a copy of WebsocketSubscribed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebsocketSubscribedCopyWith<_WebsocketSubscribed> get copyWith => __$WebsocketSubscribedCopyWithImpl<_WebsocketSubscribed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebsocketSubscribedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebsocketSubscribed&&(identical(other.subscribed, subscribed) || other.subscribed == subscribed)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscribed,type);

@override
String toString() {
  return 'WebsocketSubscribed(subscribed: $subscribed, type: $type)';
}


}

/// @nodoc
abstract mixin class _$WebsocketSubscribedCopyWith<$Res> implements $WebsocketSubscribedCopyWith<$Res> {
  factory _$WebsocketSubscribedCopyWith(_WebsocketSubscribed value, $Res Function(_WebsocketSubscribed) _then) = __$WebsocketSubscribedCopyWithImpl;
@override @useResult
$Res call({
 bool subscribed, String type
});




}
/// @nodoc
class __$WebsocketSubscribedCopyWithImpl<$Res>
    implements _$WebsocketSubscribedCopyWith<$Res> {
  __$WebsocketSubscribedCopyWithImpl(this._self, this._then);

  final _WebsocketSubscribed _self;
  final $Res Function(_WebsocketSubscribed) _then;

/// Create a copy of WebsocketSubscribed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscribed = null,Object? type = null,}) {
  return _then(_WebsocketSubscribed(
subscribed: null == subscribed ? _self.subscribed : subscribed // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
