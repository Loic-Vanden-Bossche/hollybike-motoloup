/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// import 'package:background_locator_2/background_locator.dart';
// import 'package:background_locator_2/settings/android_settings.dart';
// import 'package:background_locator_2/settings/ios_settings.dart';
// import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';

import '../../background/background_service.dart';

class MyPositionLocator {
  final AuthPersistence authPersistence;
  final BackgroundService backgroundService;

  MyPositionLocator({
    required this.authPersistence,
    required this.backgroundService,
  });

  Future<void> start(int eventId, String eventName) async {
    final session = await authPersistence.currentSession;

    if (session == null) {
      throw Exception('No session found, cannot start location tracking');
    }

    await backgroundService.startTracking(session, eventId);
  }

  Future<void> stop() async {
    await backgroundService.stopTracking();
  }
}
