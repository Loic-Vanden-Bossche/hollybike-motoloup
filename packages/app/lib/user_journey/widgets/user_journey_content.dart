/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

import 'user_journey_modal.dart';

class UserJourneyContent extends StatelessWidget {
  final UserJourney existingJourney;
  final MinimalUser? user;
  final Color color;
  final bool isCurrentEvent;
  final void Function()? onDeleted;
  final bool showDate;
  final void Function(UserJourney)? onJourneySelected;
  final Color? accentColor;

  const UserJourneyContent({
    super.key,
    required this.existingJourney,
    this.user,
    this.color = Colors.transparent,
    required this.isCurrentEvent,
    this.onDeleted,
    required this.showDate,
    this.onJourneySelected,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final highlight = accentColor ?? scheme.secondary.withValues(alpha: 0.24);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showDate)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.onPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: scheme.onPrimary.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Text(
                        'Trajet du ${existingJourney.dateLabel}',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.76),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(600)],
                        ),
                      ),
                    ),
                  if (showDate) const Spacer(),
                  if (onJourneySelected != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: highlight.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: highlight.withValues(alpha: 0.42),
                        ),
                      ),
                      child: Text(
                        'Choisir',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.86),
                          fontSize: 11,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                    ),
                ],
              ),
              if (showDate || onJourneySelected != null)
                const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      existingJourney.distanceLabel,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 22,
                        fontVariations: const [FontVariation.weight(760)],
                        height: 1.0,
                      ),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: highlight.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: highlight.withValues(alpha: 0.38),
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
                          existingJourney.totalTimeLabel,
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
                  _JourneyMetricPill(
                    icon: Icons.north_east_rounded,
                    label: 'D+',
                    value:
                        '${existingJourney.totalElevationGain?.round() ?? 0} m',
                    accentColor: highlight,
                  ),
                  _JourneyMetricPill(
                    icon: Icons.terrain_rounded,
                    label: 'Alt max',
                    value: '${existingJourney.maxElevation?.round() ?? 0} m',
                    accentColor: highlight,
                  ),
                  _JourneyMetricPill(
                    icon: Icons.speed_rounded,
                    label: 'V max',
                    value: existingJourney.maxSpeedLabel,
                    accentColor: highlight,
                  ),
                  _JourneyMetricPill(
                    icon: Icons.gps_fixed_rounded,
                    label: 'G max',
                    value: existingJourney.maxGForceLabel,
                    accentColor: highlight,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: scheme.onPrimary.withValues(alpha: 0.09),
              highlightColor: scheme.onPrimary.withValues(alpha: 0.05),
              onTap:
                  onJourneySelected == null ? () => showDetails(context) : null,
              onTapDown:
                  onJourneySelected != null
                      ? (details) => showJourneyMenu(context, details)
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  void showJourneyMenu(BuildContext context, TapDownDetails details) async {
    final value = await showGlassPopupMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        glassPopupMenuItem(value: 'select', label: 'Sélectionner ce trajet'),
        glassPopupMenuItem(value: 'details', label: 'Détails du trajet'),
      ],
    );

    if (value == 'select') {
      onJourneySelected?.call(existingJourney);
    } else if (value == 'details' && context.mounted) {
      showDetails(context);
    }
  }

  void showDetails(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        final eventDetailsBloc = context.readOrNull<EventDetailsBloc>();

        final modal = UserJourneyModal(
          journey: existingJourney,
          user: user,
          isCurrentEvent: isCurrentEvent,
          onDeleted: onDeleted,
        );

        if (eventDetailsBloc == null) {
          return modal;
        }

        return BlocProvider<EventDetailsBloc>.value(
          value: eventDetailsBloc,
          child: modal,
        );
      },
    );
  }
}

class _JourneyMetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  const _JourneyMetricPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: scheme.onPrimary.withValues(alpha: 0.05),
        border: Border.all(color: accentColor.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onPrimary.withValues(alpha: 0.72)),
          const SizedBox(width: 6),
          Text(
            '$label $value',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.82),
              fontSize: 10.8,
              fontVariations: const [FontVariation.weight(620)],
            ),
          ),
        ],
      ),
    );
  }
}

extension ReadOrNull on BuildContext {
  T? readOrNull<T>() {
    try {
      return read<T>();
    } on ProviderNotFoundException catch (_) {
      return null;
    }
  }
}
