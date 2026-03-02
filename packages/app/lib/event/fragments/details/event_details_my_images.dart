/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/images/event_images_visibility_dialog.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/type/event_image.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/ui/widgets/placeholders/empty_state_placeholder.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../ui/widgets/modal/glass_confirmation_dialog.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

class EventDetailsMyImages extends StatefulWidget {
  final int eventId;
  final bool isImagesPublic;
  final bool isParticipating;
  final ScrollController scrollController;
  final ValueNotifier<bool>? selectionNotifier;

  const EventDetailsMyImages({
    super.key,
    required this.eventId,
    required this.scrollController,
    required this.isParticipating,
    required this.isImagesPublic,
    this.selectionNotifier,
  });

  @override
  State<EventDetailsMyImages> createState() => _EventDetailsMyImagesState();
}

class _EventDetailsMyImagesState extends State<EventDetailsMyImages> {
  final Set<int> _selectedIds = {};
  int _displayCount = 0;

  bool get _selectionMode => _selectedIds.isNotEmpty;

  void _onLongPress(EventImage image) {
    setState(() {
      _selectedIds.add(image.id);
      _displayCount = _selectedIds.length;
    });
    widget.selectionNotifier?.value = true;
  }

  void _onImageTap(BuildContext context, EventImage image, ImageListState state) {
    if (_selectionMode) {
      setState(() {
        if (_selectedIds.contains(image.id)) {
          _selectedIds.remove(image.id);
        } else {
          _selectedIds.add(image.id);
        }
        if (_selectedIds.isNotEmpty) _displayCount = _selectedIds.length;
      });
      widget.selectionNotifier?.value = _selectedIds.isNotEmpty;
    } else {
      context.router.push(
        ImageGalleryViewRoute(
          imageIndex: state.images.indexOf(image),
          onLoadNextPage: () => _loadNextPage(context),
          onRefresh: () => _refreshImages(context),
          bloc: context.read<EventMyImagesBloc>(),
        ),
      );
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
    widget.selectionNotifier?.value = false;
  }

  Future<void> _deleteSelected(BuildContext context) async {
    final count = _selectedIds.length;
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: 'Supprimer les photos',
      message: count == 1
          ? 'Voulez-vous supprimer cette photo ?'
          : 'Voulez-vous supprimer ces $count photos ?',
      confirmLabel: 'Supprimer',
      destructiveConfirm: true,
    );

    if (confirmed != true) return;

    if (!context.mounted) return;
    context.read<EventMyImagesBloc>().add(
      DeleteMyEventImages(imageIds: _selectedIds.toList()),
    );
    _clearSelection();
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<EventMyImagesBloc>().add(RefreshMyEventImages());
    return context.read<EventMyImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<EventMyImagesBloc>().add(LoadMyEventImagesNextPage());
  }

