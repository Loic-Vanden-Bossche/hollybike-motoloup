/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_bloc.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_event.dart';
import 'package:hollybike/event/bloc/event_candidates_bloc/event_candidates_state.dart';
import 'package:hollybike/event/widgets/candidates/event_candidate_card.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/bar/top_bar.dart';
import '../../../shared/widgets/bar/top_bar_title.dart';
import '../../../shared/widgets/hud/hud.dart';
import '../../services/event/event_repository.dart';
import '../../services/participation/event_participation_repository.dart';
import 'package:lottie/lottie.dart';

const _kTopBarContentHeight = 46.0;

@RoutePage()
class EventCandidatesScreen extends StatefulWidget implements AutoRouteWrapper {
  final int eventId;

  const EventCandidatesScreen({super.key, required this.eventId});

  @override
  State<EventCandidatesScreen> createState() => _EventCandidatesScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider<EventCandidatesBloc>(
      create:
          (context) => EventCandidatesBloc(
            eventId: eventId,
            eventParticipationsRepository:
                RepositoryProvider.of<EventParticipationRepository>(context),
            eventRepository: RepositoryProvider.of<EventRepository>(context),
          )..add(SubscribeToEventCandidates()),
      child: this,
    );
  }
}

class _EventCandidatesScreenState extends State<EventCandidatesScreen> {
  late ScrollController _scrollController;
  Timer? _searchDebounceTimer;
  String _searchQuery = "";

  final List<int> _selectedCandidates = [];

  @override
  void initState() {
    super.initState();

    _refreshCandidates();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage();
      }
    });
  }

  void _onCandidateSelected(int candidateId) {
    setState(() {
      if (_selectedCandidates.contains(candidateId)) {
        _selectedCandidates.remove(candidateId);
      } else {
        _selectedCandidates.add(candidateId);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top + _kTopBarContentHeight;

    return BlocListener<EventCandidatesBloc, EventCandidatesState>(
      listener: (context, state) {
        if (state is EventCandidatesPageLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventAddCandidatesFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventAddCandidatesSuccess) {
          Toast.showSuccessToast(context, "Participants ajoutés");
          context.router.maybePop();
        }
      },
      child: Builder(
        builder: (context) {
          Widget? floatingActionButton;

          if (_selectedCandidates.isNotEmpty) {
            floatingActionButton = FloatingActionButton.extended(
              onPressed: _addCandidates,
              label: Text(
                "Ajouter ${_selectedCandidates.length} participants",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              icon: const Icon(Icons.add),
            );
          }

          return Hud(
            appBar: TopBar(
              prefix: TopBarActionIcon(
                onPressed: () => context.router.maybePop(),
                icon: Icons.arrow_back,
              ),
              title: const TopBarTitle("Ajouter des participants"),
            ),
            floatingActionButton: floatingActionButton,
            body: BlocBuilder<EventCandidatesBloc, EventCandidatesState>(
              builder: (context, state) {
                final isLoading = state is EventCandidatesPageLoadInProgress;
                final hasInitialLoading = isLoading && state.candidates.isEmpty;

                if (state is EventCandidatesPageLoadFailure) {
                  return _buildErrorState(state.errorMessage, topInset);
                }

                return CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: topInset + 6)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: _buildSearchBox(context),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: _CandidatesSummary(
                          selectedCount: _selectedCandidates.length,
                          totalVisible: state.candidates.length,
                        ),
                      ),
                    ),
                    if (hasInitialLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.candidates.isEmpty)
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
                              final candidatesChildCount =
                                  state.candidates.isEmpty
                                      ? 0
                                      : (state.candidates.length * 2) - 1;
                              final loadingIndex =
                                  state.hasMore ? candidatesChildCount : -1;

                              if (state.hasMore && index == loadingIndex) {
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

                              final candidate = state.candidates[index ~/ 2];

                              return EventCandidateCard(
                                candidate: candidate,
                                alreadyParticipating:
                                    candidate.eventRole != null,
                                isSelected:
                                    _selectedCandidates.contains(
                                      candidate.id,
                                    ) ||
                                    candidate.eventRole != null,
                                onTap: () => _onCandidateSelected(candidate.id),
                              );
                            },
                            childCount: _candidateListChildCount(
                              state.candidates.length,
                              state.hasMore,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.primaryContainer.withValues(alpha: 0.58),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: scheme.onPrimary.withValues(alpha: 0.6),
          ),
          hintText: "Rechercher un utilisateur",
          hintStyle: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.45)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 14,
          ),
        ),
        onChanged: _onSearchCandidates,
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
              height: 100,
              child: Lottie.asset(
                'assets/lottie/lottie_calendar_placeholder.json',
                repeat: false,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty
                  ? "Tous les utilisateurs sont déjà inscrits"
                  : "Aucun utilisateur trouvé",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.86),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isEmpty
                  ? "Aucun candidat supplémentaire disponible pour cet événement."
                  : "Essayez un autre terme de recherche.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, double topInset) {
    final scheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: topInset + 32)),
        SliverToBoxAdapter(
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
        ),
      ],
    );
  }

  void _addCandidates() {
    context.read<EventCandidatesBloc>().add(
      AddCandidates(eventId: widget.eventId, userIds: _selectedCandidates),
    );
  }

  void _onSearchCandidates(String query) {
    setState(() {
      _searchQuery = query;
    });
    if (_searchDebounceTimer?.isActive ?? false) _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchCandidates(query);
    });
  }

  void _refreshCandidates() {
    context.read<EventCandidatesBloc>().add(
      RefreshEventCandidates(eventId: widget.eventId),
    );
  }

  void _loadNextPage() {
    context.read<EventCandidatesBloc>().add(
      LoadEventCandidatesNextPage(eventId: widget.eventId),
    );
  }

  void _searchCandidates(String query) {
    context.read<EventCandidatesBloc>().add(
      SearchCandidates(eventId: widget.eventId, search: query),
    );
  }

  int _candidateListChildCount(int candidatesCount, bool hasMore) {
    if (candidatesCount == 0) {
      return hasMore ? 1 : 0;
    }

    return (candidatesCount * 2) - 1 + (hasMore ? 1 : 0);
  }
}

class _CandidatesSummary extends StatelessWidget {
  final int selectedCount;
  final int totalVisible;

  const _CandidatesSummary({
    required this.selectedCount,
    required this.totalVisible,
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
              Icons.person_add_alt_1_rounded,
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
                  '$totalVisible candidat${totalVisible > 1 ? 's' : ''} visible${totalVisible > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  selectedCount == 0
                      ? 'Sélectionnez des utilisateurs à ajouter.'
                      : '$selectedCount sélectionné${selectedCount > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        selectedCount == 0
                            ? scheme.onPrimary.withValues(alpha: 0.62)
                            : scheme.secondary,
                    fontVariations:
                        selectedCount == 0
                            ? null
                            : const [FontVariation.weight(700)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
