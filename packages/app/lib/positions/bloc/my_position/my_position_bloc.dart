/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/services/auth_persistence.dart';
import '../../background/background_location_facade.dart';
import 'my_position_event.dart';

import 'dart:async';

class MyPositionBloc extends Bloc<MyPositionEvent, MyPositionState> {
  static const double _maxAcceptedAccuracy = 20.0;

  final EventRepository eventRepository;
  final BackgroundLocationFacade locationFacade;
  final AuthPersistence authPersistence;
  StreamSubscription<double>? _positionSubscription;

  int posCount = 0;

  MyPositionBloc({
    required this.eventRepository,
    required this.locationFacade,
    required this.authPersistence,
  }) : super(MyPositionInitial()) {
    on<SubscribeToMyPositionUpdates>(_onSubscribeToPositionUpdates);
    on<EnableSendPosition>(_onListenAndSendUserPosition);
    on<DisableSendPositions>(_onDisableSendPositions);
  }

  Future<void> _onSubscribeToPositionUpdates(
    SubscribeToMyPositionUpdates event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getInt('tracking_event_id');

    emit(
      MyPositionInitialized(state.copyWith(isRunning: false, eventId: null)),
    );

    final isRunning =
        await locationFacade.backgroundService.isTrackingRunning();

    emit(
      MyPositionInitialized(
        state.copyWith(
          isRunning: isRunning,
          eventId: isRunning ? eventId : null,
        ),
      ),
    );

    posCount = 0;

    // Listen to background position ticks from headless isolate via MethodChannel.
    await _positionSubscription?.cancel();
    _positionSubscription = locationFacade.backgroundService
        .getPositionStream()
        .listen((accuracy) {
          if (accuracy > _maxAcceptedAccuracy) {
            return;
          }

          posCount++;
          if (posCount >= 2 && (eventId != null)) {
            // Keep your existing UX hook (after a couple samples)
            eventRepository.onUserPositionSent(eventId);
          }
        });
  }

  Future<void> _onListenAndSendUserPosition(
    EnableSendPosition event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tracking_event_id', event.eventId);

    if (state.isRunning) {
      await locationFacade.stop();
    }

    try {
      final session = await authPersistence.currentSession;
      await locationFacade.start(event.eventId, session!);
    } catch (e) {
      emit(
        MyPositionFailure(
          state.copyWith(
            isRunning: false,
            status: MyPositionStatus.error,
            eventId: event.eventId,
          ),
          "Impossible de démarrer le suivi de la position",
        ),
      );
      return;
    }

    final running = await locationFacade.backgroundService.isTrackingRunning();
    posCount = 0;

    emit(
      MyPositionStarted(
        state.copyWith(
          isRunning: running,
          status: running ? MyPositionStatus.success : MyPositionStatus.error,
          eventId: event.eventId,
        ),
      ),
    );
  }

  Future<void> _onDisableSendPositions(
    DisableSendPositions event,
    Emitter<MyPositionState> emit,
  ) async {
    emit(MyPositionLoading(state));

    await locationFacade.stop();

    final running = await locationFacade.backgroundService.isTrackingRunning();
    posCount = 0;

    emit(
      MyPositionStopped(
        state.copyWith(
          isRunning: running,
          status: running ? MyPositionStatus.error : MyPositionStatus.success,
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await locationFacade.dispose();
    return super.close();
  }
}
