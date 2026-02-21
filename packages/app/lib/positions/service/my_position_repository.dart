/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_subscribed.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_error.dart';
import 'package:hollybike/shared/utils/exponential_backoff.dart';
import 'package:hollybike/shared/websocket/websocket_client.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/websocket/send/websocket_send_position.dart';

class MyPositionServiceRepository {
  static final MyPositionServiceRepository _instance =
      MyPositionServiceRepository._();

  MyPositionServiceRepository._();

  factory MyPositionServiceRepository() {
    return _instance;
  }

  final AuthPersistence _authPersistence = AuthPersistence();
  WebsocketClient? _client;
  String _channel = '';
  bool _shouldRun = false;
  int _connectionGeneration = 0;
  final ExponentialBackoff _reconnectBackoff = ExponentialBackoff(
    baseDelay: const Duration(seconds: 2),
    maxDelay: const Duration(seconds: 60),
    maxJitterMilliseconds: 750,
  );

  String _accessToken = '';
  String _refreshToken = '';
  String _deviceId = '';
  String _host = '';
  int _eventId = -1;

  double accelerationX = 0;
  double accelerationY = 0;
  double accelerationZ = 0;

  final _locationBuffer = <Position>[];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<AuthSession>? _sessionExpiredSubscription;

  Future<void> init(
    String token,
    String host,
    String eventId, {
    String refreshToken = '',
    String deviceId = '',
  }) async {
    final parsedEventId = int.tryParse(eventId);
    if (parsedEventId == null) {
      log('Invalid eventId: $eventId', stackTrace: StackTrace.current);
      return;
    }

    _shouldRun = true;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();
    final generation = _connectionGeneration;

    _accessToken = token;
    _refreshToken = refreshToken;
    _deviceId = deviceId;
    _host = host;
    _eventId = parsedEventId;
    _channel = 'event/$_eventId';

    try {
      await _attemptConnect(generation);
    } catch (e) {
      log('Error while init callback: $e', stackTrace: StackTrace.current);
    }

    await _accelerometerSubscription?.cancel();
    _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
      accelerationX = event.x;
      accelerationY = event.y;
      accelerationZ = event.z;
    });

    await _sessionExpiredSubscription?.cancel();
    _sessionExpiredSubscription = _authPersistence.currentSessionExpiredStream
        .listen((expiredSession) {
          if (!_shouldRun) return;

          final sameHost = expiredSession.host == _host;
          final sameDevice =
              _deviceId.isEmpty || expiredSession.deviceId == _deviceId;

          if (!sameHost || !sameDevice) return;

          log(
            'Session expired for background location stream; stopping reconnect loop',
          );
          _stopRealtime();
        });
  }

  Future<void> _attemptConnect(int generation) async {
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    try {
      await _syncCredentialsFromPersistence();
      await _listenAndSubscribe(generation);
    } catch (e) {
      log(
        'Error while connecting websocket: $e',
        stackTrace: StackTrace.current,
      );
      if (_shouldRun && generation == _connectionGeneration) {
        unawaited(_scheduleReconnect(generation));
      }
    }
  }

  Future<void> _scheduleReconnect(int generation) async {
    final delay = _reconnectBackoff.nextDelay();
    await Future.delayed(delay);
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    log('Retrying websocket connection in ${delay.inSeconds}s');
    await _attemptConnect(generation);
  }

  Future<void> _listenAndSubscribe(int generation) async {
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    final ws =
        await WebsocketClient(
          session: AuthSession(
            token: _accessToken,
            host: _host,
            deviceId: _deviceId,
            refreshToken: _refreshToken,
          ),
          authPersistence: _authPersistence,
        ).connect();

    final subscriptionReady = Completer<void>();
    var subscribedSuccessfully = false;

    ws.onDisconnect(() {
      if (!_shouldRun || generation != _connectionGeneration) {
        return;
      }

      // Connection failures before subscription are handled by _attemptConnect catch.
      // Only schedule reconnect here after a successful subscription.
      if (!subscribedSuccessfully) {
        _client = null;
        log('Websocket Disconnected');
        return;
      }

      log('Websocket Disconnected');
      _client = null;
      unawaited(_scheduleReconnect(generation));
    });

    ws.listen((message) async {
      switch (message.data.type) {
        case 'subscribed':
          final subscribed = message.data as WebsocketSubscribed;

          if (subscribed.subscribed) {
            subscribedSuccessfully = true;
            _client = ws;
            _reconnectBackoff.reset();
            _syncCredentialsFromSession(ws.session);
            if (!subscriptionReady.isCompleted) {
              subscriptionReady.complete();
            }
            return;
          }

          if (!subscriptionReady.isCompleted) {
            subscriptionReady.completeError(Exception('Error: Not subscribed'));
          }
          ws.close();
          return;
        case 'error':
          final errorMessage = (message.data as WebsocketError).message;
          if (!subscriptionReady.isCompleted) {
            subscriptionReady.completeError(Exception(errorMessage));
          }

          if (_isAuthWebsocketError(errorMessage)) {
            log('Websocket auth error received: $errorMessage');
            await ws.renewSessionIfPossible();
            await _syncCredentialsFromPersistence();
            _syncCredentialsFromSession(ws.session);
          }

          ws.close();
          return;
      }
    });

    await ws.subscribe(_channel);

    await subscriptionReady.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        ws.close();
        throw TimeoutException('Subscription timeout for channel $_channel');
      },
    );
  }

  Future<void> dispose() async {
    _client?.stopSendPositions(_channel);
    _stopRealtime();

    await _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;

    await _sessionExpiredSubscription?.cancel();
    _sessionExpiredSubscription = null;
  }

  Future<void> callback(Position locationDto) async {
    if (_client == null) {
      _locationBuffer.add(locationDto);
      return;
    }

    if (_locationBuffer.isNotEmpty) {
      final buffer = List<Position>.from(_locationBuffer);
      _locationBuffer.clear();

      for (final location in buffer) {
        _sendLocation(location);
      }
    }

    _sendLocation(locationDto);
  }

  void _sendLocation(Position location) {
    _client?.sendUserPosition(
      _channel,
      WebsocketSendPosition(
        latitude: keepFiveDigits(location.latitude),
        longitude: keepFiveDigits(location.longitude),
        altitude: keepFiveDigits(location.altitude),
        time: location.timestamp,
        speed: keepFiveDigits(location.speed),
        heading: location.heading,
        accelerationX: keepFiveDigits(accelerationX),
        accelerationY: keepFiveDigits(accelerationY),
        accelerationZ: keepFiveDigits(accelerationZ),
        speedAccuracy: keepFiveDigits(location.speedAccuracy),
        accuracy: keepFiveDigits(location.accuracy),
      ),
    );
  }

  Future<void> _syncCredentialsFromPersistence() async {
    if (_host.isEmpty || _deviceId.isEmpty) {
      return;
    }

    final persistedSession = await _authPersistence.getSessionByHostAndDevice(
      _host,
      _deviceId,
    );

    if (persistedSession == null) {
      return;
    }

    _syncCredentialsFromSession(persistedSession);
  }

  void _syncCredentialsFromSession(AuthSession session) {
    _accessToken = session.token;
    _refreshToken = session.refreshToken;
    _deviceId = session.deviceId;
    _host = session.host;
  }

  bool _isAuthWebsocketError(String message) {
    return message == "Unauthorized websocket subscription";
  }

  void _stopRealtime() {
    _shouldRun = false;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();
    _locationBuffer.clear();
    _client?.close();
    _client = null;
  }
}

double keepFiveDigits(double value) {
  return double.parse(value.toStringAsFixed(5));
}
