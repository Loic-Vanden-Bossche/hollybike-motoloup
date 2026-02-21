/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:add_2_calendar_new/add_2_calendar_new.dart' as add2cal;
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';

import '../../../../shared/utils/dates.dart';
import '../../../types/event_status_state.dart';

class EventScheduledStatus extends StatefulWidget {
  final EventDetails eventDetails;
  final bool isLoading;

  const EventScheduledStatus({
    super.key,
    required this.eventDetails,
    required this.isLoading,
  });

  @override
  State<EventScheduledStatus> createState() => _EventScheduledStatusState();
}

class _EventScheduledStatusState extends State<EventScheduledStatus> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatusBadge(
      loading: _loading || widget.isLoading,
      event: widget.eventDetails.event,
      status: EventStatusState.scheduled,
      message: fromDateToDuration(widget.eventDetails.event.startDate),
      actionText: 'Ajouter au calendrier',
      onAction: _onAddToCalendar,
    );
  }

  Future<void> _onAddToCalendar() async {
    setState(() {
      _loading = true;
    });

    try {
      final result = await add2cal.Add2Calendar.addEvent2Cal(
        add2cal.Event(
          title: widget.eventDetails.event.name,
          description: widget.eventDetails.event.description,
          location: widget.eventDetails.journey?.readablePartialLocation,
          startDate: widget.eventDetails.event.startDate,
          endDate: _endDate(),
        ),
      );

      if (!mounted) {
        return;
      }

      if (result) {
        Toast.showSuccessToast(context, 'Evenement ajoute au calendrier');
      } else {
        Toast.showErrorToast(context, 'Ajout au calendrier annule');
      }
    } catch (_) {
      if (mounted) {
        Toast.showErrorToast(context, 'Erreur lors de l ajout au calendrier');
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  DateTime _endDate() {
    return widget.eventDetails.event.endDate ??
        widget.eventDetails.event.startDate.add(const Duration(hours: 4));
  }
}
