/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_step_state.dart';

class StepEntry {
  final EventCallerParticipationStepJourney? stepJourney;
  final EventJourneyStep? step;
  final TimelineStepState stepState;
  final bool isCurrent;
  final bool isPast;
  final bool isFuture;
  final String title;

  const StepEntry({
    required this.stepJourney,
    required this.step,
    required this.stepState,
    required this.isCurrent,
    required this.isPast,
    required this.isFuture,
    required this.title,
  });
}
