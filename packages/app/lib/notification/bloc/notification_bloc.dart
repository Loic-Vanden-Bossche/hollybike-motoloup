/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hollybike/auth/services/auth_repository.dart';

import '../../background/background_service.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository authRepository;
  final BackgroundService backgroundService;

  void Function(FlutterBackgroundService)? onInitialized;

  NotificationBloc({required this.authRepository, required this.backgroundService})
      : super(NotificationInitial()) {
    on<InitNotificationService>(_onInitNotificationService);
  }

  void _onInitNotificationService(
    InitNotificationService event,
    Emitter<NotificationState> emit,
  ) async {
    final currentSession = await authRepository.currentSession;

    if (currentSession == null) {
      return;
    }

    backgroundService.connectNotifications(currentSession);
  }
}
