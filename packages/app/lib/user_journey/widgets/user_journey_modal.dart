/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/services/event/event_repository.dart';
import 'package:hollybike/event/services/participation/event_participation_repository.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';
import 'package:hollybike/shared/widgets/gradient_progress_bar.dart';
import 'package:hollybike/ui/widgets/menu/glass_popup_menu.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_bloc.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_event.dart';
import 'package:hollybike/user_journey/bloc/user_journey_details_state.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../event/bloc/event_details_bloc/event_details_bloc.dart';
import '../../shared/utils/dates.dart';

enum JourneyModalAction { resetJourney, deleteJourney, downloadJourney }

class UserJourneyModal extends StatefulWidget {
  final UserJourney journey;
  final bool isCurrentEvent;
  final int? stepId;
  final MinimalUser? user;
  final void Function()? onDeleted;

  const UserJourneyModal({
    super.key,
    required this.journey,
    required this.isCurrentEvent,
    this.stepId,
    this.user,
    this.onDeleted,
  });

  @override
  State<UserJourneyModal> createState() => _UserJourneyModalState();
}

class _UserJourneyModalState extends State<UserJourneyModal> {
  late final double _betterPercentage;
  bool _isSolo = false;
  int _betterThanCount = 0;
  bool _hasBetterThan = false;

  @override
  void initState() {
    super.initState();
    final isBetterThan = widget.journey.isBetterThan;

    if (isBetterThan == null) {
      _betterPercentage = 0.0;
      return;
    }

    _hasBetterThan = true;

    if (isBetterThan.isEmpty) {
      _isSolo = true;
      _betterPercentage = 0.0;
      return;
    }

    _betterPercentage =
        isBetterThan.entries.fold(0.0, (acc, entry) => acc + entry.value) /
        isBetterThan.length;

    _betterThanCount =
        isBetterThan.values.where((element) => element == 100).length;
  }

