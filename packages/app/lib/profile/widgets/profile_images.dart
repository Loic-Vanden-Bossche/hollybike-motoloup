/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_bloc.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_event.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';

class ProfileImages extends StatelessWidget {
  final ScrollController scrollController;
  final bool isMe;
  final String username;

  const ProfileImages({
    super.key,
    required this.scrollController,
    required this.isMe,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileImagesBloc, ImageListState>(
      builder: (context, state) {
        final bottomPadding = 126 + MediaQuery.paddingOf(context).bottom;

        return ThemedRefreshIndicator(
          onRefresh: () => _refreshImages(context),
          child: EventDetailsTabScrollWrapper(
            sliverChild: true,
            scrollViewKey: 'profile_images',
            child: ImageGallery(
              scrollController: scrollController,
              contentPadding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding),
              emptyPlaceholder: _buildPlaceholder(context),
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
                    bloc: context.read<ProfileImagesBloc>(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final message =
        isMe
            ? "Vous n'avez ajouté aucune photo"
            : "$username n'a ajouté aucune photo";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primaryContainer.withValues(alpha: 0.50),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ProfileImagesPlaceholderIcon(),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.75),
              fontSize: 14,
              fontVariations: const [FontVariation.weight(550)],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<ProfileImagesBloc>().add(RefreshProfileImages());

    return context.read<ProfileImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<ProfileImagesBloc>().add(LoadProfileImagesNextPage());
  }
}

class _ProfileImagesPlaceholderIcon extends StatefulWidget {
  const _ProfileImagesPlaceholderIcon();

  @override
  State<_ProfileImagesPlaceholderIcon> createState() =>
      _ProfileImagesPlaceholderIconState();
}

class _ProfileImagesPlaceholderIconState
    extends State<_ProfileImagesPlaceholderIcon>
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
            Icons.photo_library_outlined,
            size: 30,
            color: scheme.secondary.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}
