/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/user/types/user_scope.dart';
import 'package:hollybike/user/types/user_status.dart';

part 'minimal_user.freezed.dart';
part 'minimal_user.g.dart';

@freezed
sealed class MinimalUser with _$MinimalUser {
  const factory MinimalUser({
    required int id,
    required String username,
    required UserScope scope,
    required UserStatus status,
    @JsonKey(name: "profile_picture") String? profilePicture,
    @JsonKey(name: "profile_picture_key") String? profilePictureKey,
    String? role,
  }) = _MinimalUser;

  factory MinimalUser.fromJson(Map<String, dynamic> json) =>
      _$MinimalUserFromJson(json);

  factory MinimalUser.empty() => const MinimalUser(
        id: 0,
        username: '',
        scope: UserScope.user,
        status: UserStatus.enabled,
        profilePicture: null,
      );
}
