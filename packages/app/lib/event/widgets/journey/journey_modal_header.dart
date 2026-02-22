/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_event.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';

enum JourneyModalAction { update, delete }

class JourneyModalHeader extends StatelessWidget {
  final void Function() onViewOnMap;
  final Event event;
  final bool canEditJourney;

  const JourneyModalHeader({
    super.key,
    required this.onViewOnMap,
    required this.event,
    required this.canEditJourney,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) {
        if (state is EventJourneyCreationSuccess) {
          _returnToDetails(context);
        }
      },
      child: _buildHeader(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (canEditJourney)
          _buildEditMenu(context, scheme),
        const Spacer(),
        _buildMapButton(context, scheme),
      ],
    );
  }

  Widget _buildEditMenu(BuildContext context, ColorScheme scheme) {
    return PopupMenuButton<JourneyModalAction>(
      onSelected: (action) => _onActionsSelected(context, action),
      icon: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 16,
          color: scheme.onPrimary.withValues(alpha: 0.65),
        ),
      ),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: JourneyModalAction.update,
              child: UploadJourneyMenu(
                event: event,
                onSelection: (type) => _onUpdateJourney(context, type),
                child: Row(
                  children: [
                    Icon(Icons.swap_calls_rounded, size: 18, color: scheme.onPrimary),
                    const SizedBox(width: 8),
                    Text('Changer de parcours'),
                  ],
                ),
              ),
            ),
            PopupMenuItem(
              value: JourneyModalAction.delete,
              child: Row(
                children: [
                  Icon(Icons.remove_circle_outline_rounded, size: 18, color: scheme.error),
                  const SizedBox(width: 8),
                  Text('Retirer le parcours', style: TextStyle(color: scheme.error)),
                ],
              ),
            ),
          ],
    );
  }

  Widget _buildMapButton(BuildContext context, ColorScheme scheme) {
    return GestureDetector(
      onTap: () => _onOpenMap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: scheme.secondary.withValues(alpha: 0.15),
          border: Border.all(
            color: scheme.secondary.withValues(alpha: 0.40),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 14, color: scheme.secondary),
            const SizedBox(width: 6),
            Text(
              'Voir sur la carte',
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 12,
                fontVariations: const [FontVariation.weight(650)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onUpdateJourney(BuildContext context, NewJourneyType type) async {
    await Navigator.of(context).maybePop();
    if (context.mounted) {
      journeyImportModalFromType(
        context,
        type,
        event,
        selected: () {
          _returnToDetails(context);
        },
      );
    }
  }

  void _onDeleteJourney(BuildContext context) {
    _returnToDetails(context);
    context.read<EventJourneyBloc>().add(
      RemoveJourneyFromEvent(eventId: event.id),
    );
  }

  void _onActionsSelected(BuildContext context, JourneyModalAction action) {
    if (action == JourneyModalAction.delete) {
      _onDeleteJourney(context);
    }
  }

  void _onOpenMap(BuildContext context) {
    _returnToDetails(context);
    Timer(const Duration(milliseconds: 200), () {
      onViewOnMap();
    });
  }

  void _returnToDetails(BuildContext context) {
    Timer(const Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
  }
}
