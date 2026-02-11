import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../auth/types/auth_session.dart';
import 'app_notifications.dart';

/// Starts/stops the realtime foreground service running a headless WebSocket client.
class RealtimeNotificationsFacade {
  static const MethodChannel _fgsChannel = MethodChannel(
    'com.hollybike/fgs_control',
  );

  Future<void> initialize() async {
    await AppNotifications.init();
    final status = await Permission.notification.request();
    if (status.isGranted) {
      return;
    }

    if (status.isPermanentlyDenied) {
      throw Exception(
        'Notification permission permanently denied. Enable notifications in app settings.',
      );
    }

    throw Exception('Notification permission denied');
  }

  Future<void> connectNotifications(AuthSession session) async {
    await initialize();
    await _fgsChannel.invokeMethod('startRealtime', {
      'token': session.token,
      'host': session.host,
    });
  }

  Future<void> disconnect() async {
    await _fgsChannel.invokeMethod('stopRealtime');
  }
}
