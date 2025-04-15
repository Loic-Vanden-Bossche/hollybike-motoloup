// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MinimalUser implements DiagnosticableTreeMixin {

 int get id; String get username; UserScope get scope; UserStatus get status;@JsonKey(name: "profile_picture") String? get profilePicture;@JsonKey(name: "profile_picture_key") String? get profilePictureKey; String? get role;
/// Create a copy of MinimalUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<MinimalUser> get copyWith => _$MinimalUserCopyWithImpl<MinimalUser>(this as MinimalUser, _$identity);

  /// Serializes this MinimalUser to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MinimalUser'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('username', username))..add(DiagnosticsProperty('scope', scope))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('profilePicture', profilePicture))..add(DiagnosticsProperty('profilePictureKey', profilePictureKey))..add(DiagnosticsProperty('role', role));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinimalUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.status, status) || other.status == status)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.profilePictureKey, profilePictureKey) || other.profilePictureKey == profilePictureKey)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,scope,status,profilePicture,profilePictureKey,role);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MinimalUser(id: $id, username: $username, scope: $scope, status: $status, profilePicture: $profilePicture, profilePictureKey: $profilePictureKey, role: $role)';
}


}

/// @nodoc
abstract mixin class $MinimalUserCopyWith<$Res>  {
  factory $MinimalUserCopyWith(MinimalUser value, $Res Function(MinimalUser) _then) = _$MinimalUserCopyWithImpl;
@useResult
$Res call({
 int id, String username, UserScope scope, UserStatus status,@JsonKey(name: "profile_picture") String? profilePicture,@JsonKey(name: "profile_picture_key") String? profilePictureKey, String? role
});




}
/// @nodoc
class _$MinimalUserCopyWithImpl<$Res>
    implements $MinimalUserCopyWith<$Res> {
  _$MinimalUserCopyWithImpl(this._self, this._then);

  final MinimalUser _self;
  final $Res Function(MinimalUser) _then;

/// Create a copy of MinimalUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? scope = null,Object? status = null,Object? profilePicture = freezed,Object? profilePictureKey = freezed,Object? role = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as UserScope,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,profilePictureKey: freezed == profilePictureKey ? _self.profilePictureKey : profilePictureKey // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MinimalUser with DiagnosticableTreeMixin implements MinimalUser {
  const _MinimalUser({required this.id, required this.username, required this.scope, required this.status, @JsonKey(name: "profile_picture") this.profilePicture, @JsonKey(name: "profile_picture_key") this.profilePictureKey, this.role});
  factory _MinimalUser.fromJson(Map<String, dynamic> json) => _$MinimalUserFromJson(json);

@override final  int id;
@override final  String username;
@override final  UserScope scope;
@override final  UserStatus status;
@override@JsonKey(name: "profile_picture") final  String? profilePicture;
@override@JsonKey(name: "profile_picture_key") final  String? profilePictureKey;
@override final  String? role;

/// Create a copy of MinimalUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinimalUserCopyWith<_MinimalUser> get copyWith => __$MinimalUserCopyWithImpl<_MinimalUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinimalUserToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MinimalUser'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('username', username))..add(DiagnosticsProperty('scope', scope))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('profilePicture', profilePicture))..add(DiagnosticsProperty('profilePictureKey', profilePictureKey))..add(DiagnosticsProperty('role', role));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinimalUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.status, status) || other.status == status)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.profilePictureKey, profilePictureKey) || other.profilePictureKey == profilePictureKey)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,scope,status,profilePicture,profilePictureKey,role);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MinimalUser(id: $id, username: $username, scope: $scope, status: $status, profilePicture: $profilePicture, profilePictureKey: $profilePictureKey, role: $role)';
}


}

/// @nodoc
abstract mixin class _$MinimalUserCopyWith<$Res> implements $MinimalUserCopyWith<$Res> {
  factory _$MinimalUserCopyWith(_MinimalUser value, $Res Function(_MinimalUser) _then) = __$MinimalUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, UserScope scope, UserStatus status,@JsonKey(name: "profile_picture") String? profilePicture,@JsonKey(name: "profile_picture_key") String? profilePictureKey, String? role
});




}
/// @nodoc
class __$MinimalUserCopyWithImpl<$Res>
    implements _$MinimalUserCopyWith<$Res> {
  __$MinimalUserCopyWithImpl(this._self, this._then);

  final _MinimalUser _self;
  final $Res Function(_MinimalUser) _then;

/// Create a copy of MinimalUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? scope = null,Object? status = null,Object? profilePicture = freezed,Object? profilePictureKey = freezed,Object? role = freezed,}) {
  return _then(_MinimalUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as UserScope,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,profilePictureKey: freezed == profilePictureKey ? _self.profilePictureKey : profilePictureKey // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
