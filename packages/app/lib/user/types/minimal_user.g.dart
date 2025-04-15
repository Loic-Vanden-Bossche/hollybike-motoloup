// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MinimalUser _$MinimalUserFromJson(Map<String, dynamic> json) => _MinimalUser(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  scope: $enumDecode(_$UserScopeEnumMap, json['scope']),
  status: $enumDecode(_$UserStatusEnumMap, json['status']),
  profilePicture: json['profile_picture'] as String?,
  profilePictureKey: json['profile_picture_key'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$MinimalUserToJson(_MinimalUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'scope': _$UserScopeEnumMap[instance.scope]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'profile_picture': instance.profilePicture,
      'profile_picture_key': instance.profilePictureKey,
      'role': instance.role,
    };

const _$UserScopeEnumMap = {
  UserScope.root: 'Root',
  UserScope.admin: 'Admin',
  UserScope.user: 'User',
};

const _$UserStatusEnumMap = {
  UserStatus.enabled: 'Enabled',
  UserStatus.disabled: 'Disabled',
};
