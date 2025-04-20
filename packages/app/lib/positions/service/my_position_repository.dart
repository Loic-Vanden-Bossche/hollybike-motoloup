/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_subscribed.dart';
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

  String _accessToken = '';
  String _host = '';
  int _eventId = -1;

  double accelerationX = 0;
  double accelerationY = 0;
  double accelerationZ = 0;

  final _locationBuffer = <Position>[];

  Future<void> init(Map<String, dynamic> params) async {
    await initParams(params).catchError((e) {
      log('Error while init callback: $e', stackTrace: StackTrace.current);
    });

    userAccelerometerEventStream().listen((event) {
      accelerationX = event.x;
      accelerationY = event.y;
      accelerationZ = event.z;
    });
  }

  Future<void> initParams(Map<dynamic, dynamic> params) async {
    if (!params.containsKey('accessToken') ||
        !params.containsKey('host') ||
        !params.containsKey('eventId')) {
      return Future.error('Missing parameters');
    }

    final accessToken = params['accessToken'] as String?;
    final host = params['host'] as String?;
    final eventId = params['eventId'] as int?;

    if (accessToken == null || host == null || eventId == null) {
      return Future.error('Missing parameters');
    }

    _accessToken = accessToken;
    _host = host;
    _eventId = eventId;

    _channel = 'event/${_eventId.toInt()}';

    await _listenAndSubscribe();
  }

  void retryConnection() {
    Future.delayed(const Duration(seconds: 10), () async {
      try {
        log('Retrying connection');
        await _listenAndSubscribe();
      } catch (e) {
        log('Error: $e', stackTrace: StackTrace.current);
        retryConnection(); // Retry again if an error occurs
      }
    });
  }

  Future<void> _listenAndSubscribe() async {
    final ws = await WebsocketClient(
      session: AuthSession(
        token: _accessToken,
        host: _host,
        deviceId: '',
        refreshToken: '',
      ),
    ).connect();

    ws.onDisconnect(() {
      log('Websocket Disconnected');
      _client = null;

      retryConnection();
    });

    ws.listen((message) async {
      switch (message.data.type) {
        case 'subscribed':
          final subscribed = message.data as WebsocketSubscribed;

          if (subscribed.subscribed) {
            _client = ws;
            return;
          }

          throw Exception('Error: Not subscribed');
      }
    });

    ws.subscribe(_channel);
  }

  Future<void> dispose() async {
    _client?.stopSendPositions(_channel);

    _client?.close();
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
