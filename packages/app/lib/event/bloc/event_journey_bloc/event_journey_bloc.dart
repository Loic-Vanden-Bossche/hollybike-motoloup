/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/journey/service/journey_repository.dart';

import '../../../journey/type/journey.dart';
import '../../services/event/event_repository.dart';
import 'event_journey_event.dart';
import 'event_journey_state.dart';

class EventJourneyBloc extends Bloc<EventJourneyEvent, EventJourneyState> {
  final JourneyRepository journeyRepository;
  final EventRepository eventRepository;

  EventJourneyBloc({
    required this.journeyRepository,
    required this.eventRepository,
  }) : super(EventJourneyInitial()) {
    on<UploadJourneyFileToEvent>(_onUploadJourneyFileToEvent);
    on<AttachJourneyToEvent>(_onAttachJourneyToEvent);
    on<RemoveJourneyStepFromEvent>(_onRemoveJourneyStep);
    on<RenameJourneyStepInEvent>(_onRenameJourneyStep);
    on<SetCurrentJourneyStep>(_onSetCurrentJourneyStep);
  }

  Future<void> _onUploadJourneyFileToEvent(
    UploadJourneyFileToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyCreationInProgress(state));

    Journey journey;

    try {
      journey = await journeyRepository.createJourney(event.name);
    } catch (e) {
      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Une erreur est survenue.',
        ),
      );
      return;
    }

    emit(EventJourneyUploadInProgress(state));

    try {
      await journeyRepository.uploadJourneyFile(journey.id, event.file);

      emit(EventJourneyUploadSuccess(state));

      await eventRepository.addJourneyStepToEvent(
        event.eventId,
        journey,
        name: event.stepName,
      );

      emit(EventJourneyCreationSuccess(state));
    } catch (e) {
      try {
        await journeyRepository.deleteJourney(journey.id);
      } catch (e) {
        log('Error while deleting journey', error: e);
      }

      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Le ficher ne semble pas compatible.',
        ),
      );
    }
  }

  Future<void> _onAttachJourneyToEvent(
    AttachJourneyToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.addJourneyStepToEvent(
        event.eventId,
        event.journey,
        name: event.stepName,
        position: event.position,
      );

      emit(
        EventJourneyOperationSuccess(
          state,
          successMessage: 'Parcours mis à jour',
        ),
      );
    } catch (e) {
      log('Error while attaching journey to event', error: e);
      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Impossible de mettre à jour le parcours.',
        ),
      );
    }
  }

  Future<void> _onRemoveJourneyStep(
    RemoveJourneyStepFromEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.removeJourneyStepFromEvent(
        event.eventId,
        event.stepId,
      );

      emit(
        EventJourneyOperationSuccess(
          state,
          successMessage: 'Parcours retiré de l\'événement.',
        ),
      );
    } catch (e) {
      log('Error while removing journey from event', error: e);
      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Impossible de retirer l\'étape.',
        ),
      );
    }
  }

  Future<void> _onRenameJourneyStep(
    RenameJourneyStepInEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));
    try {
      await eventRepository.renameJourneyStepInEvent(
        event.eventId,
        event.stepId,
        event.name,
      );
      emit(
        EventJourneyOperationSuccess(state, successMessage: 'Étape renommée'),
      );
    } catch (e) {
      log('Error while renaming journey step', error: e);
      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Impossible de renommer l\'étape.',
        ),
      );
    }
  }

  Future<void> _onSetCurrentJourneyStep(
    SetCurrentJourneyStep event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));
    try {
      await eventRepository.setCurrentJourneyStep(event.eventId, event.stepId);
      emit(
        EventJourneyOperationSuccess(
          state,
          successMessage: 'Étape actuelle mise à jour',
        ),
      );
    } catch (e) {
      log('Error while setting current journey step', error: e);
      emit(
        EventJourneyOperationFailure(
          state,
          errorMessage: 'Impossible de changer l\'étape actuelle.',
        ),
      );
    }
  }
}
