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
import 'package:hollybike/ui/widgets/placeholders/empty_state_placeholder.dart';

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
    final message =
        isMe
            ? "Vous n'avez ajouté aucune photo"
            : "$username n'a ajouté aucune photo";

    return EmptyStatePlaceholder(
      title: message,
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
