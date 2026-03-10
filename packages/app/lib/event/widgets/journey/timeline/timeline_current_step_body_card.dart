/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_journey_step.dart';
import 'package:hollybike/event/types/participation/event_caller_participation_step_journey.dart';
import 'package:hollybike/event/widgets/journey/journey_modal.dart';
import 'package:hollybike/event/widgets/journey/timeline/timeline_metric_chip.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user_journey/widgets/user_journey_modal.dart';

/// Body content for the current step — route image, metrics, and user journey.
/// Rendered below [TimelineCurrentStepTitleCard] in a separate timeline body row.
class TimelineCurrentStepBodyCard extends StatelessWidget {
  final EventJourneyStep step;
  final EventCallerParticipationStepJourney? stepJourney;
  final EventDetails eventDetails;
  final void Function(int stepId) onViewOnMap;

  const TimelineCurrentStepBodyCard({
    super.key,
    required this.step,
    required this.stepJourney,
    required this.eventDetails,
    required this.onViewOnMap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: 0.56),
                scheme.primary.withValues(alpha: 0.42),
              ],
            ),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Route section — InkWell layered above image via Stack
                // so the ripple is visible over the image.
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: AspectRatio(
                            aspectRatio: 1.66,
                            child: LayoutBuilder(
                              builder: (context, constraints) => OverflowBox(
                                maxHeight: constraints.maxHeight + 25,
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight + 25,
                                  child: JourneyImage(
                                    imageKey: step.journey.previewImageKey,
                                    imageUrl: step.journey.previewImage,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            TimelineMetricChip(
                              icon: Icons.route_outlined,
                              label: step.journey.distanceLabel,
                            ),
                            TimelineMetricChip(
                              icon: Icons.north_east_rounded,
                              label: '${step.journey.totalElevationGain ?? 0} m',
                            ),
                            TimelineMetricChip(
                              icon: Icons.south_east_rounded,
                              label: '${step.journey.totalElevationLoss ?? 0} m',
                            ),
                            if (step.journey.readablePartialLocation != null)
                              TimelineMetricChip(
                                icon: Icons.location_on_outlined,
                                label: step.journey.readablePartialLocation!,
                              ),
                          ],
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _openRouteDetails(context),
                        ),
                      ),
                    ),
                  ],
                ),
                // User journey section
                ..._buildUserJourneySection(context, scheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openRouteDetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<EventJourneyBloc>(),
        child: JourneyModal(
          journey: step.journey,
          stepId: step.id,
          onViewOnMap: onViewOnMap,
        ),
      ),
    );
  }

  void _openUserJourneyDetails(BuildContext context, UserJourney journey) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => UserJourneyModal(
        journey: journey,
        isCurrentEvent: true,
        stepId: step.id,
      ),
    );
  }

  List<Widget> _buildUserJourneySection(
      BuildContext context, ColorScheme scheme) {
    final sj = stepJourney;

    // No participation record for this user — suppress the section entirely
    if (sj == null) return [];

    final journey = sj.journey;

    // Divider with "MON TRAJET" label
    final divider = <Widget>[
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'MON TRAJET',
            style: TextStyle(
              color: scheme.secondary.withValues(alpha: 0.65),
              fontSize: 9,
              fontVariations: const [FontVariation.weight(700)],
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ];

    if (journey != null) {
      return [
        SizedBox(
          width: double.infinity,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _openUserJourneyDetails(context, journey),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...divider,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        journey.distanceLabel,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 24,
                          fontVariations: const [FontVariation.weight(760)],
                          height: 1.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scheme.secondary.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: scheme.onPrimary.withValues(alpha: 0.78),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            journey.totalTimeLabel,
                            style: TextStyle(
                              color: scheme.onPrimary.withValues(alpha: 0.86),
                              fontSize: 11.5,
                              fontVariations: const [FontVariation.weight(650)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TimelineMetricChip(
                      icon: Icons.north_east_rounded,
                      label: 'D+ ${journey.totalElevationGain?.round() ?? 0} m',
                      accent: scheme.secondary,
                    ),
                    TimelineMetricChip(
                      icon: Icons.terrain_rounded,
                      label: 'Alt ${journey.maxElevation?.round() ?? 0} m',
                      accent: scheme.secondary,
                    ),
                    TimelineMetricChip(
                      icon: Icons.speed_rounded,
                      label: journey.maxSpeedLabel,
                      accent: scheme.secondary,
                    ),
                    TimelineMetricChip(
                      icon: Icons.gps_fixed_rounded,
                      label: journey.maxGForceLabel,
                      accent: scheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ];
    }

    // No journey yet
    if (sj.hasRecordedPositions) {
      return [
        ...divider,
        FilledButton.tonal(
          onPressed: () => context.read<EventDetailsBloc>().add(
                TerminateUserJourney(stepId: step.id),
              ),
          child: const Text('Terminer le parcours'),
        ),
      ];
    }

    return [
      ...divider,
      Text(
        'Aucune position reçue pour cette étape.',
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.55),
          fontSize: 12,
          fontVariations: const [FontVariation.weight(500)],
        ),
      ),
    ];
  }
}