  void _onJoin(BuildContext context) {
    context.read<EventDetailsBloc>().add(JoinEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_selectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _selectionMode) {
          _clearSelection();
        }
      },
      child: Stack(
        children: [
          ThemedRefreshIndicator(
            onRefresh: () => _refreshImages(context),
            child: BlocListener<EventMyImagesBloc, ImageListState>(
              listener: (context, state) {
                if (state is ImageListOperationFailure) {
                  Toast.showErrorToast(context, state.errorMessage);
                }

                if (state is ImageListOperationSuccess) {
                  if (state.successMessage != null) {
                    Toast.showSuccessToast(context, state.successMessage!);
                  }

                  if (state.shouldRefresh) {
                    _refreshImages(context);
                  }
                }
              },
              child: BlocBuilder<EventMyImagesBloc, ImageListState>(
                builder: (context, state) {
                  final imageCount = state.images.length;
                  final bottomPadding = (_selectionMode ? 96.0 : 126.0) +
                      MediaQuery.paddingOf(context).bottom;

                  return EventDetailsTabScrollWrapper(
                    sliverChild: true,
                    scrollViewKey: 'event_details_my_images_${widget.eventId}',
                    child: SliverMainAxisGroup(
                      slivers: [
                        if (widget.isParticipating)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                              child: _MyImagesHeader(
                                imageCount: imageCount,
                                isImagesPublic: widget.isImagesPublic,
                                onVisibilityTap: () =>
                                    showEventImagesVisibilityDialog(
                                  context,
                                  isImagesPublic: widget.isImagesPublic,
                                  eventId: widget.eventId,
                                ),
                              ),
                            ),
                          ),
                        ImageGallery(
                          scrollController: widget.scrollController,
                          contentPadding: EdgeInsets.fromLTRB(
                            12,
                            0,
                            12,
                            bottomPadding,
                          ),
                          emptyPlaceholder: _buildPlaceholder(context),
                          errorMessage:
                              state is ImageListPageLoadFailure
                                  ? state.errorMessage
                                  : null,
                          onRefresh: () => _refreshImages(context),
                          onLoadNextPage: () => _loadNextPage(context),
                          images: state.images,
                          loading: state is ImageListPageLoadInProgress,
                          error: state is ImageListPageLoadFailure,
                          selectedImageIds:
                              _selectionMode ? Set.of(_selectedIds) : null,
                          onLongPress: _onLongPress,
                          onImageTap: (image) =>
                              _onImageTap(context, image, state),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: _selectionMode ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 320),
              curve: _selectionMode ? Curves.easeOutCubic : Curves.easeInCubic,
              child: _SelectionActionBar(
                count: _displayCount,
                onCancel: _clearSelection,
                onDelete: () => _deleteSelected(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return EmptyStatePlaceholder(
      title: widget.isParticipating
          ? "Vous n'avez ajouté aucune photo"
          : "Participez à l'évènement pour ajouter vos photos",
      actionLabel: widget.isParticipating ? null : "Rejoindre l'évènement",
      onAction: widget.isParticipating ? null : () => _onJoin(context),
      actionIcon: Icons.group_add_rounded,
    );
  }
}

class _SelectionActionBar extends StatelessWidget {
  final int count;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  const _SelectionActionBar({
    required this.count,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.72),
            border: Border(
              top: BorderSide(
                color: scheme.onPrimary.withValues(alpha: 0.10),
              ),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onCancel,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: scheme.onPrimary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: scheme.onPrimary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.86),
                      fontSize: 13,
                      fontVariations: const [FontVariation.weight(600)],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  count == 1 ? '1 photo sélectionnée' : '$count photos sélectionnées',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.72),
                    fontSize: 13,
                    fontVariations: const [FontVariation.weight(560)],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: scheme.error.withValues(alpha: 0.14),
                    border: Border.all(
                      color: scheme.error.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: scheme.error,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Supprimer',
                        style: TextStyle(
                          color: scheme.error,
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(650)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyImagesHeader extends StatelessWidget {
  final int imageCount;
  final bool isImagesPublic;
  final VoidCallback onVisibilityTap;

  const _MyImagesHeader({
    required this.imageCount,
    required this.isImagesPublic,
    required this.onVisibilityTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = imageCount == 1 ? 'photo' : 'photos';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primaryContainer.withValues(alpha: 0.52),
        border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.secondary.withValues(alpha: 0.18),
              border: Border.all(
                color: scheme.secondary.withValues(alpha: 0.36),
              ),
            ),
            child: Icon(
              Icons.photo_camera_back_outlined,
              color: scheme.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vos photos',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 15,
                    fontVariations: const [FontVariation.weight(700)],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$imageCount $label importées',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.70),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(540)],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onVisibilityTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: isImagesPublic
                    ? scheme.secondary.withValues(alpha: 0.12)
                    : scheme.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isImagesPublic
                      ? scheme.secondary.withValues(alpha: 0.35)
                      : scheme.error.withValues(alpha: 0.30),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isImagesPublic
                        ? Icons.public_rounded
                        : Icons.lock_outline_rounded,
                    size: 14,
                    color: isImagesPublic ? scheme.secondary : scheme.error,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isImagesPublic ? 'Public' : 'Privé',
                    style: TextStyle(
                      color: isImagesPublic ? scheme.secondary : scheme.error,
                      fontSize: 12,
                      fontVariations: const [FontVariation.weight(650)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
