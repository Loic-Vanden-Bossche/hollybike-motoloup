import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../notification/background/background_notification_handler.dart';
import '../positions/background/background_position_handler.dart';

@pragma('vm:entry-point')
class BackgroundHandler {
  static const backgroundNotificationId = 888;
  static const backgroundNotificationChannelId = 'foreground';

  static FlutterLocalNotificationsPlugin initializeNotification() {
    DartPluginRegistrant.ensureInitialized();

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_hollybike'),
      ),
    );

    flutterLocalNotificationsPlugin.show(
      backgroundNotificationId,
      'Service de notifications HollyBike',
      'Awesome ${DateTime.now()}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          backgroundNotificationChannelId,
          'Ce service permet de recevoir des notifications en temps réel.',
          ongoing: true,
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
    );

    return flutterLocalNotificationsPlugin;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    final flutterLocalNotificationsPlugin = initializeNotification();

    if (service is AndroidServiceInstance) {
      await service.setAsForegroundService();
    }

    BackgroundNotificationHandler.initialize(
      service,
      flutterLocalNotificationsPlugin,
    );
    BackgroundPositionHandler.initialize(
      service,
      flutterLocalNotificationsPlugin,
    );
  }
}
