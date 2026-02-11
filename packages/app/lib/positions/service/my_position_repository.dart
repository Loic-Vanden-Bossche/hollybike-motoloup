/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_subscribed.dart';
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
  String _host = '';
  int _eventId = -1;

  double accelerationX = 0;
  double accelerationY = 0;
  double accelerationZ = 0;

  final _locationBuffer = <Position>[];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;

  Future<void> init(String token, String host, String eventId) async {
    _shouldRun = true;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();
    final generation = _connectionGeneration;

    await initParams(token, host, int.tryParse(eventId), generation).catchError(
      (e) {
        log('Error while init callback: $e', stackTrace: StackTrace.current);
      },
    );

    await _accelerometerSubscription?.cancel();
    _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
      accelerationX = event.x;
      accelerationY = event.y;
      accelerationZ = event.z;
    });
  }

  Future<void> initParams(
    String? token,
    String? host,
    int? eventId,
    int generation,
  ) async {
    if (token == null || host == null || eventId == null) {
      return Future.error('Missing parameters');
    }

    _accessToken = token;
    _host = host;
    _eventId = eventId;

    _channel = 'event/${_eventId.toInt()}';

    await _attemptConnect(generation);
  }

  Future<void> _attemptConnect(int generation) async {
    if (!_shouldRun || generation != _connectionGeneration) {
      return;
    }

    try {
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
            deviceId: '',
            refreshToken: '',
          ),
        ).connect();

    ws.onDisconnect(() {
      if (!_shouldRun || generation != _connectionGeneration) {
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
            _client = ws;
            _reconnectBackoff.reset();
            return;
          }

          throw Exception('Error: Not subscribed');
      }
    });

    ws.subscribe(_channel);
  }

  Future<void> dispose() async {
    _shouldRun = false;
    _connectionGeneration += 1;
    _reconnectBackoff.reset();

    await _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;

    _client?.stopSendPositions(_channel);

    _client?.close();
    _client = null;
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
}

double keepFiveDigits(double value) {
  return double.parse(value.toStringAsFixed(5));
}
