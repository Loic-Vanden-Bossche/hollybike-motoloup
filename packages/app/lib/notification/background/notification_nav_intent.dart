import 'dart:async';

class NotificationNavIntent {
  static final StreamController<int?> _controller =
      StreamController<int?>.broadcast();

  static Stream<int?> get stream => _controller.stream;

  static void push(int? eventId) {
    _controller.add(eventId);
  }
}
