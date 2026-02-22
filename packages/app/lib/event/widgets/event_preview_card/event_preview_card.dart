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
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 166,
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => widget.onTap(_uniqueKey),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 126,
                        child: _buildMediaPane(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailsPane(context, scheme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsPane(BuildContext context, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        _buildMetaRow(context, scheme),
        const SizedBox(height: 8),
        if (_animate)
          Hero(
            tag: 'event-name-$_uniqueKey',
            child: _buildTitle(context, scheme),
          ),
        if (!_animate) _buildTitle(context, scheme),
        const SizedBox(height: 8),
        _buildStatusRow(scheme),
        const SizedBox(height: 10),
        _buildStatsRow(scheme),
        const Spacer(),
      ],
    );
  }

  Widget _buildMediaPane(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final image =
        _animate
            ? Hero(
              tag: 'event-image-$_uniqueKey',
              child: _buildImage(),
            )
            : _buildImage();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.48),
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            child: _buildDateBadge(context),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.secondary.withValues(alpha: 0.8),
              ),
              child: Icon(
                Icons.arrow_outward_rounded,
                color: scheme.surface,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ColorScheme scheme) {
    return Text(
      widget.event.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: scheme.onPrimary,
        fontVariations: const [FontVariation.weight(700)],
        fontSize: 15,
        height: 1.15,
        shadows: const [
          Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildStatusRow(ColorScheme scheme) {
    final style = TextStyle(
      color: scheme.onPrimary.withValues(alpha: 0.8),
      fontSize: 12,
      fontVariations: const [FontVariation.weight(500)],
    );

    return EventStatusIndicator(
      event: widget.event,
      separatorWidth: 5,
      statusTextBuilder: (status) {
        switch (status) {
          case EventStatusState.canceled:
            return Text('Annulé', style: style);
          case EventStatusState.pending:
            return Text('En attente', style: style);
          case EventStatusState.now:
            return Text('En cours', style: style);
          case EventStatusState.finished:
            return Text('Terminé', style: style);
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
    final date = widget.event.startDate;
    final day = getMinimalDay(date);
    final dayNum = date.day.toString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontVariations: [FontVariation.weight(700)],
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                dayNum,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
      errorBuilder:
          (context, error, stackTrace) => ColoredBox(
            color: Colors.black.withValues(alpha: 0.25),
            child: const Center(
              child: Icon(Icons.photo, color: Colors.white70, size: 20),
            ),
          ),
    );
  }

  Widget _buildMetaRow(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        _buildChip(
          icon: Icons.schedule_rounded,
          text: _getTimeLabel(),
          color: scheme.onPrimary.withValues(alpha: 0.72),
        ),
        const SizedBox(width: 6),
        BlocBuilder<MyPositionBloc, MyPositionState>(
          builder: (context, posState) {
            if (widget.event.id != posState.eventId) {
              return const SizedBox.shrink();
            }
            return _buildChip(
              icon: Icons.location_on_rounded,
              text: 'En direct',
              color: scheme.secondary,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatsRow(ColorScheme scheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Budget',
            value: _formatBudget(widget.event.budget),
            scheme: scheme,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildStatItem(
            icon: Icons.route_rounded,
            label: 'Distance',
            value: _formatDistance(widget.event.distance),
            scheme: scheme,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildStatItem(
            icon: Icons.people_alt_rounded,
            label: 'Participants',
            value: widget.event.participantsCount.toString(),
            scheme: scheme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme scheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: scheme.onPrimary.withValues(alpha: 0.08),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 11, color: scheme.onPrimary.withValues(alpha: 0.7)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.7),
                    fontSize: 9,
                    fontVariations: const [FontVariation.weight(550)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 12,
              fontVariations: const [FontVariation.weight(700)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: color.withValues(alpha: 0.2),
            border: Border.all(
              color: color.withValues(alpha: 0.24),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontVariations: const [FontVariation.weight(650)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeLabel() {
    final date = widget.event.startDate;
    final hours = date.hour.toString().padLeft(2, '0');
    final minutes = date.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  String _formatBudget(int? budget) {
    if (budget == null) {
      return '—';
    }
    return '$budget €';
  }

  String _formatDistance(int? distance) {
    if (distance == null) {
      return '—';
    }
    if (distance >= 1000) {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
    return '$distance m';
  }

  String _getUniqueKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
