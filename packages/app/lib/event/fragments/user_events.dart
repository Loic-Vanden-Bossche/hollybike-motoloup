/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Lo�c Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/user_events_bloc.dart';

import '../bloc/events_bloc/events_event.dart';
import '../services/event/event_repository.dart';
import 'events_list_fragment.dart';

class UserEvents extends StatelessWidget {
  final VoidCallback? onShowGlobalEventsRequested;

  const UserEvents({super.key, this.onShowGlobalEventsRequested});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserEventsBloc>(
      create:
          (context) => UserEventsBloc(
            eventRepository: RepositoryProvider.of<EventRepository>(context),
          )..add(SubscribeToEvents()),
      child: Builder(
        builder: (context) {
          return EventsListFragment<UserEventsBloc>(
            onNextPageRequested: () => _loadNextPage(context),
            onRefreshRequested: () => _refreshEvents(context),
            placeholderText: 'Vous ne participez à aucun évènement',
            emptyActionLabel: 'Voir les évènements',
            onEmptyActionPressed: onShowGlobalEventsRequested,
          );
        },
      ),
    );
  }

  void _loadNextPage(BuildContext context) {
    context.read<UserEventsBloc>().add(LoadEventsNextPage());
  }

  Future<void> _refreshEvents(BuildContext context) {
    context.read<UserEventsBloc>().add(RefreshUserEvents());

    return context.read<UserEventsBloc>().firstWhenNotLoading;
  }
}
