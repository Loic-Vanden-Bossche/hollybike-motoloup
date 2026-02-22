/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/dates.dart';
import '../../types/minimal_event.dart';
import '../../types/event_status_state.dart';
import '../event_preview_card/event_preview_card.dart';

// Height of the visible TopBar content (see shared/widgets/bar/top_bar.dart).
const _kTopBarContentHeight = 5;
const _kMonthHeaderMinHeight = 44.0;
const _kMonthHeaderMaxHeight = 52.0;

class EventSection {
  String title;
  List<MinimalEvent> events;

  EventSection({required this.title, required this.events});
}

class EventsSectionsList extends StatefulWidget {
  final List<MinimalEvent> events;
  final bool hasMore;
  final ScrollController? controller;
  final ScrollPhysics physics;
  final bool prioritizeUpcomingFirst;

  const EventsSectionsList({
    super.key,
    required this.events,
    required this.hasMore,
    this.controller,
    this.prioritizeUpcomingFirst = false,
    this.physics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
  });

  @override
  State<EventsSectionsList> createState() => _EventsSectionsListState();
}

class _EventsSectionsListState extends State<EventsSectionsList> {
  bool _hasScrolled = false;

  @override
  Widget build(BuildContext context) {
    final sections = getEventSections(widget.events);
    final scheme = Theme.of(context).colorScheme;

    // Transparent phantom sliver occupies the top-bar area.
    // It is pinned at y=0 so section headers stack just below it instead of
    // behind the glass pill.  Event cards scroll freely through this area and
    // are blurred by the AppBar's BackdropFilter.
    final topInset = MediaQuery.of(context).padding.top + _kTopBarContentHeight;

    // With Scaffold.extendBody: true, MediaQuery.padding.bottom inside the body
    // includes the floating BottomBar height.
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        final hasScrolledNow = notification.metrics.pixels > 0;
        if (hasScrolledNow != _hasScrolled) {
          setState(() => _hasScrolled = hasScrolledNow);
        }
        return false;
      },
      child: CustomScrollView(
        controller: widget.controller,
        physics: widget.physics,
        slivers: [
          // ── Phantom header ────────────────────────────────────────────────
          // Transparent, pinned — reserves the top-bar area so section headers
          // cannot creep behind the glass pill.
          SliverPersistentHeader(
            pinned: true,
            delegate: _PhantomHeaderDelegate(height: topInset),
          ),

          // ── Month sections ────────────────────────────────────────────────
          ...sections.map(
            (section) => SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _AnimatedMonthHeaderDelegate(
                    title: section.title,
                    colorScheme: scheme,
                    hasScrolled: _hasScrolled,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final event = section.events[index];

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(30 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: EventPreviewCard(
                              event: event,
                              onTap:
                                  (uniqueKey) => _navigateToEventDetails(
                                    context,
                                    event,
                                    uniqueKey,
                                  ),
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: section.events.length),
                ),
                if (widget.hasMore && section == sections.last)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
        ],
      ),
    );
  }

  List<EventSection> getEventSections(List<MinimalEvent> events) {
    final sortedEvents =
        widget.prioritizeUpcomingFirst ? _sortUpcomingFirst(events) : events;

    final sections = <EventSection>[];
    List<List<MinimalEvent>> groupedEvents = [];

    for (var i = 0; i < sortedEvents.length; i++) {
      final event = sortedEvents[i];

      if (i == 0 ||
          event.startDate.month != sortedEvents[i - 1].startDate.month) {
        groupedEvents.add([]);
      }

      groupedEvents.last.add(event);
    }

    for (var i = 0; i < groupedEvents.length; i++) {
      final events = groupedEvents[i];
      final title = getMonthWithDistantYear(events.first.startDate);

      sections.add(EventSection(title: title, events: events));
    }

    return sections;
  }

  List<MinimalEvent> _sortUpcomingFirst(List<MinimalEvent> events) {
    final now = DateTime.now();
    final upcoming = <MinimalEvent>[];
    final past = <MinimalEvent>[];

    for (final event in events) {
      if (_isUpcoming(event, now)) {
        upcoming.add(event);
      } else {
        past.add(event);
      }
    }

    past.sort((a, b) => _pastSortDate(b).compareTo(_pastSortDate(a)));

    return [...upcoming, ...past];
  }

  bool _isUpcoming(MinimalEvent event, DateTime now) {
    if (event.status == EventStatusState.finished ||
        event.status == EventStatusState.canceled) {
      return false;
    }

    if (event.status == EventStatusState.now) {
      return true;
    }

    return !event.startDate.isBefore(now);
  }

  DateTime _pastSortDate(MinimalEvent event) {
    return event.endDate ?? event.startDate;
  }

  void _navigateToEventDetails(
    BuildContext context,
    MinimalEvent event,
    String uniqueKey,
  ) {
    context.router.push(
      EventDetailsRoute(event: event, animate: true, uniqueKey: uniqueKey),
    );
  }
}

class _AnimatedMonthHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final ColorScheme colorScheme;
  final bool hasScrolled;

  const _AnimatedMonthHeaderDelegate({
    required this.title,
    required this.colorScheme,
    required this.hasScrolled,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final target = hasScrolled ? 1.0 : 0.0;

    return SizedBox.expand(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) {
          final horizontalMargin = lerpDouble(0, 16, t)!;
          final verticalMargin = lerpDouble(0, 4, t)!;
          final radius = lerpDouble(0, 50, t)!;
          final blur = lerpDouble(0, 20, t)!;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: colorScheme.primary.withValues(alpha: 0.6 * t),
                    border: Border.all(
                      color: colorScheme.onPrimary.withValues(alpha: 0.1 * t),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: colorScheme.secondary,
                        ),
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          letterSpacing: 0.3,
                          color: colorScheme.onPrimary.withValues(
                            alpha: lerpDouble(0.65, 0.75, t)!,
                          ),
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
    );
  }

  @override
  double get maxExtent => _kMonthHeaderMaxHeight;

  @override
  double get minExtent => _kMonthHeaderMinHeight;

  @override
  bool shouldRebuild(covariant _AnimatedMonthHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.colorScheme != colorScheme ||
        oldDelegate.hasScrolled != hasScrolled;
  }
}

// Invisible pinned sliver that reserves the top-bar area.
// Section headers stack below it; event cards render through it
// and get blurred by the AppBar's BackdropFilter.
class _PhantomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;

  const _PhantomHeaderDelegate({required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox(height: height, width: double.infinity);

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _PhantomHeaderDelegate old) =>
      old.height != height;
}