  Widget _eventBlocNullable(
    BuildContext context,
    Widget Function(BuildContext, bool isLoading) builder,
  ) {
    final eventDetailsBloc = _readOrNull<EventDetailsBloc>(context);

    if (eventDetailsBloc == null) {
      return builder(context, false);
    }

    return BlocConsumer(
      bloc: eventDetailsBloc,
      listener: (context, state) {
        if (state is UserJourneyReset) {
          Navigator.of(context).pop();
          Toast.showSuccessToast(context, 'Parcours réinitialisé');
        }
      },
      builder: (context, state) {
        return builder(context, state is EventOperationInProgress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => UserJourneyDetailsBloc(
            userJourneyRepository: RepositoryProvider.of<UserJourneyRepository>(
              context,
            ),
            eventParticipationRepository:
                RepositoryProvider.of<EventParticipationRepository>(context),
            eventRepository: RepositoryProvider.of<EventRepository>(context),
            journeyId: widget.journey.id,
          ),
      child: _eventBlocNullable(context, (context, isEventLoading) {
        return BlocConsumer<UserJourneyDetailsBloc, UserJourneyDetailsState>(
          listener: (context, state) {
            if (state is UserJourneyDeleted) {
              widget.onDeleted?.call();
              Navigator.of(context).pop();
              Toast.showSuccessToast(context, 'Parcours supprimé');
            }

            if (state is UserJourneyOperationSuccess) {
              Toast.showSuccessToast(context, state.successMessage);
            }

            if (state is UserJourneyOperationFailure) {
              Toast.showErrorToast(context, state.errorMessage);
            }
          },
          builder: (context, userJourneyState) {
            final isLoading =
                userJourneyState is UserJourneyOperationInProgress ||
                isEventLoading;

            return _buildContent(isLoading);
          },
        );
      }),
    );
  }

  Widget _buildContent(bool isLoading) {
    return GlassBottomModal(
      maxContentHeight: 640,
      contentPadding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, _) {
          final currentProfileEvent = bloc.currentProfile;
          final currentUserId =
              (currentProfileEvent is ProfileLoadSuccessEvent
                  ? currentProfileEvent.profile.id
                  : null);
          final isCurrentUser =
              widget.user?.id == null || (currentUserId == widget.user?.id);

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, isCurrentUser, isLoading),
              const SizedBox(height: 14),
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _JourneyHeroCard(
                      journey: widget.journey,
                      subtitle:
                          "Parcours terminé ${formatTimeDate(widget.journey.createdAt.toLocal())}",
                    ),
                    const SizedBox(height: 12),
                    if (_hasBetterThan)
                      _JourneyGamificationCard(
                        isSolo: _isSolo,
                        percentage: _betterPercentage,
                        betterCount: _betterThanCount,
                        title:
                            isCurrentUser
                                ? 'Votre score de rider'
                                : 'Score de ${widget.user?.username}',
                        summaryText:
                            _isSolo
                                ? _getIsBetterThanMeanSoloText(isCurrentUser)
                                : "${_getIsBetterMeanText(isCurrentUser)} ${_betterPercentage.round()}%",
                        bestText:
                            _betterThanCount > 0
                                ? _getIsBetterThanCountText(isCurrentUser)
                                : null,
                      ),
                    if (_hasBetterThan) const SizedBox(height: 12),
                    _JourneyStatGrid(
                      cards: [
                        _JourneyStatCardData(
                          title: 'Dénivelé',
                          icon: Icons.landscape_rounded,
                          lines: [
                            _JourneyStatLineData(
                              icon: Icons.north_east_rounded,
                              label: 'Gain',
                              value:
                                  '${widget.journey.totalElevationGain?.round() ?? 0} m',
                              score: getBetterThan('total_elevation_gain'),
                            ),
                            _JourneyStatLineData(
                              icon: Icons.south_east_rounded,
                              label: 'Perte',
                              value:
                                  '${widget.journey.totalElevationLoss?.round() ?? 0} m',
                              score: getBetterThan('total_elevation_loss'),
                            ),
                          ],
                        ),
                        _JourneyStatCardData(
                          title: 'Vitesse',
                          icon: Icons.speed_rounded,
                          lines: [
                            _JourneyStatLineData(
                              icon: Icons.bolt_rounded,
                              label: 'Max',
                              value: widget.journey.maxSpeedLabel,
                              score: getBetterThan('max_speed'),
                            ),
                            _JourneyStatLineData(
                              icon: Icons.timelapse_rounded,
                              label: 'Moy',
                              value: widget.journey.avgSpeedLabel,
                              score: getBetterThan('avg_speed'),
                            ),
                          ],
                        ),
                        _JourneyStatCardData(
                          title: 'Altitude',
                          icon: Icons.terrain_rounded,
                          lines: [
                            _JourneyStatLineData(
                              icon: Icons.vertical_align_bottom_rounded,
                              label: 'Min',
                              value:
                                  '${widget.journey.minElevation?.round() ?? 0} m',
                              score: getBetterThan('min_elevation'),
                            ),
                            _JourneyStatLineData(
                              icon: Icons.vertical_align_top_rounded,
                              label: 'Max',
                              value:
                                  '${widget.journey.maxElevation?.round() ?? 0} m',
                              score: getBetterThan('max_elevation'),
                            ),
                          ],
                        ),
                        _JourneyStatCardData(
                          title: 'Accélération',
                          icon: Icons.gps_fixed_rounded,
                          lines: [
                            _JourneyStatLineData(
                              icon: Icons.rocket_launch_rounded,
                              label: 'Max',
                              value: widget.journey.maxGForceLabel,
                              score: getBetterThan('max_g_force'),
                            ),
                            _JourneyStatLineData(
                              icon: Icons.stacked_line_chart_rounded,
                              label: 'Moy',
                              value: widget.journey.avgGForceLabel,
                              score: getBetterThan('avg_g_force'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double? getBetterThan(String key) {
    if (widget.journey.isBetterThan?.containsKey(key) == true) {
      return widget.journey.isBetterThan![key];
    }
    return null;
  }

  String _getIsBetterThanCountText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Top dans $_betterThanCount catégories';
    } else {
      return '${widget.user?.username} domine $_betterThanCount catégories';
    }
  }

  String _getIsBetterThanMeanSoloText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Vous êtes le/la seul·e à avoir terminé ce parcours';
    } else {
      return '${widget.user?.username} est le/la seul·e à avoir terminé ce parcours';
    }
  }

  String _getIsBetterMeanText(bool isCurrentUser) {
    if (isCurrentUser) {
      return 'Votre performance globale';
    } else {
      return 'Performance globale de ${widget.user?.username}';
    }
  }

  Widget _buildHeader(
    BuildContext context,
    bool isCurrentUser,
    bool isLoading,
  ) {
    return isCurrentUser
        ? _buildCurrentUserHeader(context, isLoading)
        : _buildOtherUserHeader(context);
  }

  Widget _buildCurrentUserHeader(BuildContext context, bool isLoading) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildActionButton(context, isLoading),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: scheme.onPrimary.withValues(alpha: 0.08),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.12),
              ),
            ),
            child: Text(
              _getTitle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.78),
                fontSize: 12,
                fontVariations: const [FontVariation.weight(620)],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _buildMapButton(context, scheme),
      ],
    );
  }

  Widget _buildOtherUserHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
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
              Icons.close_rounded,
              size: 16,
              color: scheme.onPrimary.withValues(alpha: 0.65),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Parcours de ${widget.user?.username}',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 16,
              fontVariations: const [FontVariation.weight(700)],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        _buildMapButton(context, scheme),
      ],
    );
  }

  Widget _buildMapButton(BuildContext context, ColorScheme scheme) {
    return GestureDetector(
      onTap:
          () => context.router.push(
            UserJourneyMapRoute(
              fileUrl: widget.journey.file,
              title: _getTitle(),
            ),
          ),
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

  String _getTitle() {
    final titleLabel = widget.journey.titleLabel;
    if (titleLabel != null && titleLabel.isNotEmpty) {
      return titleLabel;
    }
    final date = DateFormat(
      'dd-MM-yyyy',
    ).format(widget.journey.createdAt.toLocal());
    return 'Parcours du $date';
  }

  Widget _buildActionButton(BuildContext context, bool isLoading) {
    return SizedBox(
      height: 50,
      child: AnimatedCrossFade(
        firstChild: GlassPopupMenuButton<JourneyModalAction>(
          icon: const GlassPopupMenuTriggerIcon(icon: Icons.tune_rounded),
          onSelected: (action) => _handleModalAction(context, action),
          itemBuilder: (context) => _buildJourneyActions(),
        ),
        secondChild: const Padding(
          padding: EdgeInsets.all(5.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: CircularProgressIndicator(),
          ),
        ),
        crossFadeState:
            isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleModalAction(BuildContext context, JourneyModalAction action) {
    switch (action) {
      case JourneyModalAction.resetJourney:
        _onResetJourney(context);
        break;
      case JourneyModalAction.deleteJourney:
        _onDeleteJourney(context);
        break;
      case JourneyModalAction.downloadJourney:
        context.read<UserJourneyDetailsBloc>().add(
          DownloadUserJourney(fileName: _getJourneyFileName()),
        );
        break;
    }
  }

  void _onResetJourney(BuildContext context) async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: 'Réinitialiser le parcours',
      message:
          'Le parcours sera dissocié de l\'événement, mais restera disponible dans votre historique.',
      cancelLabel: 'Annuler',
      confirmLabel: 'Confirmer',
    );

    if (confirmed == true && context.mounted) {
      context.read<EventDetailsBloc>().add(
        ResetUserJourney(stepId: widget.stepId),
      );
    }
  }

  void _onDeleteJourney(BuildContext context) async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: 'Supprimer le parcours',
      message: 'Le parcours sera définitivement supprimé.',
      cancelLabel: 'Annuler',
      confirmLabel: 'Confirmer',
      destructiveConfirm: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<UserJourneyDetailsBloc>().add(DeleteUserJourney());
    }
  }

  String _getJourneyFileName() {
    final date = DateFormat(
      'dd-MM-yyyy',
    ).format(widget.journey.createdAt.toLocal());
    final uniqueKey = DateTime.now().microsecondsSinceEpoch.toString();
    return 'parcours_${date}_$uniqueKey.gpx';
  }

  List<PopupMenuItem<JourneyModalAction>> _buildJourneyActions() {
    final actions = <PopupMenuItem<JourneyModalAction>>[];

    if (widget.isCurrentEvent) {
      actions.add(
        glassPopupMenuItem(
          value: JourneyModalAction.resetJourney,
          icon: Icons.restart_alt_rounded,
          label: 'Réinitialiser le parcours',
        ),
      );
    } else {
      actions.add(
        glassPopupMenuItem(
          value: JourneyModalAction.deleteJourney,
          icon: Icons.delete_rounded,
          label: 'Supprimer le parcours',
        ),
      );
    }

    return [
      ...actions,
      glassPopupMenuItem(
        value: JourneyModalAction.downloadJourney,
        icon: Icons.download_rounded,
        label: 'Télécharger le parcours',
      ),
    ];
  }

  T? _readOrNull<T>(BuildContext context) {
    try {
      return context.read<T>();
    } on ProviderNotFoundException {
      return null;
    }
  }
}

