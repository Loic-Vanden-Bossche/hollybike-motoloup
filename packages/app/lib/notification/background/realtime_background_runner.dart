import 'dart:async';

import 'package:flutter/services.dart';

import '../../auth/types/auth_session.dart';
import '../../event/types/event_status_state.dart';
import '../../shared/utils/dates.dart';
import '../../shared/utils/exponential_backoff.dart';
import '../../shared/websocket/recieve/websocket_added_to_event.dart';
import '../../shared/websocket/recieve/websocket_event_deleted.dart';
import '../../shared/websocket/recieve/websocket_event_published.dart';
import '../../shared/websocket/recieve/websocket_event_status_updated.dart';
import '../../shared/websocket/recieve/websocket_event_updated.dart';
import '../../shared/websocket/recieve/websocket_removed_from_event.dart';
import '../../shared/websocket/websocket_client.dart';
import '../../shared/websocket/websocket_message.dart';
import 'app_notifications.dart';

class RealtimeBackgroundRunner {
  static const String _serviceChannelName = 'com.hollybike/realtime_service';
  static const String _notificationChannelName = 'notification';
  static const String _methodStart = 'start';
  static const String _methodStop = 'stop';

  final MethodChannel _serviceChannel = const MethodChannel(
    _serviceChannelName,
  );

  WebsocketClient? _ws;
  bool _shouldRun = false;
  int _connectionGeneration = 0;
  final ExponentialBackoff _reconnectBackoff = ExponentialBackoff(
    baseDelay: const Duration(seconds: 2),
    maxDelay: const Duration(seconds: 60),
    maxJitterMilliseconds: 750,
  );

  Future<void> initialize() async {
    _serviceChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case _methodStart:
          final args = _parseStartArgs(call.arguments);
          await _start(args.token, args.host);
          return;
        case _methodStop:
          await _stop();
          return;
        default:
          throw MissingPluginException('Unsupported method: ${call.method}');
      }
    });
  }

  Future<void> _start(String token, String host) async {
    _shouldRun = true;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();
    final generation = _connectionGeneration;

    await AppNotifications.init();
    await _attemptConnect(token: token, host: host, generation: generation);
  }

  Future<void> _attemptConnect({
    required String token,
    required String host,
    required int generation,
  }) async {
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    try {
      await _connect(token: token, host: host, generation: generation);
    } catch (_) {
      if (_shouldRun && generation == _connectionGeneration) {
        unawaited(
          _scheduleReconnect(token: token, host: host, generation: generation),
        );
      }
    }
  }

  Future<void> _connect({
    required String token,
    required String host,
    required int generation,
  }) async {
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    _ws?.close();
    final client = WebsocketClient(
      session: AuthSession(
        token: token,
        host: host,
        refreshToken: '',
        deviceId: '',
      ),
    );

    _ws = client;
    await client.connect();
    _reconnectBackoff.reset();
    client.pingInterval(10);
    client.subscribe(_notificationChannelName);

    client.listen(_onMessage);
    client.onDisconnect(() {
      if (!_shouldRun || generation != _connectionGeneration) {
        return;
      }

      unawaited(
        _scheduleReconnect(token: token, host: host, generation: generation),
      );
    });
  }

  Future<void> _scheduleReconnect({
    required String token,
    required String host,
    required int generation,
  }) async {
    final delay = _reconnectBackoff.nextDelay();
    await Future.delayed(delay);
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    await _attemptConnect(token: token, host: host, generation: generation);
  }

  Future<void> _onMessage(WebsocketMessage message) async {
    final payload = _buildNotificationPayload(message);
    if (payload == null) {
      return;
    }

    await AppNotifications.showOneShot(
      channelId: payload.channelId,
      title: payload.title,
      body: payload.body,
    );

    _ws?.sendReadNotification(_notificationChannelName, payload.notificationId);
  }

  _NotificationPayload? _buildNotificationPayload(WebsocketMessage message) {
    switch (message.data.type) {
      case 'EventStatusUpdateNotification':
        final data = message.data as WebsocketEventStatusUpdated;
        return _NotificationPayload(
          channelId: AppNotifications.eventUpdated,
          title: data.name,
          body:
              data.status == EventStatusState.canceled
                  ? 'L evenement ${data.name} a ete annule'
                  : 'Le statut de l evenement ${data.name} a ete mis a jour',
          notificationId: data.notificationId,
        );
      case 'AddedToEventNotification':
        final data = message.data as WebsocketAddedToEvent;
        return _NotificationPayload(
          channelId: AppNotifications.eventParticipation,
          title: data.name,
          body: 'Vous avez ete ajoute a l evenement ${data.name}',
          notificationId: data.notificationId,
        );
      case 'RemovedFromEventNotification':
        final data = message.data as WebsocketRemovedFromEvent;
        return _NotificationPayload(
          channelId: AppNotifications.eventParticipation,
          title: data.name,
          body: 'Vous avez ete retire de l evenement ${data.name}',
          notificationId: data.notificationId,
        );
      case 'DeleteEventNotification':
        final data = message.data as WebsocketEventDeleted;
        return _NotificationPayload(
          channelId: AppNotifications.eventDeletion,
          title: data.name,
          body: 'L evenement ${data.name} a ete supprime',
          notificationId: data.notificationId,
        );
      case 'UpdateEventNotification':
        final data = message.data as WebsocketEventUpdated;
        return _NotificationPayload(
          channelId: AppNotifications.eventUpdated,
          title: data.name,
          body: 'L evenement ${data.name} a ete mis a jour',
          notificationId: data.notificationId,
        );
      case 'NewEventNotification':
        final data = message.data as WebsocketEventPublished;
        return _NotificationPayload(
          channelId: AppNotifications.eventCreation,
          title: data.name,
          body:
              'Nouvel evenement ${data.name}, prevu ${formatTimeDate(data.start.toLocal())}',
          notificationId: data.notificationId,
        );
      default:
        return null;
    }
  }

  Future<void> _stop() async {
    _shouldRun = false;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();
    _ws?.close();
    _ws = null;
  }

  _StartArgs _parseStartArgs(dynamic arguments) {
    if (arguments is! Map) {
      throw ArgumentError('Invalid start arguments');
    }

    final token = arguments['token']?.toString();
    final host = arguments['host']?.toString();

    if (_isBlank(token) || _isBlank(host)) {
      throw ArgumentError('Missing token/host');
    }

    return _StartArgs(token: token!, host: host!);
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}

class _StartArgs {
  const _StartArgs({required this.token, required this.host});

  final String token;
  final String host;
}

class _NotificationPayload {
  const _NotificationPayload({
    required this.channelId,
    required this.title,
    required this.body,
    required this.notificationId,
  });

  final String channelId;
  final String title;
  final String body;
  final int notificationId;
}
