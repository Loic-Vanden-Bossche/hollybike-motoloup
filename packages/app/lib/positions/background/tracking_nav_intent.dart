import 'dart:async';

import 'package:flutter/services.dart';

/// Bridges Android notification taps to Flutter navigation.
///
/// When the user taps the tracking foreground-service notification, Android
/// delivers the event ID to [MainActivity] which forwards it here via the
/// [_channel] MethodChannel.  [App] subscribes to [stream] and navigates to
/// the corresponding event details page.
///
/// Two cases are handled:
///   • Cold start — the app was not running.  MainActivity stores the event ID
///     in pendingNavEventId.  [checkPendingNavIntent] pulls it after the first
///     frame so the router is ready to navigate.
///   • Warm start — the app is already running.  MainActivity calls
///     invokeMethod("openTrackingEvent", eventId) which triggers the handler
///     registered in [initialize].
class TrackingNavIntent {
  static const _channel = MethodChannel('com.hollybike/nav_intent');
  static final _controller = StreamController<int>.broadcast();

  /// Must be called once from main() after WidgetsFlutterBinding.ensureInitialized().
  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openTrackingEvent') {
        final eventId = call.arguments as int?;
        if (eventId != null) _controller.add(eventId);
      }
      return null;
    });
  }

  /// Pulls any event ID that was stored by MainActivity during a cold-start tap.
  /// Call this after the first frame (e.g. from addPostFrameCallback) so the
  /// router has finished its initial navigation before we push a new route.
  static Future<void> checkPendingNavIntent() async {
    try {
      final eventId = await _channel.invokeMethod<int>('getPendingNavEventId');
      if (eventId != null) _controller.add(eventId);
    } catch (_) {
      // Platform channel not available (e.g. in tests or on iOS).
    }
  }

  static Stream<int> get stream => _controller.stream;
}
