import 'dart:async';

import 'package:flutter/services.dart';

/// Bridges Android notification taps to Flutter navigation.
///
/// Two notification interactions are handled:
///   • Body tap → navigate to the event details page.
///   • "Terminer le parcours" action button → navigate to event details AND
///     auto-trigger the terminate-journey confirmation dialog.
///
/// Both interactions work for warm starts (app already running) and cold
/// starts (app launched from scratch by the notification tap):
///
///   Warm start: MainActivity calls invokeMethod on this channel, which
///   triggers the handler registered in [initialize].
///
///   Cold start: MainActivity stores the pending intent data.  [checkPendingNavIntent]
///   pulls it after the first frame so the router is ready to navigate.
class TrackingNavIntent {
  static const _channel = MethodChannel('com.hollybike/nav_intent');
  static final _controller = StreamController<int>.broadcast();

  // Stash for the terminate action: set before navigation so that
  // EventDetailsScreen can read it in initState via consumePendingTerminate().
  static int? _pendingTerminateEventId;

  /// Must be called once from main() after WidgetsFlutterBinding.ensureInitialized().
  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      final eventId = call.arguments as int?;
      if (eventId == null) return null;

      if (call.method == 'terminateTrackingJourney') {
        _pendingTerminateEventId = eventId;
      }

      // Both actions navigate to the event — emit the eventId to trigger
      // App's navigation listener regardless of action type.
      if (call.method == 'openTrackingEvent' || call.method == 'terminateTrackingJourney') {
        _controller.add(eventId);
      }

      return null;
    });
  }

  /// Pulls any pending intent stored by MainActivity during a cold-start tap.
  /// Call this after the first frame (from addPostFrameCallback) so the router
  /// has finished its initial navigation before we push a new route.
  static Future<void> checkPendingNavIntent() async {
    try {
      final result = await _channel.invokeMethod<Map>('getPendingNavIntent');
      if (result == null) return;

      final eventId = result['eventId'] as int?;
      final method = result['method'] as String?;
      if (eventId == null) return;

      if (method == 'terminateTrackingJourney') {
        _pendingTerminateEventId = eventId;
      }

      _controller.add(eventId);
    } catch (_) {
      // Platform channel not available (e.g. in tests or on iOS).
    }
  }

  /// Returns and clears the pending terminate event ID.
  /// Called from EventDetailsScreen.initState to check whether this screen
  /// should auto-trigger the terminate-journey confirmation dialog.
  static int? consumePendingTerminate() {
    final id = _pendingTerminateEventId;
    _pendingTerminateEventId = null;
    return id;
  }

  /// Emits the event ID for every notification tap (open or terminate).
  /// App subscribes to this stream and navigates to EventDetailsRoute.
  static Stream<int> get stream => _controller.stream;
}
