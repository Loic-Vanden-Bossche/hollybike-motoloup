/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum MyPositionStatus { loading, success, error, initial }

@immutable
class MyPositionState {
  final Position? lastLocation;
  final bool isRunning;
  final MyPositionStatus status;
  final int? eventId;

  const MyPositionState({
    this.lastLocation,
    this.isRunning = false,
    this.status = MyPositionStatus.initial,
    this.eventId,
  });

  MyPositionState.state(MyPositionState state)
      : this(
          lastLocation: state.lastLocation,
          isRunning: state.isRunning,
          status: state.status,
          eventId: state.eventId,
        );

  MyPositionState copyWith({
    MyPositionStatus? status,
    Position? lastLocation,
    bool? isRunning,
    int? eventId,
  }) {
    return MyPositionState(
      status: status ?? this.status,
      lastLocation: lastLocation ?? this.lastLocation,
      isRunning: isRunning ?? this.isRunning,
      eventId: eventId ?? this.eventId,
    );
  }
}

class MyPositionInitial extends MyPositionState {}

class MyPositionLoading extends MyPositionState {
  MyPositionLoading(state)
      : super.state(
          state.copyWith(status: MyPositionStatus.loading),
        );
}

class MyPositionStarted extends MyPositionState {
  MyPositionStarted(super.state) : super.state();
}

class MyPositionInitialized extends MyPositionState {
  MyPositionInitialized(super.state) : super.state();
}

class MyPositionStopped extends MyPositionState {
  MyPositionStopped(state)
      : super.state(
          MyPositionState(
            lastLocation: state.lastLocation,
            isRunning: state.isRunning,
            status: state.status,
            eventId: null,
          ),
        );
}

class MyPositionFailure extends MyPositionState {
  final String errorMessage;

  MyPositionFailure(super.state, this.errorMessage) : super.state();
}

class MyPositionUpdated extends MyPositionState {
  MyPositionUpdated(
      state,
      Position? lastLocation
      )
      : super.state(
          MyPositionState(
            lastLocation: lastLocation,
            isRunning: state.isRunning,
            status: state.status,
            eventId: state.eventId,
          ),
        );
}
