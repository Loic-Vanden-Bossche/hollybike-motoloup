import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotifications {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const String trackingChannelId = 'tracking_channel';
  static const String eventUpdates = 'hollybike-event-updates-notifications';

  static final Random _random = Random();
  static bool _initialized = false;

  static Future<void> init({
    Future<void> Function(String? payload)? onTapPayload,
  }) async {
    if (_initialized) {
      return;
    }

    const init = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_hollybike'),
    );
    await plugin.initialize(
      settings: init,
      onDidReceiveNotificationResponse: (response) {
        onTapPayload?.call(response.payload);
      },
    );

    final android =
        plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        trackingChannelId,
        'Location tracking',
        description: 'Localisation en arriere-plan',
        importance: Importance.low,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        eventUpdates,
        'Mises a jour evenements',
        description: 'Notifications des evenements',
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  static Future<void> showOneShot({
    required String channelId,
    required String title,
    required String body,
    String? payload,
  }) async {
    await plugin.show(
      id: _random.nextInt(1 << 20),
      title: title,
      body: body,
      payload: payload,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
          channelDescription: 'HollyBike',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
    );
  }
}
