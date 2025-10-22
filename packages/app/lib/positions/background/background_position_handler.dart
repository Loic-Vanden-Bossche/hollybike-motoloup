import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../../background/background_handler.dart';
import '../service/my_position_repository.dart';

@pragma('vm:entry-point')
class BackgroundPositionHandler {
  static void initialize(
    ServiceInstance service,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    StreamSubscription<Position>? positionSub;

    service.on('start_tracking').listen((event) async {
      if (event == null) {
        return;
      }

      flutterLocalNotificationsPlugin.show(
        BackgroundHandler.backgroundNotificationId,
        'Service de notifications HollyBike',
        'HollyBike Locator',
        NotificationDetails(
          android: AndroidNotificationDetails(
            BackgroundHandler.backgroundNotificationChannelId,
            '${DateTime.now()}',
            ongoing: true,
            importance: Importance.low,
            priority: Priority.low,
          ),
        ),
      );

      MyPositionServiceRepository myLocationCallbackRepository =
          MyPositionServiceRepository();

      myLocationCallbackRepository.init(event);

      positionSub ??= Geolocator.getPositionStream(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
          intervalDuration: Duration(seconds: 2),
          forceLocationManager: false,
        ),
      ).listen((Position position) async {
        service.invoke("position_update");
        myLocationCallbackRepository.callback(position);
      });
    });

    service.on('stop_tracking').listen((event) async {
      MyPositionServiceRepository myLocationCallbackRepository =
          MyPositionServiceRepository();

      myLocationCallbackRepository.dispose();
      await positionSub?.cancel();
      positionSub = null;
    });

    service.on('is_tracking_running').listen((event) {
      service.invoke('tracking_status', {'isRunning': positionSub != null});
    });
  }
}
