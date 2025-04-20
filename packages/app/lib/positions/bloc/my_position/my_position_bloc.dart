/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_state.dart';
import 'package:hollybike/positions/service/my_position_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_position_event.dart';

class MyPositionBloc extends Bloc<MyPositionEvent, MyPositionState> {
  final EventRepository eventRepository;
  final MyPositionLocator myPositionLocator;

  int posCount = 0;

  MyPositionBloc({
    required this.eventRepository,
    required this.myPositionLocator,
  }) : super(MyPositionInitial()) {
    on<SubscribeToMyPositionUpdates>(_onSubscribeToPositionUpdates);
    on<EnableSendPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);
  }

  void _onSubscribeToPositionUpdates(
    SubscribeToMyPositionUpdates event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getInt('tracking_event_id');

    emit(MyPositionInitialized(state.copyWith(
      isRunning: false,
      eventId: null,
    )));

    final isRunning = await myPositionLocator.backgroundService.isTrackingRunning();

    emit(MyPositionInitialized(state.copyWith(
      isRunning: isRunning,
      eventId: isRunning ? eventId : null,
    )));

    posCount = 0;

    myPositionLocator.backgroundService.getPositionStream()?.listen(
      (_) {
        posCount++;

        if (posCount >= 2 && eventId != null) {
          eventRepository.onUserPositionSent(eventId);
        }
      },
    );
  }

  void _onListenAndSendUserPosition(
    EnableSendPosition event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('tracking_event_id', event.eventId);

    if (state.isRunning) {
      await myPositionLocator.stop();
    }

    try {
      await myPositionLocator.start(event.eventId, event.eventName);
    } catch (e) {
      emit(MyPositionFailure(
        state.copyWith(
          isRunning: false,
          status: MyPositionStatus.error,
          eventId: event.eventId,
        ),
        "Impossible de démarrer le suivi de la position",
      ));
      return;
    }

    final running = await myPositionLocator.backgroundService.isTrackingRunning();

    posCount = 0;

    emit(MyPositionStarted(state.copyWith(
      isRunning: running,
      status: running ? MyPositionStatus.success : MyPositionStatus.error,
      eventId: event.eventId,
    )));
  }

  void _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    await myPositionLocator.stop();

    final running = await myPositionLocator.backgroundService.isTrackingRunning();

    posCount = 0;

    emit(MyPositionStopped(state.copyWith(
      isRunning: running,
      status: running ? MyPositionStatus.error : MyPositionStatus.success,
    )));
  }
}
