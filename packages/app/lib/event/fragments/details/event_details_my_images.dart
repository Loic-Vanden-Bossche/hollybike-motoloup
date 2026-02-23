/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/images/event_images_visibility_dialog.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

class EventDetailsMyImages extends StatelessWidget {
  final int eventId;
  final bool isImagesPublic;
  final bool isParticipating;
  final ScrollController scrollController;

  const EventDetailsMyImages({
    super.key,
    required this.eventId,
    required this.scrollController,
    required this.isParticipating,
    required this.isImagesPublic,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
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
            final bottomPadding = 126 + MediaQuery.paddingOf(context).bottom;

            return EventDetailsTabScrollWrapper(
              sliverChild: true,
              scrollViewKey: 'event_details_my_images_$eventId',
              child: SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                      child: _MyImagesHeader(
                        imageCount: imageCount,
                        isImagesPublic: isImagesPublic,
                        onVisibilityTap:
                            () => showEventImagesVisibilityDialog(
                              context,
                              isImagesPublic: isImagesPublic,
                              eventId: eventId,
                            ),
                      ),
                    ),
                  ),
                  ImageGallery(
                    scrollController: scrollController,
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
                    onImageTap: (image) {
                      context.router.push(
                        ImageGalleryViewRoute(
                          imageIndex: state.images.indexOf(image),
                          onLoadNextPage: () => _loadNextPage(context),
                          onRefresh: () => _refreshImages(context),
                          bloc: context.read<EventMyImagesBloc>(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final message =
        isParticipating
            ? "Vous n'avez ajouté aucune photo"
            : "Vous devez participer à l'évènement ajouter des photos";

    final widgets = <Widget>[
      Lottie.asset(
        fit: BoxFit.cover,
        'assets/lottie/lottie_images_placeholder.json',
        repeat: false,
        height: 150,
      ),
      Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 15,
          fontVariations: const [FontVariation.weight(650)],
        ),
      ),
    ];

    if (!isParticipating) {
      widgets.addAll([
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _onJoin(context),
          child: const Text("Rejoindre l'évènement"),
        ),
      ]);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primaryContainer.withValues(alpha: 0.50),
        border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.12)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: widgets),
    );
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
          TextButton.icon(
            onPressed: onVisibilityTap,
            style: TextButton.styleFrom(
              foregroundColor: isImagesPublic ? scheme.secondary : scheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            icon: Icon(
              isImagesPublic ? Icons.public : Icons.lock_outline,
              size: 18,
            ),
            label: Text(isImagesPublic ? 'Public' : 'Privé'),
          ),
        ],
      ),
    );
  }
}
