/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/slivers/glass_sliver_headers.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/dates.dart';
import '../../types/minimal_event.dart';
import '../event_preview_card/event_preview_card.dart';

// Height of the visible TopBar content (see shared/widgets/bar/top_bar.dart).
const _kTopBarContentHeight = 5;
const _kMonthHeaderHeight = 52.0;

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
  final double extraBottomPadding;

  const EventsSectionsList({
    super.key,
    required this.events,
    required this.hasMore,
    this.controller,
    this.prioritizeUpcomingFirst = false,
    this.extraBottomPadding = 0,
    this.physics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
  });

  @override
  State<EventsSectionsList> createState() => _EventsSectionsListState();
}

class _EventsSectionsListState extends State<EventsSectionsList> {
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
    final totalBottomPadding = bottomPadding + widget.extraBottomPadding;

    return CustomScrollView(
      controller: widget.controller,
      physics: widget.physics,
      slivers: [
        // ── Phantom header ────────────────────────────────────────────────
        // Transparent, pinned — reserves the top-bar area so section headers
        // cannot creep behind the glass pill.
        SliverPersistentHeader(
          pinned: true,
          delegate: PinnedSpacerHeaderDelegate(height: topInset),
        ),

        // ── Month sections ────────────────────────────────────────────────
        ...sections.map(
          (section) => SliverMainAxisGroup(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: GlassSectionHeaderDelegate(
                  title: section.title,
                  colorScheme: scheme,
                  height: _kMonthHeaderHeight,
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

        SliverToBoxAdapter(child: SizedBox(height: totalBottomPadding)),
      ],
    );
  }

  List<EventSection> getEventSections(List<MinimalEvent> events) {
    final sortedEvents = events;

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
