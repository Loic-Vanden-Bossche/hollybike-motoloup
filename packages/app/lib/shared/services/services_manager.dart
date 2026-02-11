// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../notification/background/test2_notif.dart';
//
// class ServicesManager {
//   static const _fgsChannel = MethodChannel('com.hollybike/fgs_control');
//   static const _locChannel = MethodChannel('com.hollybike/location_service');
//
//   Future<void> initialize() async {
//     await AppNotifications.init();
//     await Permission.notification.request(); // Android 13+ for showing notifs
//   }
//
//   // ---- Realtime WebSocket (dataSync FGS) ----
//   Future<void> startRealtime({required String token, required String host}) async {
//     await _fgsChannel.invokeMethod('startRealtime', {'token': token, 'host': host});
//   }
//   Future<void> stopRealtime() async {
//     await _fgsChannel.invokeMethod('stopRealtime');
//   }
//
//   // ---- Background Location (location FGS) ----
//   Future<bool> requestBackgroundLocationIfNeeded() async {
//     // Step 1: while-in-use
//     var whenInUse = await Permission.locationWhenInUse.request();
//     if (!whenInUse.isGranted) return false;
//
//     // Step 2: background (separate prompt; often opens Settings on Android 11+)
//     var always = await Permission.locationAlways.request();
//     return always.isGranted;
//   }
//
//   Future<bool> startBackgroundLocation() async {
//     // Ensure permissions (will prompt if missing)
//     if (!(await Permission.locationAlways.isGranted)) {
//       final ok = await requestBackgroundLocationIfNeeded();
//       if (!ok) return false;
//     }
//     if (!await Geolocator.isLocationServiceEnabled()) return false;
//
//     // Start the native FGS first (must show ongoing notif immediately)
//     await _fgsChannel.invokeMethod('startLocation');
//
//     // Tell the headless Dart isolate to start the Geolocator stream
//     await _locChannel.invokeMethod('start');
//     return true;
//   }
//
//   Future<void> stopBackgroundLocation() async {
//     await _locChannel.invokeMethod('stop');
//     await _fgsChannel.invokeMethod('stopLocation');
//   }
// }