/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/json_map.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_added_to_event.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_deleted.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_published.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_status_updated.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_event_updated.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_removed_from_event.dart';
import 'package:hollybike/shared/websocket/send/websocket_read_notification.dart';
import 'package:hollybike/shared/websocket/send/websocket_stop_send_position.dart';
import 'package:hollybike/shared/websocket/websocket_message.dart';

import 'recieve/websocket_error.dart';
import 'recieve/websocket_receive_position.dart';
import 'recieve/websocket_stop_receive_position.dart';
import 'recieve/websocket_subscribed.dart';
import 'send/websocket_send_position.dart';
import 'send/websocket_subscribe.dart';

class WebsocketClient {
  final AuthSession session;
  final AuthPersistence? authPersistence;
  final DioClient _refreshClient;

  WebSocket? _client;

  WebsocketClient({required this.session, this.authPersistence})
      : _refreshClient = DioClient(host: session.host);

  Future<WebsocketClient> connect() async {
    math.Random r = math.Random();
    String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(256)));

    HttpClient client = HttpClient();
    HttpClientRequest request = await client.getUrl(
      Uri.parse('${session.host}/api/connect'),
    );
    request.headers.add('Connection', 'upgrade');
    request.headers.add('Upgrade', 'websocket');
    request.headers.add('sec-websocket-version', '13');
    request.headers.add('sec-websocket-key', key);

    HttpClientResponse response = await request.close();
    Socket socket = await response.detachSocket();

    final ws = WebSocket.fromUpgradedSocket(socket, serverSide: false);

    _client = ws;

    return this;
  }

  void pingInterval(int seconds) {
    _client?.pingInterval = Duration(seconds: seconds);
  }

  void onDisconnect(void Function() onDisconnect) {
    _client?.done.then((_) {
      onDisconnect();
    });
  }

  void _send(String message) {
    if (_client == null) {
      log('Trying to send message to a closed connection.');
      return;
    }

    log('Sending message: $message', name: 'WebsocketClient._send');

    _client?.add(message);
  }

  void close() {
    _client?.close();
  }

  WebsocketMessage parseMessage(String data) {
    return WebsocketMessage.fromJson(jsonDecode(data), (rawJson) {
      final json = rawJson as JsonMap;
      switch (json['type']) {
        case 'subscribed':
          return WebsocketSubscribed.fromJson(json);
        case 'receive-user-position':
          return WebsocketReceivePosition.fromJson(json);
        case 'stop-receive-user-position':
          return WebsocketStopReceivePosition.fromJson(json);
        case 'EventStatusUpdateNotification':
          return WebsocketEventStatusUpdated.fromJson(json);
        case 'AddedToEventNotification':
          return WebsocketAddedToEvent.fromJson(json);
        case 'RemovedFromEventNotification':
          return WebsocketRemovedFromEvent.fromJson(json);
        case 'DeleteEventNotification':
          return WebsocketEventDeleted.fromJson(json);
        case 'UpdateEventNotification':
          return WebsocketEventUpdated.fromJson(json);
        case 'NewEventNotification':
          return WebsocketEventPublished.fromJson(json);
        case 'error':
          return WebsocketError.fromJson(json);
      }

      throw Exception('Unknown message type: ${json['type']}');
    });
  }

  Stream<WebsocketMessage> get stream {
    return _client!.asBroadcastStream().map((event) {
      log('Received message: $event', name: 'WebsocketClient.stream');
      return parseMessage(event);
    });
  }

  void listen(void Function(WebsocketMessage) onData) {
    _client?.listen((data) {
      try {
        log('Received message: $data', name: 'WebsocketClient.listen');
        onData(parseMessage(data));
      } catch (e) {
        log('Error parsing message: $e', name: 'WebsocketClient.listen');
      }
    });
  }

  Future<void> subscribe(String channel) async {
    log('Subscribing to channel: $channel', name: 'WebsocketClient.subscribe');
    final token = await _tokenForSubscription();
    _sendMessage(channel, WebsocketSubscribe(token: token));
  }

  Future<AuthSession?> renewSessionIfPossible() async {
    await _hydrateSessionFromPersistence();

    if (!_hasRefreshCredentials) {
      log(
        'Skipping websocket session renewal: missing refresh credentials',
        name: 'WebsocketClient.renewSessionIfPossible',
      );
      return null;
    }

    try {
      return await _renewSessionIfNeeded(session);
    } catch (e) {
      log(
        'Failed to renew websocket session: $e',
        name: 'WebsocketClient.renewSessionIfPossible',
      );
      return null;
    }
  }

  Future<String> _tokenForSubscription() async {
    await _hydrateSessionFromPersistence();

    if (!_hasRefreshCredentials) {
      return session.token;
    }

    if (!_isJwtExpiredOrNearExpiry(session.token)) {
      return session.token;
    }

    try {
      final refreshedSession = await _renewSessionIfNeeded(session);
      return refreshedSession?.token ?? session.token;
    } catch (e) {
      log('Failed to renew websocket JWT: $e', name: 'WebsocketClient');
      return session.token;
    }
  }

  bool get _hasRefreshCredentials =>
      session.refreshToken.isNotEmpty && session.deviceId.isNotEmpty;

  Future<void> _hydrateSessionFromPersistence() async {
    final persistence = authPersistence;
    if (persistence == null) {
      return;
    }

    final persistedSession = await _findBestPersistedSession(
      persistence,
      session,
    );

    if (persistedSession != null) {
      _applySessionUpdate(persistedSession);
    }
  }

  bool _isJwtExpiredOrNearExpiry(
    String token, {
    Duration threshold = const Duration(seconds: 30),
  }) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return false;

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final exp = decoded['exp'];
      if (exp is! int) {
        return false;
      }

      final expiration = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expiration.subtract(threshold));
    } catch (_) {
      return false;
    }
  }

  Future<AuthSession?> _renewSessionIfNeeded(AuthSession oldSession) async {
    final persistence = authPersistence;
    if (persistence == null) {
      final refreshed = await _renewSession(oldSession);
      _applySessionUpdate(refreshed);

      return refreshed;
    }

    final persistedSession = await _findBestPersistedSession(
      persistence,
      oldSession,
    );
    final sessionToRefresh = persistedSession ?? oldSession;
    final refreshLockKey = persistence.refreshLockKey(sessionToRefresh);

    if (persistence.isRefreshing(refreshLockKey)) {
      await persistence.waitIfRefreshing(refreshLockKey);
      final refreshedFromStore = await _findBestPersistedSession(
        persistence,
        oldSession,
      );
      if (refreshedFromStore != null) {
        _applySessionUpdate(refreshedFromStore);
      }
      return refreshedFromStore;
    }

    persistence.markRefreshing(refreshLockKey);

    try {
      final refreshed = await _renewSession(sessionToRefresh);

      if (persistedSession != null) {
        await persistence.replaceSession(persistedSession, refreshed);
      } else {
        final currentSession = await persistence.currentSession;
        if (currentSession != null &&
            currentSession.host == sessionToRefresh.host &&
            (sessionToRefresh.deviceId.isEmpty ||
                currentSession.deviceId == sessionToRefresh.deviceId)) {
          await persistence.replaceSession(currentSession, refreshed);
        } else {
          persistence.currentSession = refreshed;
        }
      }

      persistence.currentSession = refreshed;
      _applySessionUpdate(refreshed);
      return refreshed;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await _onSessionExpired(sessionToRefresh, persistence);
      }
      rethrow;
    } finally {
      persistence.markRefreshDone(refreshLockKey);
    }
  }

  Future<AuthSession?> _findBestPersistedSession(
    AuthPersistence persistence,
    AuthSession lookupSession,
  ) async {
    AuthSession? persistedSession;

    if (lookupSession.deviceId.isNotEmpty) {
      persistedSession = await persistence.getSessionByHostAndDevice(
        lookupSession.host,
        lookupSession.deviceId,
      );
    }

    persistedSession ??= await persistence.getSessionByToken(lookupSession.token);

    final currentSession = await persistence.currentSession;
    if (persistedSession == null &&
        currentSession != null &&
        currentSession.host == lookupSession.host) {
      persistedSession = currentSession;
    }

    return persistedSession;
  }

  Future<void> _onSessionExpired(
    AuthSession expiredSession,
    AuthPersistence persistence,
  ) async {
    final currentSession = await persistence.currentSession;
    if (currentSession == expiredSession) {
      persistence.expiredCurrentSession = expiredSession;
    }
    await persistence.removeSession(expiredSession);
  }

  Future<AuthSession> _renewSession(AuthSession oldSession) async {
    final newSessionResponse = await _refreshClient.dio.patch(
      '/api/auth/refresh',
      data: {"device": oldSession.deviceId, "token": oldSession.refreshToken},
    );

    return AuthSession.fromResponseJson(oldSession.host, newSessionResponse.data);
  }

  void _applySessionUpdate(AuthSession newSession) {
    session.token = newSession.token;
    session.refreshToken = newSession.refreshToken;
    session.deviceId = newSession.deviceId;
    session.host = newSession.host;
  }

  void sendUserPosition(String channel, WebsocketSendPosition position) {
    log(
      'Sending user position: ${position.latitude}, ${position.longitude}, ${position.altitude}, ${position.time}, ${position.speed}',
      name: 'WebsocketClient.sendUserPosition',
    );
    _sendMessage(channel, position);
  }

  void sendReadNotification(String channel, int notificationId) {
    log(
      'Sending read notification',
      name: 'WebsocketClient.sendReadNotification',
    );
    _sendMessage(channel, WebsocketReadNotification(notificationId: notificationId));
  }

  void stopSendPositions(String channel) {
    log(
      'Stop sending user position',
      name: 'WebsocketClient.stopSendPositions',
    );
    _sendMessage(channel, const WebsocketStopSendPosition());
  }

  void _sendMessage(String channel, WebsocketBody data) {
    _send(jsonEncode({'channel': channel, 'data': data.toJson()}));
  }
}
