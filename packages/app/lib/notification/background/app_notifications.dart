import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotifications {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static const String realtimeChannelId = 'realtime_channel';
  static const String trackingChannelId = 'tracking_channel';
  static const String eventUpdated = 'hollybike-event-updated-notifications';
  static const String eventParticipation =
      'hollybike-event-participation-notifications';
  static const String eventDeletion = 'hollybike-event-deletion-notifications';
  static const String eventCreation = 'hollybike-event-creation-notifications';

  static final Random _random = Random();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    const init = InitializationSettings(
      android: AndroidInitializationSettings('ic_stat_hollybike'),
    );
    await plugin.initialize(settings: init);

    final android =
        plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        realtimeChannelId,
        'Live updates',
        description: 'WebSocket en temps reel',
        importance: Importance.low,
      ),
    );
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
        eventUpdated,
        'Mise a jour des evenements',
        description: 'Mises a jour de status',
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        eventParticipation,
        'Participation aux evenements',
        description: 'Ajout/Retrait',
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        eventDeletion,
        'Suppression des evenements',
        description: 'Suppressions',
        importance: Importance.high,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        eventCreation,
        'Creation des evenements',
        description: 'Nouveaux evenements',
        importance: Importance.high,
      ),
    );

    _initialized = true;
  }

  static Future<void> showOneShot({
    required String channelId,
    required String title,
    required String body,
  }) async {
    await plugin.show(
        id: _random.nextInt(1 << 20),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
          channelDescription: 'HollyBike',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        ),
      )
    );
  }
}
