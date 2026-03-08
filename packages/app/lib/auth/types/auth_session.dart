/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';

import 'package:hollybike/shared/utils/verify_object_attributes_not_null.dart';

class AuthSession {
  String token;
  String refreshToken;
  String deviceId;
  String host;
  String email;

  AuthSession({
    required this.token,
    required this.host,
    required this.refreshToken,
    required this.deviceId,
    required this.email,
  });

  Map<String, dynamic> asMap() {
    return {
      "token": token,
      "refresh_token": refreshToken,
      "device_id": deviceId,
      "host": host,
      "email": email,
    };
  }

  String toJson() {
    return json.encode(asMap());
  }

  @override
  int get hashCode {
    return Object.hash(token, refreshToken, deviceId, host, email);
  }

  @override
  bool operator ==(covariant AuthSession other) {
    return host == other.host &&
        token == other.token &&
        refreshToken == other.refreshToken &&
        deviceId == other.deviceId &&
        email == other.email;
  }

  int? getIndexInList(List<AuthSession> list) {
    if (list.isNotEmpty) {
      int index;
      for (index = 0; index < list.length; index++) {
        final sessionFromIndex = list[index];
        if (this == sessionFromIndex) {
          return index;
        }
      }
    }
    return null;
  }

  factory AuthSession.fromJson(String json) {
    final object = jsonDecode(json);

    verifyObjectAttributesNotNull(object, [
      "token",
      "refresh_token",
      "device_id",
      "host",
    ]);

    return AuthSession(
      token: object["token"] as String,
      refreshToken: object["refresh_token"] as String,
      deviceId: object["device_id"] as String,
      host: object["host"] as String,
      // Backward-compatible: sessions persisted before this field was added
      // will not have "email"; default to empty string so the deduplication
      // logic can fall back to deviceId for those legacy entries.
      email: object["email"] as String? ?? '',
    );
  }

  factory AuthSession.fromResponseJson(
    String hostSource,
    String emailSource,
    Map<String, dynamic> json,
  ) {
    verifyObjectAttributesNotNull(json, ["token", "refresh_token", "deviceId"]);

    return AuthSession(
      token: json["token"] as String,
      refreshToken: json["refresh_token"] as String,
      deviceId: json["deviceId"] as String,
      host: hostSource,
      email: emailSource,
    );
  }
}