class _JourneyHeroCard extends StatelessWidget {
  final UserJourney journey;
  final String subtitle;

  const _JourneyHeroCard({required this.journey, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.70),
            scheme.primary.withValues(alpha: 0.52),
          ],
        ),
        border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.72),
              fontSize: 12,
              fontVariations: const [FontVariation.weight(560)],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  journey.distanceLabel,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 40,
                    height: 0.95,
                    fontVariations: const [FontVariation.weight(780)],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _MetricBadge(
                icon: Icons.schedule_rounded,
                label: journey.totalTimeLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JourneyGamificationCard extends StatelessWidget {
  final bool isSolo;
  final double percentage;
  final int betterCount;
  final String title;
  final String summaryText;
  final String? bestText;

  const _JourneyGamificationCard({
    required this.isSolo,
    required this.percentage,
    required this.betterCount,
    required this.title,
    required this.summaryText,
    required this.bestText,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.secondary.withValues(alpha: 0.12),
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.secondary.withValues(alpha: 0.20),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.40),
                  ),
                ),
                child: Icon(
                  isSolo
                      ? Icons.emoji_events_rounded
                      : Icons.sports_motorsports,
                  color: scheme.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 15,
                    fontVariations: const [FontVariation.weight(720)],
                  ),
                ),
              ),
              if (betterCount > 0)
                SizedBox(
                  width: 32,
                  child: Lottie.asset(
                    "assets/lottie/lottie_medal.json",
                    repeat: true,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GradientProgressBar(
            animateStart: true,
            maxValue: 100,
            value: percentage,
            height: 7,
            colors: [
              Colors.red.shade400,
              Colors.yellow.shade400,
              Colors.green.shade400,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            summaryText,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.82),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(580)],
            ),
          ),
          if (bestText != null) ...[
            const SizedBox(height: 6),
            Text(
              bestText!,
              style: TextStyle(
                color: scheme.secondary,
                fontSize: 12,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JourneyStatGrid extends StatelessWidget {
  final List<_JourneyStatCardData> cards;

  const _JourneyStatGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 10) / 2;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final card in cards)
              SizedBox(width: cardWidth, child: _JourneyStatCard(data: card)),
          ],
        );
      },
    );
  }
}

