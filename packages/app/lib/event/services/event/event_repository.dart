/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_journey_steps_state.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/participation/event_caller_participation.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/shared/utils/streams/stream_counter.dart';
import 'package:hollybike/shared/utils/streams/stream_value.dart';

import '../../../shared/utils/streams/stream_mapper.dart';
import '../../../user_journey/type/user_journey.dart';
import '../../types/event.dart';
import '../../types/event_journey_step.dart';
import '../../types/minimal_event.dart';
import '../../types/participation/event_participation.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;
  static const int participatingStreamKey = -1;

  final int numberOfEventsPerRequest = 10;

  final _eventDetailsStreamMapper = StreamMapper<EventDetails?, void>(
    seedValue: null,
    name: "event-details",
  );

  Stream<StreamValue<EventDetails?, void>> eventDetailsStream(int eventId) =>
      _eventDetailsStreamMapper.stream(eventId);

  final _userStreamMapper = StreamMapper<List<MinimalEvent>, RefreshedType>(
    seedValue: [],
    initialState: RefreshedType.none,
    name: "user-events",
  );

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>> userEventsStream(
    int userId,
  ) => _userStreamMapper.stream(userId);

  final _futureEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
        [],
        "future-events",
        initialState: RefreshedType.none,
      );

  final _archivedEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
        [],
        "archived-events",
        initialState: RefreshedType.none,
      );

  final _searchEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
        [],
        "search-events",
        initialState: RefreshedType.none,
      );

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>> get futureStream =>
      _futureEventsStreamCounter.stream;

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>>
  get archivedEventsStream => _archivedEventsStreamCounter.stream;

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>>
  get searchEventsStream => _searchEventsStreamCounter.stream;

  String _lastQuery = "";

  EventRepository({required this.eventApi});

  Future<PaginatedList<MinimalEvent>> fetchEvents(
    String? requestType,
    int page, {
    int? userId,
    String? query,
  }) async {
    final streamKey =
        requestType == "participating"
            ? (userId ?? participatingStreamKey)
            : null;

    final pageResult = await eventApi.getEvents(
      requestType,
      page,
      numberOfEventsPerRequest,
      userId: userId,
      query: query,
    );

    if (streamKey != null && _userStreamMapper.containsKey(streamKey)) {
      _userStreamMapper.add(
        streamKey,
        _userStreamMapper.get(streamKey)! + pageResult.items,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureEventsStreamCounter.add(
          _futureEventsStreamCounter.value + pageResult.items,
        );
        break;
      case "archived":
        _archivedEventsStreamCounter.add(
          _archivedEventsStreamCounter.value + pageResult.items,
        );
        break;
      default:
        _searchEventsStreamCounter.add(
          _searchEventsStreamCounter.value + pageResult.items,
        );
        break;
    }

    return pageResult;
  }

  Future<PaginatedList<MinimalEvent>> refreshEvents(
    String? requestType, {
    int? userId,
    String? query,
  }) async {
    if (query != null) {
      _lastQuery = query;
    }

    final streamKey =
        requestType == "participating"
            ? (userId ?? participatingStreamKey)
            : null;

    final pageResult = await eventApi.getEvents(
      requestType,
      0,
      numberOfEventsPerRequest,
      userId: userId,
      query: query,
    );

    if (streamKey != null) {
      _userStreamMapper.add(
        streamKey,
        pageResult.items,
        state: pageResult.refreshedType,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
        );
        break;
      case "archived":
        _archivedEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
        );
        break;
      default:
        _searchEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
        );
        break;
    }

    return pageResult;
  }

  Future<EventDetails> fetchEventDetails(int eventId) async {
    final eventDetails = await eventApi.getEventDetails(eventId);

    _eventDetailsStreamMapper.add(eventId, eventDetails);

    return eventDetails;
  }

  Future<Event> createEvent(EventFormData event) async {
    return eventApi.createEvent(event);
  }

  Future<void> editEvent(int eventId, EventFormData event) async {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final editedEvent = await eventApi.editEvent(
      eventId,
      event.withBudget(details.event.budget),
    );

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(event: editedEvent),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map((e) => e.id == eventId ? editedEvent.toMinimalEvent() : e)
            .toList(),
      );
    }
  }

  Future<void> publishEvent(int eventId) async {
    await eventApi.publishEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.scheduled),
      ),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map(
              (e) =>
                  e.id == eventId
                      ? e.copyWith(status: EventStatusState.scheduled)
                      : e,
            )
            .toList(),
      );
    }
  }

  Future<void> joinEvent(int eventId) async {
    final participation = await eventApi.joinEvent(eventId);

    final userId = participation.user.id;

    final events = _userStreamMapper.get(userId);

    if (events != null) {
      if (events.any((e) => e.id == eventId)) {
        await refreshEvents("future", userId: userId);
      }
    }

    if (_userStreamMapper.containsKey(participatingStreamKey)) {
      await refreshEvents("participating");
    }

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    onParticipantsAdded([participation], eventId, firstAsCaller: true);
  }

  Future<void> leaveEvent(int eventId) async {
    final details = _eventDetailsStreamMapper.get(eventId);

    await eventApi.leaveEvent(eventId);

    if (details == null || details.callerParticipation == null) {
      return;
    }

    final userId = details.callerParticipation!.userId;

    final events = _userStreamMapper.get(userId);

    if (events != null) {
      if (events.any((e) => e.id == eventId)) {
        await refreshEvents("future", userId: userId);
      }
    }

    if (_userStreamMapper.containsKey(participatingStreamKey)) {
      await refreshEvents("participating");
    }

    _eventDetailsStreamMapper.add(
      eventId,
      EventDetails(
        expenses: details.expenses,
        totalExpense: details.totalExpense,
        event: details.event,
        journeySteps: details.journeySteps,
        currentStepId: details.currentStepId,
        currentJourney: details.currentJourney,
        callerParticipation: null,
        previewParticipants: details.previewParticipants,
        previewParticipantsCount: details.previewParticipantsCount,
      ),
    );

    onParticipantRemoved(userId, eventId);
  }

  Future<void> deleteEvent(int eventId) async {
    await eventApi.deleteEvent(eventId);

    for (var userId in _userStreamMapper.keys) {
      final events = _userStreamMapper.get(userId);

      if (events == null) {
        continue;
      }

      if (events.any((e) => e.id == eventId)) {
        if (userId == participatingStreamKey) {
          refreshEvents("participating");
        } else {
          refreshEvents("future", userId: userId);
        }
      }
    }

    if (_futureEventsStreamCounter.isListening) {
      final events = _futureEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents("future");
      }
    }

    if (_archivedEventsStreamCounter.isListening) {
      final events = _archivedEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents("archived");
      }
    }

    if (_searchEventsStreamCounter.isListening) {
      final events = _searchEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents(null, query: _lastQuery);
      }
    }
  }

  Future<void> cancelEvent(int eventId) async {
    await eventApi.cancelEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.canceled),
      ),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map(
              (e) =>
                  e.id == eventId
                      ? e.copyWith(status: EventStatusState.canceled)
                      : e,
            )
            .toList(),
      );
    }
  }

  Future<void> finishEvent(int eventId) async {
    await eventApi.finishEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.finished),
      ),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map(
              (e) =>
                  e.id == eventId
                      ? e.copyWith(status: EventStatusState.finished)
                      : e,
            )
            .toList(),
      );
    }

    for (final userId in _userStreamMapper.keys) {
      if (userId == participatingStreamKey) {
        await refreshEvents("participating");
      } else {
        await refreshEvents("future", userId: userId);
      }
    }

    if (_futureEventsStreamCounter.isListening) {
      await refreshEvents("future");
    }

    if (_archivedEventsStreamCounter.isListening) {
      await refreshEvents("archived");
    }

    if (_searchEventsStreamCounter.isListening) {
      await refreshEvents(null, query: _lastQuery);
    }
  }

  void onParticipantRemoved(int userId, int eventId) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        previewParticipants:
            details.previewParticipants
                .where((p) => p.user.id != userId)
                .toList(),
        previewParticipantsCount: details.previewParticipantsCount - 1,
      ),
    );
  }

  void onParticipantsAdded(
    List<EventParticipation> participants,
    int eventId, {
    bool firstAsCaller = false,
  }) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final updatedPreviewParticipants =
        [...details.previewParticipants, ...participants].take(5).toList();

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        previewParticipants: updatedPreviewParticipants,
        previewParticipantsCount:
            details.previewParticipantsCount + participants.length,
        callerParticipation:
            firstAsCaller
                ? participants.first.toEventCallerParticipation()
                : details.callerParticipation,
      ),
    );
  }

  void onImagesVisibilityUpdated(bool isPublic, int eventId) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          isImagesPublic: isPublic,
        ),
      ),
    );
  }

  Future<void> addJourneyStepToEvent(
    int eventId,
    Journey journey, {
    String? name,
    int? position,
  }) async {
    final state = await eventApi.addJourneyStepToEvent(
      eventId,
      journey.id,
      name: name,
      position: position,
    );
    _applyJourneyStepsState(eventId, state);
    await _refreshEventDetails(eventId);
  }

  Future<void> renameJourneyStepInEvent(
    int eventId,
    int stepId,
    String name,
  ) async {
    final state = await eventApi.renameJourneyStepInEvent(
      eventId,
      stepId,
      name,
    );
    _applyJourneyStepsState(eventId, state);
    await _refreshEventDetails(eventId);
  }

  Future<void> setCurrentJourneyStep(int eventId, int stepId) async {
    final state = await eventApi.setCurrentJourneyStep(eventId, stepId);
    _applyJourneyStepsState(eventId, state);
    await _refreshEventDetails(eventId);
  }

  Future<void> removeJourneyStepFromEvent(int eventId, int stepId) async {
    final state = await eventApi.removeJourneyStepFromEvent(eventId, stepId);
    _applyJourneyStepsState(eventId, state);
    await _refreshEventDetails(eventId);
  }

  Future<List<EventJourneyStep>> getJourneySteps(int eventId) async {
    final state = await eventApi.getJourneySteps(eventId);
    _applyJourneyStepsState(eventId, state);
    return state.journeySteps;
  }

  void _applyJourneyStepsState(int eventId, EventJourneyStepsState stepState) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) return;

    final caller = details.callerParticipation;
    final updatedStepJourneys = _reconcileCallerStepJourneys(
      caller,
      stepState,
      details,
    );
    final currentStepState =
        updatedStepJourneys
            ?.where(
              (EventCallerParticipationStepJourney stepJourney) =>
                  stepJourney.stepId == stepState.currentStepId,
            )
            .firstOrNull;
    final currentStepId = stepState.currentStepId;
    final fallbackJourney =
        currentStepId == null
            ? caller?.journey
            : (caller?.stepJourneys.isEmpty == true &&
                stepState.journeySteps.length == 1 &&
                caller?.journey != null &&
                stepState.journeySteps.first.id == currentStepId)
            ? caller?.journey
            : null;
    final fallbackHasRecordedPositions =
        currentStepId == null
            ? caller?.hasRecordedPositions ?? false
            : (caller?.stepJourneys.isEmpty == true &&
                stepState.journeySteps.length == 1 &&
                stepState.journeySteps.first.id == currentStepId)
            ? caller?.hasRecordedPositions ?? false
            : false;

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        journeySteps: stepState.journeySteps,
        currentStepId: stepState.currentStepId,
        currentJourney: stepState.currentJourney,
        callerParticipation:
            caller == null
                ? null
                : caller.copyWith(
                  journey: currentStepState?.journey ?? fallbackJourney,
                  hasRecordedPositions:
                      currentStepState?.hasRecordedPositions ??
                      fallbackHasRecordedPositions,
                  stepJourneys: updatedStepJourneys ?? const [],
                ),
      ),
    );
  }

  List<EventCallerParticipationStepJourney>? _reconcileCallerStepJourneys(
    EventCallerParticipation? caller,
    EventJourneyStepsState stepState,
    EventDetails details,
  ) {
    if (caller == null) {
      return null;
    }

    if (stepState.journeySteps.isEmpty) {
      return const [];
    }

    final existingByStepId = {
      for (final stepJourney in caller.stepJourneys)
        stepJourney.stepId: stepJourney,
    };

    return stepState.journeySteps.map((step) {
      final existing = existingByStepId[step.id];
      if (existing != null) {
        return existing;
      }

      final shouldSeedFromLegacyCurrent =
          caller.stepJourneys.isEmpty &&
          caller.journey != null &&
          details.currentStepId == null &&
          stepState.currentStepId == step.id &&
          stepState.journeySteps.length == 1;

      if (shouldSeedFromLegacyCurrent) {
        return EventCallerParticipationStepJourney(
          stepId: step.id,
          journey: caller.journey,
          hasRecordedPositions: caller.hasRecordedPositions,
        );
      }

      return EventCallerParticipationStepJourney(
        stepId: step.id,
        journey: null,
        hasRecordedPositions: false,
      );
    }).toList();
  }

  Future<void> _refreshEventDetails(int eventId) async {
    if (_eventDetailsStreamMapper.get(eventId) == null) {
      return;
    }

    final refreshedDetails = await eventApi.getEventDetails(eventId);
    _eventDetailsStreamMapper.add(eventId, refreshedDetails);
  }

  Future<UserJourney> terminateUserJourney(int eventId, {int? stepId}) async {
    final userJourney = await eventApi.terminateUserJourney(
      eventId,
      stepId: stepId,
    );

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return userJourney;
    }

    final targetedStepId = stepId ?? details.currentStepId;
    final updatedStepJourneys =
        details.callerParticipation?.stepJourneys.map((entry) {
          if (entry.stepId != targetedStepId) return entry;
          return entry.copyWith(
            journey: userJourney,
            hasRecordedPositions: false,
          );
        }).toList() ??
        const [];
    final currentStepState =
        updatedStepJourneys
            .where((entry) => entry.stepId == details.currentStepId)
            .firstOrNull;

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          journey: currentStepState?.journey ?? userJourney,
          hasRecordedPositions: currentStepState?.hasRecordedPositions ?? false,
          stepJourneys: updatedStepJourneys,
        ),
      ),
    );

    return userJourney;
  }

  Future<UserJourney?> resetUserJourney(int eventId, {int? stepId}) async {
    await eventApi.resetUserJourney(eventId, stepId: stepId);

    final details = _eventDetailsStreamMapper.get(eventId);

    final caller = details?.callerParticipation;

    if (caller == null) {
      return null;
    }

    final targetedStepId = stepId ?? details?.currentStepId;
    final resetJourney =
        caller.stepJourneys
            .where((entry) => entry.stepId == targetedStepId)
            .firstOrNull
            ?.journey;
    final updatedStepJourneys =
        caller.stepJourneys.map((entry) {
          if (entry.stepId != targetedStepId) return entry;
          return entry.copyWith(journey: null, hasRecordedPositions: false);
        }).toList();
    final currentStepState =
        updatedStepJourneys
            .where((entry) => entry.stepId == details?.currentStepId)
            .firstOrNull;

    _eventDetailsStreamMapper.add(
      eventId,
      details?.copyWith(
        callerParticipation: EventCallerParticipation(
          userId: caller.userId,
          isImagesPublic: caller.isImagesPublic,
          role: caller.role,
          joinedDateTime: caller.joinedDateTime,
          journey: currentStepState?.journey,
          hasRecordedPositions: currentStepState?.hasRecordedPositions ?? false,
          stepJourneys: updatedStepJourneys,
        ),
      ),
    );

    return resetJourney ?? caller.journey;
  }

  void onUserPositionSent(int eventId) {
    final details = _eventDetailsStreamMapper.get(eventId);
    final caller = details?.callerParticipation;

    if (caller == null) {
      return;
    }

    final currentStepId = details?.currentStepId;
    if (currentStepId == null) {
      if (caller.hasRecordedPositions) {
        return;
      }
      _eventDetailsStreamMapper.add(
        eventId,
        details?.copyWith(
          callerParticipation: caller.copyWith(hasRecordedPositions: true),
        ),
      );
      return;
    }

    final updatedStepJourneys =
        caller.stepJourneys.map((stepJourney) {
          if (stepJourney.stepId != currentStepId) return stepJourney;
          if (stepJourney.hasRecordedPositions) return stepJourney;
          return stepJourney.copyWith(hasRecordedPositions: true);
        }).toList();
    final currentStepState =
        updatedStepJourneys
            .where((stepJourney) => stepJourney.stepId == currentStepId)
            .firstOrNull;

    if (currentStepState?.hasRecordedPositions != true &&
        caller.hasRecordedPositions) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details?.copyWith(
        callerParticipation: caller.copyWith(
          hasRecordedPositions: currentStepState?.hasRecordedPositions ?? true,
          stepJourneys: updatedStepJourneys,
        ),
      ),
    );
  }

  Future<void> deleteExpense(int expenseId, int eventId) async {
    await eventApi.deleteExpense(expenseId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    int? newTotal = details.totalExpense;

    final newExpenses =
        details.expenses?.where((e) {
          if (e.id == expenseId) {
            final totalExpense = details.totalExpense;
            if (totalExpense != null) {
              newTotal = totalExpense - e.amount;
            }
            return false;
          }

          return true;
        }).toList();

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(expenses: newExpenses, totalExpense: newTotal),
    );
  }

  Future<EventExpense> addExpense(
    int eventId,
    String name,
    int amount,
    String? description,
  ) async {
    final expense = await eventApi.addExpense(
      eventId,
      name,
      amount,
      description,
    );

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return expense;
    }

    final newTotal = (details.totalExpense ?? 0) + amount;

    final newExpenses = <EventExpense>[expense, ...details.expenses ?? []];

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(expenses: newExpenses, totalExpense: newTotal),
    );

    return expense;
  }

  Future<void> editBudget(int eventId, int? budget) async {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    await eventApi.editEvent(
      eventId,
      EventFormData(
        name: details.event.name,
        description: details.event.description,
        startDate: details.event.startDate,
        endDate: details.event.endDate,
        budget: budget,
      ),
    );

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: Event(
          id: details.event.id,
          name: details.event.name,
          description: details.event.description,
          status: details.event.status,
          budget: budget,
          startDate: details.event.startDate,
          endDate: details.event.endDate,
          owner: details.event.owner,
          createdAt: details.event.createdAt,
          updatedAt: details.event.updatedAt,
          image: details.event.image,
        ),
      ),
    );
  }

  Future<void> downloadReport(int eventId) async {
    final authPersistence = AuthPersistence();

    final session = await authPersistence.currentSession;

    final details = _eventDetailsStreamMapper.get(eventId);

    if (session == null || details == null) {
      return;
    }

    final eventName = details.event.name.replaceAll(" ", "_").toLowerCase();
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();

    await eventApi.downloadExpensesReport(
      "depenses_${eventName}_$uniqueKey.csv",
      eventId,
    );
  }

  Future<void> uploadExpenseProof(
    int eventId,
    int expenseId,
    File image,
  ) async {
    final updatedExpense = await eventApi.uploadExpenseProof(expenseId, image);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final newExpenses =
        details.expenses?.map((e) {
          if (e.id == expenseId) {
            return updatedExpense;
          }

          return e;
        }).toList();

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(expenses: newExpenses),
    );
  }

  void eventStarted(int eventId) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.now),
      ),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map(
              (e) =>
                  e.id == eventId
                      ? e.copyWith(status: EventStatusState.now)
                      : e,
            )
            .toList(),
      );
    }
  }

  void onUserJourneyRemoved(int userJourneyId) {
    for (final counter in _eventDetailsStreamMapper.counters) {
      final participation = counter.value?.callerParticipation;

      if (participation == null) {
        continue;
      }

      final hasMatchingStepJourney = participation.stepJourneys.any(
        (stepJourney) => stepJourney.journey?.id == userJourneyId,
      );

      if (participation.journey?.id == userJourneyId ||
          hasMatchingStepJourney) {
        final updatedStepJourneys =
            participation.stepJourneys.map((stepJourney) {
              if (stepJourney.journey?.id == userJourneyId) {
                return stepJourney.copyWith(
                  journey: null,
                  hasRecordedPositions: false,
                );
              }
              return stepJourney;
            }).toList();
        final currentStepState =
            updatedStepJourneys
                .where(
                  (stepJourney) =>
                      stepJourney.stepId == counter.value?.currentStepId,
                )
                .firstOrNull;
        counter.add(
          counter.value?.copyWith(
            callerParticipation: EventCallerParticipation(
              userId: participation.userId,
              isImagesPublic: participation.isImagesPublic,
              role: participation.role,
              joinedDateTime: participation.joinedDateTime,
              journey: currentStepState?.journey,
              hasRecordedPositions:
                  currentStepState?.hasRecordedPositions ?? false,
              stepJourneys: updatedStepJourneys,
            ),
          ),
        );
      }
    }
  }

  Future<void> uploadEventImage(int eventId, File image) async {
    final updatedEvent = await eventApi.uploadEventImage(eventId, image);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(event: updatedEvent),
    );

    for (var counter
        in [
              _futureEventsStreamCounter,
              _archivedEventsStreamCounter,
              _searchEventsStreamCounter,
            ] +
            _userStreamMapper.counters) {
      counter.add(
        counter.value
            .map((e) => e.id == eventId ? updatedEvent.toMinimalEvent() : e)
            .toList(),
      );
    }
  }
}
