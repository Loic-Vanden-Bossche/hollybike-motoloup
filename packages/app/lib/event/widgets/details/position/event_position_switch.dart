/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/shared/widgets/switch_with_text.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../positions/bloc/my_position/my_position_bloc.dart';
import '../../../../positions/bloc/my_position/my_position_event.dart';
import '../../../../positions/bloc/my_position/my_position_state.dart';

class EventPositionSwitch extends StatelessWidget {
  final EventDetails eventDetails;

  const EventPositionSwitch({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPositionBloc, MyPositionState>(
      builder: (context, state) {
        final isLoading = state is MyPositionLoading;

        final isEligible =
            eventDetails.callerParticipation != null &&
            eventDetails.callerParticipation?.journey == null &&
            eventDetails.event.status == EventStatusState.now;

        final isTracking = state.isRunning;
        final isCurrentEvent = state.eventId == eventDetails.event.id;
        final isShown = isEligible || isTracking;

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child:
              isShown
                  ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _switchContent(
                      context,
                      state,
                      isCurrentEvent || !isTracking,
                      isLoading,
                    ),
                  )
                  : const SizedBox(width: double.infinity),
        );
      },
    );
  }

  Widget _switchContent(
    BuildContext context,
    MyPositionState state,
    bool isCurrent,
    bool isLoading,
  ) {
    final scheme = Theme.of(context).colorScheme;

    if (!isCurrent) {
      return Row(
        children: [
          Icon(Icons.location_on_rounded, color: scheme.secondary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Votre position est partagée sur un autre événement',
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.75),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(550)],
              ),
            ),
          ),
        ],
      );
    }

    return SwitchWithText(
      alignment: SwitchAlignment.right,
      text: getSwitchLabel(state.isRunning),
      value: state.isRunning,
      onChange: () => _onSelected(context, state.isRunning, isLoading),
    );
  }

  String getSwitchLabel(bool isRunning) {
    return isRunning
        ? 'Votre position est partagée avec les autres participants'
        : 'Le partage de votre position désactivé';
  }

  void _onSelected(BuildContext context, bool isRunning, bool isLoading) {
    if (isLoading) return;
    if (isRunning) {
      _cancelPositions(context);
    } else {
      _onStart(context);
    }
  }

  void _onStart(BuildContext context) async {
    if (await _checkLocationPermission() && context.mounted) {
      context.read<MyPositionBloc>().add(
        EnableSendPosition(
          eventId: eventDetails.event.id,
          eventName: eventDetails.event.name,
        ),
      );
    }
  }

  Future<bool> _checkLocationPermission() async {
    final perm = await Permission.location.request();
    await Permission.notification.request();
    return perm.isGranted;
  }

  void _cancelPositions(BuildContext context) {
    context.read<MyPositionBloc>().add(DisableSendPositions());
  }
}
