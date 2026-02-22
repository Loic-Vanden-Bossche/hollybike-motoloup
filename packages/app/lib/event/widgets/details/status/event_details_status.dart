/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/event_status.dart';

import '../../../../shared/utils/dates.dart';
import '../../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../../bloc/event_details_bloc/event_details_event.dart';
import '../../../bloc/event_details_bloc/event_details_state.dart';
import '../../../types/event.dart';

class EventDetailsStatusBadge extends StatelessWidget {
  final void Function()? onAction;
  final String? actionText;
  final bool loading;
  final EventStatusState status;
  final String message;
  final Event? event;

  const EventDetailsStatusBadge({
    super.key,
    this.loading = false,
    required this.message,
    required this.status,
    this.onAction,
    this.actionText,
    this.event,
  });

  Color _statusColor() => Event.getStatusColor(status);

  bool _isLoading(EventDetailsState state) =>
      state is EventOperationInProgress || loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor();

    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      builder: (context, state) {
        final isLoading = _isLoading(state);

        return ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    statusColor.withValues(alpha: 0.16),
                    scheme.primary.withValues(alpha: 0.45),
                  ],
                ),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.28),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildStatus(context, statusColor)),
                        const SizedBox(width: 8),
                        _buildAction(context, isLoading, statusColor),
                      ],
                    ),
                  ),
                  // Loading progress bar at the bottom of the card
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 150),
                    crossFadeState:
                        isLoading
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    firstChild: const SizedBox(height: 3, width: double.infinity),
                    secondChild: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: statusColor.withValues(alpha: 0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatus(BuildContext context, Color statusColor) {
    final scheme = Theme.of(context).colorScheme;
    final minimalEvent = event?.toMinimalEvent();

    if (minimalEvent == null) {
      return Row(
        children: [
          // Glowing status dot
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.55),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.88),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(600)],
              ),
              softWrap: true,
            ),
          ),
        ],
      );
    }

    return EventStatusIndicator(
      event: minimalEvent,
      eventStarted: () => _eventStarted(context),
      statusTextBuilder: (status) {
        return Text(
          fromDateToDuration(minimalEvent.startDate),
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.88),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(600)],
          ),
          softWrap: true,
        );
      },
      separatorWidth: 12,
    );
  }

  Widget _buildAction(BuildContext context, bool isLoading, Color statusColor) {
    if (actionText == null || onAction == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: isLoading ? null : onAction,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isLoading ? 0.45 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: statusColor.withValues(alpha: 0.15),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.40),
              width: 1,
            ),
          ),
          child: Text(
            actionText!,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontVariations: const [FontVariation.weight(700)],
            ),
          ),
        ),
      ),
    );
  }

  void _eventStarted(BuildContext context) {
    context.read<EventDetailsBloc>().add(EventStarted());
  }
}
