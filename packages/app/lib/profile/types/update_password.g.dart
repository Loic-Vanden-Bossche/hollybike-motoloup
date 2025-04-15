// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdatePassword _$UpdatePasswordFromJson(Map<String, dynamic> json) =>
    _UpdatePassword(
      oldPassword: json['old_password'] as String,
      newPassword: json['new_password'] as String,
      newPasswordAgain: json['new_password_again'] as String,
    );

Map<String, dynamic> _$UpdatePasswordToJson(_UpdatePassword instance) =>
    <String, dynamic>{
      'old_password': instance.oldPassword,
      'new_password': instance.newPassword,
      'new_password_again': instance.newPasswordAgain,
    };
