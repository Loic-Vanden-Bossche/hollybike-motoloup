/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'notification_bloc.dart';

typedef Notification = ({String message, bool? isError, String? consumerId});

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationServiceRunning extends NotificationState {}

class NotificationServiceStopped extends NotificationState {}

class NotificationServiceFailure extends NotificationState {
  NotificationServiceFailure(this.message);

  final String message;
}
