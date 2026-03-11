import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../auth/services/auth_persistence.dart';
import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import 'app_notifications.dart';
import 'notification_nav_intent.dart';

class RealtimeNotificationsFacade {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final AuthPersistence _authPersistence = AuthPersistence();

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<String>? _onTokenRefreshSubscription;
  AuthSession? _activeSession;

  Future<bool> connectNotifications(AuthSession session) async {
    if (await _isOnPremiseBackend(session)) {
      _activeSession = null;
      return false;
    }

    final initialized = await _initialize();
    if (!initialized) {
      _activeSession = null;
      return false;
    }

    _activeSession = session;
    await _registerCurrentToken(session);

    await _onMessageSubscription?.cancel();
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(
      (message) async {
        final payload = _parsePayload(message.data);
        if (payload == null) return;

        await AppNotifications.showOneShot(
          channelId: AppNotifications.eventUpdates,
          title: payload.title,
          body: payload.body,
          payload: jsonEncode(message.data),
        );

        if (payload.notificationId != null) {
          await _markNotificationSeen(payload.notificationId!);
        }
      },
    );

    await _onMessageOpenedAppSubscription?.cancel();
    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((message) async {
          final payload = _parsePayload(message.data);
          if (payload == null) return;
          await _handleTap(payload);
        });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = _parsePayload(initialMessage.data);
      if (payload != null) {
        await _handleTap(payload);
      }
    }

    await _onTokenRefreshSubscription?.cancel();
    _onTokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) {
      final activeSession = _activeSession;
      if (activeSession == null) return;
      _registerToken(activeSession, token);
    });

    return true;
  }

  Future<void> disconnect() async {
    final activeSession = _activeSession;
    _activeSession = null;

    await _onMessageSubscription?.cancel();
    _onMessageSubscription = null;
    await _onMessageOpenedAppSubscription?.cancel();
    _onMessageOpenedAppSubscription = null;
    await _onTokenRefreshSubscription?.cancel();
    _onTokenRefreshSubscription = null;

    if (activeSession != null) {
      await _unregisterToken(activeSession);
    }
  }

  Future<bool> _initialize() async {
    try {
      await AppNotifications.init(onTapPayload: _onLocalNotificationTapped);

      final status = await Permission.notification.request();
      if (!status.isGranted) {
        return false;
      }

      await _messaging.requestPermission();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isOnPremiseBackend(AuthSession session) async {
    try {
      final response =
          await DioClient(host: session.host).dio.get('/api/on-premise');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['is_on_premise'] == true;
      }
      if (data is Map) {
        return data['is_on_premise'] == true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _registerCurrentToken(AuthSession session) async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        return;
      }
      await _registerToken(session, token);
    } catch (_) {
      // Best effort token registration.
    }
  }

  Future<void> _registerToken(AuthSession session, String token) async {
    if (session.deviceId.trim().isEmpty || token.trim().isEmpty) {
      return;
    }

    await _authorizedRequest(
      session: session,
      method: 'POST',
      path: '/api/notifications/tokens',
      data: {
        'device_id': session.deviceId,
        'platform': 'android',
        'token': token,
        'host': session.host,
      },
    );
  }

  Future<void> _unregisterToken(AuthSession session) async {
    if (session.deviceId.trim().isEmpty) {
      return;
    }

    await _authorizedRequest(
      session: session,
      method: 'DELETE',
      path: '/api/notifications/tokens',
      data: {
        'device_id': session.deviceId,
        'platform': 'android',
        'host': session.host,
      },
    );
  }

  Future<void> _markNotificationSeen(int notificationId) async {
    final activeSession = _activeSession ?? await _authPersistence.currentSession;
    if (activeSession == null) {
      return;
    }

    await _authorizedRequest(
      session: activeSession,
      method: 'PUT',
      path: '/api/notifications/$notificationId/seen',
    );
  }

  Future<void> _authorizedRequest({
    required AuthSession session,
    required String method,
    required String path,
    Map<String, dynamic>? data,
  }) async {
    try {
      await DioClient(
        host: session.host,
        authPersistence: _authPersistence,
      ).dio.request(
        path,
        data: data,
        options: Options(
          method: method,
          contentType: Headers.jsonContentType,
        ),
      );
    } catch (_) {
      // Best effort only.
    }
  }

  Future<void> _handleTap(_NotificationPayload payload) async {
    if (payload.notificationId != null) {
      await _markNotificationSeen(payload.notificationId!);
    }
    NotificationNavIntent.push(payload.eventId);
  }

  Future<void> _onLocalNotificationTapped(String? rawPayload) async {
    if (rawPayload == null || rawPayload.isEmpty) {
      NotificationNavIntent.push(null);
      return;
    }

    final decoded = jsonDecode(rawPayload);
    if (decoded is! Map<String, dynamic>) {
      NotificationNavIntent.push(null);
      return;
    }

    final payload = _parsePayload(decoded);
    if (payload == null) {
      NotificationNavIntent.push(null);
      return;
    }
    await _handleTap(payload);
  }

  _NotificationPayload? _parsePayload(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    if (type == null || type.isEmpty) {
      return null;
    }

    final title = data['title']?.toString() ?? 'Hollybike';
    final body = data['body']?.toString() ?? 'Nouvelle notification';
    final notificationId = int.tryParse(data['notification_id']?.toString() ?? '');
    final eventId = int.tryParse(data['event_id']?.toString() ?? '');

    return _NotificationPayload(
      type: type,
      title: title,
      body: body,
      notificationId: notificationId,
      eventId: eventId,
    );
  }
}

class _NotificationPayload {
  const _NotificationPayload({
    required this.type,
    required this.title,
    required this.body,
    required this.notificationId,
    required this.eventId,
  });

  final String type;
  final String title;
  final String body;
  final int? notificationId;
  final int? eventId;
}
