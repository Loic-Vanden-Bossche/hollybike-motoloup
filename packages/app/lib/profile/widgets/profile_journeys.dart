/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/events_list/events_list_placeholder.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_event.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_state.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:hollybike/user_journey/widgets/user_journey_list.dart';

class ProfileJourneys extends StatefulWidget {
  final MinimalUser user;
  final bool isMe;
  final ScrollController scrollController;
  final bool isNested;
  final void Function(UserJourney)? onJourneySelected;

  const ProfileJourneys({
    super.key,
    required this.user,
    required this.isMe,
    required this.scrollController,
    this.isNested = true,
    this.onJourneySelected,
  });

  @override
  State<ProfileJourneys> createState() => _ProfileJourneysState();
}

class _ProfileJourneysState extends State<ProfileJourneys> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileJourneysBloc>().add(RefreshProfileJourneys());

    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    var nextPageTrigger =
        0.8 * widget.scrollController.position.maxScrollExtent;

    if (widget.scrollController.position.pixels > nextPageTrigger) {
      context.read<ProfileJourneysBloc>().add(LoadProfileJourneysNextPage());
    }
  }

  Future<void> _onRefresh() {
    context.read<ProfileJourneysBloc>().add(RefreshProfileJourneys());

    return context.read<ProfileJourneysBloc>().firstWhenNotLoading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileJourneysBloc, ProfileJourneysState>(
      builder: (context, state) {
        final bottomPadding = 126 + MediaQuery.paddingOf(context).bottom;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ThemedRefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildList(
              state.userJourneys,
              state.hasMore,
              state.status,
              bottomPadding,
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(
    List<UserJourney> userJourneys,
    bool hasMore,
    ProfileJourneysStatus status,
    double bottomPadding,
  ) {
    if (userJourneys.isEmpty) {
      return _buildPlaceholder(context, status);
    }

    return UserJourneyList(
      hasMore: hasMore,
      userJourneys: userJourneys,
      user: widget.user,
      isNested: widget.isNested,
      bottomPadding: bottomPadding,
      onJourneySelected: widget.onJourneySelected,
    );
  }

  Widget _buildPlaceholder(BuildContext context, ProfileJourneysStatus status) {
    switch (status) {
      case ProfileJourneysStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ProfileJourneysStatus.error:
        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.1,
          child: const Center(
            child: Text(
              'Une erreur est survenue lors du chargement des trajets, veuillez réessayer.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case ProfileJourneysStatus.success:
        final scheme = Theme.of(context).colorScheme;
        final message =
            widget.isMe
                ? "Vous n'avez terminé aucun trajet"
                : "${widget.user.username} n'a pas encore terminé de trajets";

        return ScrollablePlaceholder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: MediaQuery.of(context).size.width * 0.2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primaryContainer.withValues(alpha: 0.50),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _ProfileJourneysPlaceholderIcon(),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontVariations: const [FontVariation.weight(550)],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class _ProfileJourneysPlaceholderIcon extends StatefulWidget {
  const _ProfileJourneysPlaceholderIcon();

  @override
  State<_ProfileJourneysPlaceholderIcon> createState() =>
      _ProfileJourneysPlaceholderIconState();
}

class _ProfileJourneysPlaceholderIconState
    extends State<_ProfileJourneysPlaceholderIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary.withValues(alpha: 0.10),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.route_rounded,
            size: 30,
            color: scheme.secondary.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}
