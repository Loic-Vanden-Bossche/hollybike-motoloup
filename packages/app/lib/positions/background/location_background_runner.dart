import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hollybike/notification/background/app_notifications.dart';

import '../service/my_position_repository.dart';

class LocationBackgroundRunner {
  static const _locChannelName = 'com.hollybike/location_service';
  static const _methodStart = 'start';
  static const _methodStop = 'stop';
  static const _methodPosition = 'position';

  final MethodChannel _locChannel = const MethodChannel(_locChannelName);
  final MyPositionServiceRepository _positionRepository =
      MyPositionServiceRepository();

  StreamSubscription<Position>? _positionSubscription;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    _locChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case _methodStart:
          final args = _parseStartArgs(call.arguments);
          await _startStream(
            token: args.token,
            host: args.host,
            eventId: args.eventId,
          );
          return;
        case _methodStop:
          await _stopStream();
          return;
        default:
          throw MissingPluginException('Unsupported method: ${call.method}');
      }
    });
  }

  Future<void> _startStream({
    required String token,
    required String host,
    required String eventId,
  }) async {
    await AppNotifications.init();

    final settings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      intervalDuration: Duration(seconds: 5),
    );

    await _positionSubscription?.cancel();
    await _positionRepository.init(token, host, eventId);

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      (position) async {
        await _positionRepository.callback(position);

        try {
          await _locChannel.invokeMethod(_methodPosition, {
            'lat': position.latitude,
            'lng': position.longitude,
            'ts': position.timestamp.toIso8601String(),
          });
        } catch (_) {
          // UI isolate may be gone; forwarding is best effort only.
        }
      },
      onError: (_) {
        // Service keeps running; repository handles retry internally.
      },
    );
  }

  Future<void> _stopStream() async {
    await _positionRepository.dispose();
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  _StartArgs _parseStartArgs(dynamic arguments) {
    final map = arguments;
    if (map is! Map) {
      throw ArgumentError('Expected Map arguments for start');
    }

    final token = map['token']?.toString();
    final host = map['host']?.toString();
    final eventId = map['eventId']?.toString();

    if (_isBlank(token) || _isBlank(host) || _isBlank(eventId)) {
      throw ArgumentError('Missing token/host/eventId');
    }

    return _StartArgs(token: token!, host: host!, eventId: eventId!);
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}

class _StartArgs {
  const _StartArgs({
    required this.token,
    required this.host,
    required this.eventId,
  });

  final String token;
  final String host;
  final String eventId;
}
