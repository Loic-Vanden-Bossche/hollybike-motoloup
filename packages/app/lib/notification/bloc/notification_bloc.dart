/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/auth_session.dart';

import '../background/notif_facade.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final RealtimeNotificationsFacade notifications;
  String? _activeSessionKey;

  NotificationBloc({required this.notifications})
    : super(NotificationInitial()) {
    on<StartNotificationService>(_onStartNotificationService);
    on<StopNotificationService>(_onStopNotificationService);
  }

  Future<void> _onStartNotificationService(
    StartNotificationService event,
    Emitter<NotificationState> emit,
  ) async {
    final sessionKey = _sessionKey(event.session);
    if (_activeSessionKey == sessionKey) {
      return;
    }

    try {
      if (_activeSessionKey != null) {
        await notifications.disconnect();
      }
      await notifications.connectNotifications(event.session);
      _activeSessionKey = sessionKey;
      emit(NotificationServiceRunning());
    } catch (e) {
      _activeSessionKey = null;
      emit(NotificationServiceFailure(e.toString()));
    }
  }

  Future<void> _onStopNotificationService(
    StopNotificationService event,
    Emitter<NotificationState> emit,
  ) async {
    if (_activeSessionKey == null) {
      emit(NotificationServiceStopped());
      return;
    }

    try {
      await notifications.disconnect();
    } catch (_) {
      // Best effort stop.
    } finally {
      _activeSessionKey = null;
      emit(NotificationServiceStopped());
    }
  }

  @override
  Future<void> close() async {
    try {
      await notifications.disconnect();
    } catch (_) {}
    return super.close();
  }

  String _sessionKey(AuthSession session) => '${session.host}|${session.token}';
}
