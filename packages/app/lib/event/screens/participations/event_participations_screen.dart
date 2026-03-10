/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_bloc.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_event.dart';
import 'package:hollybike/event/bloc/event_participations_bloc/event_participations_state.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/ui/widgets/buttons/glass_fab.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/bar/top_bar.dart';
import '../../../shared/widgets/bar/top_bar_title.dart';
import '../../../shared/widgets/loaders/themed_refresh_indicator.dart';
import '../../services/event/event_repository.dart';
import '../../services/participation/event_participation_repository.dart';
import '../../types/participation/event_participation.dart';
import '../../widgets/participations/event_participation_card.dart';
import 'package:lottie/lottie.dart';

const _kTopBarContentHeight = 46.0;

@RoutePage()
class EventParticipationsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final EventDetails eventDetails;
  final List<EventParticipation> participationPreview;
  final EventDetailsBloc? eventDetailsBloc;

  const EventParticipationsScreen({
    super.key,
    required this.eventDetails,
    required this.participationPreview,
    this.eventDetailsBloc,
  });

  @override
  State<EventParticipationsScreen> createState() =>
      _EventParticipationsScreenState();

  @override
  Widget wrappedRoute(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventParticipationBloc>(
          create:
              (context) => EventParticipationBloc(
                eventId: eventDetails.event.id,
                eventParticipationsRepository:
                    RepositoryProvider.of<EventParticipationRepository>(
                      context,
                    ),
                eventRepository: RepositoryProvider.of<EventRepository>(
                  context,
                ),
              )..add(SubscribeToEventParticipations()),
        ),
        if (eventDetailsBloc != null)
          BlocProvider<EventDetailsBloc>.value(value: eventDetailsBloc!),
      ],
      child: this,
    );
  }
}

class _EventParticipationsScreenState extends State<EventParticipationsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _refreshParticipants();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top + _kTopBarContentHeight;

    return BlocListener<EventParticipationBloc, EventParticipationsState>(
      listener: (context, state) {
        if (state is EventParticipationsPageLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventParticipationsDeletionFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventParticipationsOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EventParticipationsOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        } else if (state is EventParticipationsDeleted) {
          Toast.showSuccessToast(context, "Participant retiré");
          // _refreshParticipants();
        }
      },
      child: Hud(
        appBar: TopBar(
          prefix: TopBarActionIcon(
            onPressed: () => context.router.maybePop(),
            icon: Icons.arrow_back,
          ),
          title: const TopBarTitle("Participants de l'événement"),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            if (!widget.eventDetails.isOrganizer) {
              return const SizedBox();
            }

            return GlassFab(
              icon: Icons.group_add_rounded,
              label: 'Ajouter',
              onPressed: () {
                context.router.push(
                  EventCandidatesRoute(eventId: widget.eventDetails.event.id),
                );
              },
            );
          },
        ),
        body: ThemedRefreshIndicator(
          onRefresh: () => _refreshParticipants(),
          child: BlocBuilder<EventParticipationBloc, EventParticipationsState>(
            builder: (context, state) {
              final isLoading =
                  state is EventParticipationsPageLoadInProgress &&
                  (state.participants.length ==
                          widget.participationPreview.length ||
                      state.hasMore);

              if (state is EventParticipationsPageLoadFailure) {
                return _buildErrorState(state.errorMessage);
              }

              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: topInset + 25)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: _ParticipantsSummary(
                        totalCount: state.participants.length,
                        isOrganizer: widget.eventDetails.isOrganizer,
                        eventName: widget.eventDetails.event.name,
                      ),
                    ),
                  ),
                  if (state.participants.isEmpty && !isLoading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final participantsChildCount =
                                state.participants.isEmpty
                                    ? 0
                                    : (state.participants.length * 2) - 1;
                            final loadingIndex =
                                isLoading ? participantsChildCount : -1;

                            if (isLoading && index == loadingIndex) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (index.isOdd) {
                              return const SizedBox(height: 8);
                            }

                            final participation =
                                state.participants[index ~/ 2];

                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              builder: (context, double value, child) {
                                return Transform.translate(
                                  offset: Offset(18 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: EventParticipationCard(
                                      eventId: widget.eventDetails.event.id,
                                      participation: participation,
                                      isOwner:
                                          widget.eventDetails.event.owner.id ==
                                          participation.user.id,
                                      isCurrentUser:
                                          participation.user.id ==
                                          widget
                                              .eventDetails
                                              .callerParticipation
                                              ?.userId,
                                      isCurrentUserOrganizer:
                                          widget.eventDetails.isOrganizer,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: _listChildCount(
                            state.participants.length,
                            isLoading,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110,
              child: Lottie.asset(
                'assets/lottie/lottie_calendar_placeholder.json',
                repeat: false,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun participant trouvé',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.88),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.eventDetails.isOrganizer
                  ? 'Invitez des membres pour commencer à constituer votre groupe.'
                  : 'Cette liste se remplira lorsque de nouveaux membres rejoindront la sortie.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.62),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: scheme.error.withValues(alpha: 0.12),
            border: Border.all(
              color: scheme.error.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: scheme.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorMessage,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: scheme.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadNextPage() {
    context.read<EventParticipationBloc>().add(
      LoadEventParticipationsNextPage(),
    );
  }

  Future<void> _refreshParticipants() {
    context.read<EventParticipationBloc>().add(
      RefreshEventParticipations(
        participationPreview: widget.participationPreview,
      ),
    );

    return context.read<EventParticipationBloc>().firstWhenNotLoading;
  }

  int _listChildCount(int participantsCount, bool isLoading) {
    if (participantsCount == 0) {
      return isLoading ? 1 : 0;
    }

    return (participantsCount * 2) - 1 + (isLoading ? 1 : 0);
  }
}

class _ParticipantsSummary extends StatelessWidget {
  final int totalCount;
  final bool isOrganizer;
  final String eventName;

  const _ParticipantsSummary({
    required this.totalCount,
    required this.isOrganizer,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.secondary.withValues(alpha: 0.14),
            scheme.primary.withValues(alpha: 0.46),
          ],
        ),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.onPrimary.withValues(alpha: 0.1),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.groups_rounded,
              color: scheme.secondary,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$totalCount participant${totalCount > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          if (isOrganizer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: scheme.secondary.withValues(alpha: 0.17),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Text(
                'Gestion',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.secondary,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
