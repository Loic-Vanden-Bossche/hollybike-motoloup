/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../journey/type/journey.dart';

@immutable
abstract class EventJourneyEvent {}

class UploadJourneyFileToEvent extends EventJourneyEvent {
  final int eventId;
  final String name;
  final String? stepName;
  final File file;

  UploadJourneyFileToEvent({
    required this.eventId,
    required this.name,
    required this.stepName,
    required this.file,
  });
}

class AttachJourneyToEvent extends EventJourneyEvent {
  final int eventId;
  final Journey journey;
  final String? stepName;
  final int? position;

  AttachJourneyToEvent({
    required this.eventId,
    required this.journey,
    this.stepName,
    this.position,
  });
}

class RemoveJourneyStepFromEvent extends EventJourneyEvent {
  final int eventId;
  final int stepId;

  RemoveJourneyStepFromEvent({required this.eventId, required this.stepId});
}

class RenameJourneyStepInEvent extends EventJourneyEvent {
  final int eventId;
  final int stepId;
  final String name;

  RenameJourneyStepInEvent({
    required this.eventId,
    required this.stepId,
    required this.name,
  });
}

class SetCurrentJourneyStep extends EventJourneyEvent {
  final int eventId;
  final int stepId;

  SetCurrentJourneyStep({required this.eventId, required this.stepId});
}
