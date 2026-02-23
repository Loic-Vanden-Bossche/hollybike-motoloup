/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app_router.gr.dart';
import '../../bloc/event_images_bloc/event_images_event.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';

class EventDetailsImages extends StatelessWidget {
  final int eventId;
  final ScrollController scrollController;
  final bool isParticipating;
  final void Function() onAddPhotos;

  const EventDetailsImages({
    super.key,
    required this.eventId,
    required this.scrollController,
    required this.isParticipating,
    required this.onAddPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
      onRefresh: () => _refreshImages(context),
      child: BlocBuilder<EventImagesBloc, ImageListState>(
        builder: (context, state) {
          final imageCount = state.images.length;
          final bottomPadding = 126 + MediaQuery.paddingOf(context).bottom;

          return EventDetailsTabScrollWrapper(
            sliverChild: true,
            scrollViewKey: 'event_details_images_$eventId',
            child: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    child: _ImagesHeader(
                      imageCount: imageCount,
                      isParticipating: isParticipating,
                      onAddPhotos: onAddPhotos,
                    ),
                  ),
                ),
                ImageGallery(
                  scrollController: scrollController,
                  contentPadding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding),
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
                        bloc: context.read<EventImagesBloc>(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final widgets = <Widget>[
      Lottie.asset(
        fit: BoxFit.cover,
        'assets/lottie/lottie_images_placeholder.json',
        repeat: false,
        height: 150,
      ),
      Text(
        "Aucune photo ajoutée sur cet évènement",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 15,
          fontVariations: const [FontVariation.weight(650)],
        ),
      ),
    ];

    if (isParticipating) {
      widgets.addAll([
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onAddPhotos();
          },
          child: const Text("Ajouter des photos"),
        ),
      ]);
    } else {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            "Rejoignez l'événement pour pouvoir partager des photos.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.72),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(520)],
            ),
          ),
        ),
      );
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
    context.read<EventImagesBloc>().add(RefreshEventImages());

    return context.read<EventImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<EventImagesBloc>().add(LoadEventImagesNextPage());
  }
}

class _ImagesHeader extends StatelessWidget {
  final int imageCount;
  final bool isParticipating;
  final VoidCallback onAddPhotos;

  const _ImagesHeader({
    required this.imageCount,
    required this.isParticipating,
    required this.onAddPhotos,
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
            child: Icon(Icons.photo_library_outlined, color: scheme.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Galerie de l’événement',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 15,
                    fontVariations: const [FontVariation.weight(700)],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$imageCount $label disponibles',
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.70),
                    fontSize: 12,
                    fontVariations: const [FontVariation.weight(540)],
                  ),
                ),
              ],
            ),
          ),
          if (isParticipating)
            TextButton.icon(
              onPressed: onAddPhotos,
              style: TextButton.styleFrom(
                foregroundColor: scheme.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Ajouter'),
            ),
        ],
      ),
    );
  }
}
