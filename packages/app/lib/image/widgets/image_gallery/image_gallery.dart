/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../event/widgets/images/event_image_with_loader.dart';
import '../../type/event_image.dart';

class ImageGallery extends StatefulWidget {
  final ScrollController scrollController;
  final List<EventImage> images;
  final bool loading;
  final bool error;
  final void Function(EventImage) onImageTap;
  final void Function() onRefresh;
  final void Function() onLoadNextPage;
  final Widget emptyPlaceholder;
  final EdgeInsetsGeometry contentPadding;
  final String? errorMessage;

  const ImageGallery({
    super.key,
    required this.scrollController,
    required this.images,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.onLoadNextPage,
    required this.onImageTap,
    required this.emptyPlaceholder,
    this.contentPadding = const EdgeInsets.all(4),
    this.errorMessage,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    widget.onRefresh();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _StatusCard(
              icon: Icons.cloud_off_rounded,
              title: 'Impossible de charger les photos',
              subtitle:
                  widget.errorMessage ??
                  'Une erreur est survenue lors du chargement des images. Veuillez réessayer.',
              actionLabel: 'Réessayer',
              onAction: widget.onRefresh,
            ),
          ),
        ),
      );
    }

    if (widget.loading && widget.images.isEmpty) {
      return SliverPadding(
        padding: widget.contentPadding,
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            final isTall = index.isEven;
            return _LoadingTile(isTall: isTall);
          }, childCount: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.78,
          ),
        ),
      );
    }

    if (widget.images.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Align(
          alignment: const Alignment(0, -0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: widget.emptyPlaceholder,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: widget.contentPadding,
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];

          return EventImageWithLoader(
            image: image,
            onTap: () {
              widget.onImageTap(image);
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    var nextPageTrigger =
        0.8 * widget.scrollController.position.maxScrollExtent;

    if (widget.scrollController.position.pixels > nextPageTrigger) {
      widget.onLoadNextPage();
    }
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.primaryContainer.withValues(alpha: 0.52),
        border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: scheme.error, size: 26),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 15,
              fontVariations: const [FontVariation.weight(680)],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.72),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(520)],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  final bool isTall;

  const _LoadingTile({required this.isTall});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: isTall ? 0.72 : 1.08,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: scheme.primaryContainer.withValues(alpha: 0.42),
          border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.10)),
        ),
      ),
    );
  }
}
