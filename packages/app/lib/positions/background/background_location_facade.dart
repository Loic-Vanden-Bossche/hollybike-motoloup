import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/types/auth_session.dart';
import 'background_location_shim.dart';

class BackgroundLocationFacade {
  static const _fgsControl = MethodChannel('com.hollybike/fgs_control');
  static const _uiBridge = MethodChannel('com.hollybike/location_bridge');
  static const _prefsKeyRunning = 'bg_location_running';
  static const _prefsKeyEventId = 'tracking_event_id';
  static const _methodPosition = 'position';

  final StreamController<void> _positionEvents =
      StreamController<void>.broadcast();

  BackgroundLocationFacade() {
    _uiBridge.setMethodCallHandler((call) async {
      if (call.method == _methodPosition && !_positionEvents.isClosed) {
        _positionEvents.add(null);
      }
      return null;
    });
  }

  BackgroundServiceShim get backgroundService => BackgroundServiceShim(this);

  Stream<void> getPositionStream() => _positionEvents.stream;

  Future<void> start(int eventId, AuthSession session) async {
    await _ensureNotificationPermission();
    await _ensureLocationPermissionForTracking();
    await _ensureLocationServicesEnabled();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKeyEventId, eventId);

    await _fgsControl.invokeMethod('startLocation', {
      'token': session.token,
      'host': session.host,
      'eventId': eventId,
    });

    await prefs.setBool(_prefsKeyRunning, true);
  }

  Future<void> stop() async {
    final prefs = await SharedPreferences.getInstance();
    await _fgsControl.invokeMethod('stopLocation');
    await prefs.setBool(_prefsKeyRunning, false);
  }

  Future<bool> isTrackingRunning() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKeyRunning) ?? false;
  }

  Future<void> _ensureLocationServicesEnabled() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services disabled');
    }
  }

  Future<void> _ensureLocationPermissionForTracking() async {
    await _ensureForegroundLocationPermission();
    await _ensureBackgroundLocationPermission();
  }

  Future<void> _ensureForegroundLocationPermission() async {
    final hasForeground =
        await Permission.locationWhenInUse.isGranted ||
        await Permission.location.isGranted;
    if (hasForeground) {
      return;
    }

    var status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      throw Exception(
        'Location permission permanently denied. Enable it in app settings.',
      );
    }

    if (!status.isGranted) {
      throw Exception('Foreground location permission denied');
    }
  }

  Future<void> _ensureBackgroundLocationPermission() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (await Permission.locationAlways.isGranted) {
      return;
    }

    final status = await Permission.locationAlways.request();
    if (status.isGranted) {
      return;
    }

    if (status.isPermanentlyDenied) {
      throw Exception(
        'Background location permission permanently denied. Enable "Allow all the time" in app settings.',
      );
    }

    throw Exception('Background location permission denied');
  }

  Future<void> _ensureNotificationPermission() async {
    if (!Platform.isAndroid) {
      return;
    }

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

  Future<void> dispose() async {
    await _positionEvents.close();
    _uiBridge.setMethodCallHandler(null);
  }
}
