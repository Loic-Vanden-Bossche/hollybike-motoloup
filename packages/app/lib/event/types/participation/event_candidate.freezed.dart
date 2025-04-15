// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventCandidate {

 int get id; String get username;@JsonKey(name: "is_owner") bool get isOwner;@JsonKey(name: "profile_picture") String? get profilePicture;@JsonKey(name: "profile_picture_key") String? get profilePictureKey;@JsonKey(name: "event_role") EventRole? get eventRole;
/// Create a copy of EventCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCandidateCopyWith<EventCandidate> get copyWith => _$EventCandidateCopyWithImpl<EventCandidate>(this as EventCandidate, _$identity);

  /// Serializes this EventCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.profilePictureKey, profilePictureKey) || other.profilePictureKey == profilePictureKey)&&(identical(other.eventRole, eventRole) || other.eventRole == eventRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,isOwner,profilePicture,profilePictureKey,eventRole);

@override
String toString() {
  return 'EventCandidate(id: $id, username: $username, isOwner: $isOwner, profilePicture: $profilePicture, profilePictureKey: $profilePictureKey, eventRole: $eventRole)';
}


}

/// @nodoc
abstract mixin class $EventCandidateCopyWith<$Res>  {
  factory $EventCandidateCopyWith(EventCandidate value, $Res Function(EventCandidate) _then) = _$EventCandidateCopyWithImpl;
@useResult
$Res call({
 int id, String username,@JsonKey(name: "is_owner") bool isOwner,@JsonKey(name: "profile_picture") String? profilePicture,@JsonKey(name: "profile_picture_key") String? profilePictureKey,@JsonKey(name: "event_role") EventRole? eventRole
});




}
/// @nodoc
class _$EventCandidateCopyWithImpl<$Res>
    implements $EventCandidateCopyWith<$Res> {
  _$EventCandidateCopyWithImpl(this._self, this._then);

  final EventCandidate _self;
  final $Res Function(EventCandidate) _then;

/// Create a copy of EventCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? isOwner = null,Object? profilePicture = freezed,Object? profilePictureKey = freezed,Object? eventRole = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,profilePictureKey: freezed == profilePictureKey ? _self.profilePictureKey : profilePictureKey // ignore: cast_nullable_to_non_nullable
as String?,eventRole: freezed == eventRole ? _self.eventRole : eventRole // ignore: cast_nullable_to_non_nullable
as EventRole?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _EventCandidate implements EventCandidate {
  const _EventCandidate({required this.id, required this.username, @JsonKey(name: "is_owner") required this.isOwner, @JsonKey(name: "profile_picture") this.profilePicture, @JsonKey(name: "profile_picture_key") this.profilePictureKey, @JsonKey(name: "event_role") this.eventRole});
  factory _EventCandidate.fromJson(Map<String, dynamic> json) => _$EventCandidateFromJson(json);

@override final  int id;
@override final  String username;
@override@JsonKey(name: "is_owner") final  bool isOwner;
@override@JsonKey(name: "profile_picture") final  String? profilePicture;
@override@JsonKey(name: "profile_picture_key") final  String? profilePictureKey;
@override@JsonKey(name: "event_role") final  EventRole? eventRole;

/// Create a copy of EventCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCandidateCopyWith<_EventCandidate> get copyWith => __$EventCandidateCopyWithImpl<_EventCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.profilePictureKey, profilePictureKey) || other.profilePictureKey == profilePictureKey)&&(identical(other.eventRole, eventRole) || other.eventRole == eventRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,isOwner,profilePicture,profilePictureKey,eventRole);

@override
String toString() {
  return 'EventCandidate(id: $id, username: $username, isOwner: $isOwner, profilePicture: $profilePicture, profilePictureKey: $profilePictureKey, eventRole: $eventRole)';
}


}

/// @nodoc
abstract mixin class _$EventCandidateCopyWith<$Res> implements $EventCandidateCopyWith<$Res> {
  factory _$EventCandidateCopyWith(_EventCandidate value, $Res Function(_EventCandidate) _then) = __$EventCandidateCopyWithImpl;
@override @useResult
$Res call({
 int id, String username,@JsonKey(name: "is_owner") bool isOwner,@JsonKey(name: "profile_picture") String? profilePicture,@JsonKey(name: "profile_picture_key") String? profilePictureKey,@JsonKey(name: "event_role") EventRole? eventRole
});




}
/// @nodoc
class __$EventCandidateCopyWithImpl<$Res>
    implements _$EventCandidateCopyWith<$Res> {
  __$EventCandidateCopyWithImpl(this._self, this._then);

  final _EventCandidate _self;
  final $Res Function(_EventCandidate) _then;

/// Create a copy of EventCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? isOwner = null,Object? profilePicture = freezed,Object? profilePictureKey = freezed,Object? eventRole = freezed,}) {
  return _then(_EventCandidate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,profilePictureKey: freezed == profilePictureKey ? _self.profilePictureKey : profilePictureKey // ignore: cast_nullable_to_non_nullable
as String?,eventRole: freezed == eventRole ? _self.eventRole : eventRole // ignore: cast_nullable_to_non_nullable
as EventRole?,
  ));
}


}

// dart format on
