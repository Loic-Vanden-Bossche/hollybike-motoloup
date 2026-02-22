/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Lo�c Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/events_bloc/events_state.dart';
import '../bloc/events_bloc/future_events_bloc.dart';
import '../widgets/events_list/events_list.dart';

const _kTopBarContentHeight = 46.0;

class EventsListFragment<T extends EventsBloc> extends StatefulWidget {
  final void Function() onNextPageRequested;
  final Future<void> Function() onRefreshRequested;
  final String placeholderText;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyActionPressed;
  final bool prioritizeUpcomingFirst;

  const EventsListFragment({
    super.key,
    required this.onNextPageRequested,
    required this.onRefreshRequested,
    required this.placeholderText,
    this.emptyActionLabel,
    this.onEmptyActionPressed,
    this.prioritizeUpcomingFirst = false,
  });

  @override
  State<EventsListFragment> createState() => _EventsListFragmentState<T>();
}

class _EventsListFragmentState<T extends EventsBloc>
    extends State<EventsListFragment> {
  @override
  void initState() {
    super.initState();

    widget.onRefreshRequested();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top + _kTopBarContentHeight;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthConnected) {
              widget.onRefreshRequested();
            }
          },
        ),
        BlocListener<FutureEventsBloc, EventsState>(
          listener: (context, state) {
            if (state is EventCreationSuccess) {
              Future.delayed(
                const Duration(milliseconds: 200),
                widget.onRefreshRequested,
              );
            }
          },
        ),
      ],
      child: ThemedRefreshIndicator(
        onRefresh: widget.onRefreshRequested,
        edgeOffset: topInset,
        displacement: topInset + 28,
        child: BlocBuilder<T, EventsState>(
          builder: (context, state) {
            final isListVisible = state.events.isNotEmpty;
            final viewKey =
                isListVisible ? 'list' : 'placeholder-${state.status.name}';
            final view =
                isListVisible
                    ? EventsList(
                      hasMore: state.hasMore,
                      events: state.events,
                      onNextPageRequested: widget.onNextPageRequested,
                      onRefreshRequested: widget.onRefreshRequested,
                      prioritizeUpcomingFirst: widget.prioritizeUpcomingFirst,
                    )
                    : _buildPlaceholder(context, state);

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder:
                  (currentChild, previousChildren) => Stack(
                    fit: StackFit.expand,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child: KeyedSubtree(key: ValueKey(viewKey), child: view),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, EventsState state) {
    switch (state.status) {
      case EventStatus.loading:
        return ScrollablePlaceholder(
          padding: MediaQuery.of(context).size.width * 0.2,
          child: const Center(child: CircularProgressIndicator()),
        );
      case EventStatus.error:
        return ScrollablePlaceholder(
          padding: MediaQuery.of(context).size.width * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                fit: BoxFit.cover,
                'assets/lottie/lottie_calendar_error_animation.json',
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                'Une erreur est survenue lors du chargement des évènements',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case EventStatus.success:
        return ScrollablePlaceholder(
          padding: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                fit: BoxFit.cover,
                'assets/lottie/lottie_calendar_placeholder.json',
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                widget.placeholderText,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (widget.emptyActionLabel != null &&
                  widget.onEmptyActionPressed != null) ...[
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: widget.onEmptyActionPressed,
                  icon: const Icon(Icons.event_rounded, size: 16),
                  label: Text(widget.emptyActionLabel!),
                ),
              ],
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