class _JourneyStatCardData {
  final String title;
  final IconData icon;
  final List<_JourneyStatLineData> lines;

  const _JourneyStatCardData({
    required this.title,
    required this.icon,
    required this.lines,
  });
}

class _JourneyStatLineData {
  final IconData icon;
  final String label;
  final String value;
  final double? score;

  const _JourneyStatLineData({
    required this.icon,
    required this.label,
    required this.value,
    required this.score,
  });
}

class _JourneyStatCard extends StatelessWidget {
  final _JourneyStatCardData data;

  const _JourneyStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.primaryContainer.withValues(alpha: 0.60),
        border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(690)],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < data.lines.length; i++) ...[
            _JourneyStatLine(line: data.lines[i]),
            if (i < data.lines.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _JourneyStatLine extends StatelessWidget {
  final _JourneyStatLineData line;

  const _JourneyStatLine({required this.line});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statChip(scheme, line.icon, '${line.label} ${line.value}'),
        if (line.score != null) ...[
          const SizedBox(height: 4),
          GradientProgressBar(
            animateStart: true,
            maxValue: 100,
            value: line.score!,
            height: 3.5,
            colors: [
              Colors.red.shade400,
              Colors.yellow.shade400,
              Colors.green.shade400,
            ],
          ),
        ],
      ],
    );
  }

  Widget _statChip(ColorScheme scheme, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: scheme.onPrimary.withValues(alpha: 0.50)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.70),
              fontSize: 12,
              fontVariations: const [FontVariation.weight(550)],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetricBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: scheme.secondary.withValues(alpha: 0.16),
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.36)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.secondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.secondary,
              fontSize: 12,
              fontVariations: const [FontVariation.weight(700)],
            ),
          ),
        ],
      ),
    );
  }
}
