/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/event_status.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_bloc.dart';
import 'package:hollybike/positions/bloc/my_position/my_position_state.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../../shared/utils/dates.dart';
import '../../types/event_status_state.dart';

class EventPreviewCard extends StatefulWidget {
  final MinimalEvent event;
  final void Function(String uniqueKey) onTap;

  const EventPreviewCard({super.key, required this.event, required this.onTap});

  @override
  State<EventPreviewCard> createState() => _EventPreviewCardState();
}

class _EventPreviewCardState extends State<EventPreviewCard> {
  late String _uniqueKey;
  bool _animate = true;

  @override
  void initState() {
    super.initState();
    _uniqueKey = _getUniqueKey();
  }

  @override
  void didUpdateWidget(covariant EventPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id) {
      _uniqueKey = _getUniqueKey();
      _animate = false;

      Future.delayed(Duration.zero, () {
        safeSetState(() {
          _animate = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 160,
          child: Stack(
            children: [
              // Full-bleed event image
              Positioned.fill(
                child:
                    _animate
                        ? Hero(
                          tag: "event-image-$_uniqueKey",
                          child: _buildImage(),
                        )
                        : _buildImage(),
              ),
              // Gradient overlay for text readability
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.72),
                      ],
                      stops: const [0.35, 1.0],
                    ),
                  ),
                ),
              ),
              // Text overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 72, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_animate)
                        Hero(
                          tag: "event-name-$_uniqueKey",
                          child: _buildTitle(),
                        ),
                      if (!_animate) _buildTitle(),
                      const SizedBox(height: 4),
                      _buildStatusRow(),
                    ],
                  ),
                ),
              ),
              // Date badge — top right
              Positioned(
                top: 10,
                right: 12,
                child: _buildDateBadge(context),
              ),
              // Live location badge — top left
              BlocBuilder<MyPositionBloc, MyPositionState>(
                builder: (context, posState) {
                  if (widget.event.id != posState.eventId) {
                    return const SizedBox.shrink();
                  }
                  return Positioned(
                    top: 10,
                    left: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: scheme.secondary.withValues(alpha: 0.85),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: scheme.surface,
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "En direct",
                                style: TextStyle(
                                  color: scheme.surface,
                                  fontSize: 10,
                                  fontVariations: const [
                                    FontVariation.weight(700),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Tap gesture
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => widget.onTap(_uniqueKey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.event.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontVariations: [FontVariation.weight(700)],
        fontSize: 16,
        shadows: [
          Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    const style = TextStyle(
      color: Colors.white70,
      fontSize: 12,
      fontVariations: [FontVariation.weight(500)],
    );

    return EventStatusIndicator(
      event: widget.event,
      separatorWidth: 5,
      statusTextBuilder: (status) {
        switch (status) {
          case EventStatusState.canceled:
            return const Text("Annulé", style: style);
          case EventStatusState.pending:
            return const Text("En attente", style: style);
          case EventStatusState.now:
            return const Text("En cours", style: style);
          case EventStatusState.finished:
            return const Text("Terminé", style: style);
          case EventStatusState.scheduled:
            return Text(
              fromDateToDuration(widget.event.startDate),
              style: style,
            );
        }
      },
    );
  }

  Widget _buildDateBadge(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final date = widget.event.startDate;
    final day = getMinimalDay(date);
    final dayNum = date.day.toString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withValues(alpha: 0.35),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: scheme.secondary,
                  fontSize: 10,
                  fontVariations: const [FontVariation.weight(700)],
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                dayNum,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontVariations: [FontVariation.weight(800)],
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image(
      image: widget.event.imageProvider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  String _getUniqueKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
