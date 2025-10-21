import 'dart:async';
import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hollybike/background/background_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import '../auth/types/auth_session.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();

  factory BackgroundService() => _instance;

  BackgroundService._internal();

  bool _isInitialized = false;

  FlutterBackgroundService? service;

  Future<FlutterBackgroundService> init() async {
    if (_isInitialized) return this.service!;

    final service = FlutterBackgroundService();

    log('Initializing notification service', name: 'Notifications');

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      BackgroundHandler.backgroundNotificationChannelId, // id
      'Service de notifications HollyBike', // title
      description:
          'Ce service permet de recevoir des notifications en temps réel.', // description
      importance: Importance.low, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: BackgroundHandler.onStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        initialNotificationTitle: 'Service de notifications HollyBike',
        initialNotificationContent:
            'Ce service permet de recevoir des notifications en temps réel.',
        notificationChannelId:
            BackgroundHandler.backgroundNotificationChannelId,
        foregroundServiceNotificationId:
            BackgroundHandler.backgroundNotificationId,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: BackgroundHandler.onStart,
        onBackground: (service) => false,
      ),
    );

    await service.startService();

    service.on('stopService').listen((event) {
      this.service = null;
    });

    _isInitialized = true;
    this.service = service;
    return service;
  }

  void connectNotifications(AuthSession currentSession) async {
    var service = await init();

    await Permission.notification.request();

    service.invoke("connect", {
      "token": currentSession.token,
      "host": currentSession.host,
    });
  }

  Future<void> startTracking(AuthSession session, int eventId) async {
    var service = await init();

    await Permission.location.request();

    service.invoke("start_tracking", {
      'accessToken': session.token,
      'host': session.host,
      'eventId': eventId,
    });
  }

  Future<void> stopTracking() async {
    service?.invoke("stop_tracking");
  }

  Future<bool> isTrackingRunning() async {
    final service = FlutterBackgroundService();

    final completer = Completer<bool>();

    // Listen once for the response
    late StreamSubscription sub;
    sub = service.on('tracking_status').listen((event) {
      if (event != null && event.containsKey('isRunning')) {
        completer.complete(event['isRunning'] == true);
        sub.cancel(); // Only listen once
      }
    });

    // Send request
    service.invoke('is_tracking_running');

    return completer.future;
  }

  Stream<void>? getPositionStream() {
    return service?.on("position_update");
  }
}
