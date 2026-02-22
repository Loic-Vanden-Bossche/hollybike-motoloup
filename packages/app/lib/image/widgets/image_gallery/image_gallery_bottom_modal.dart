/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_state.dart';
import 'package:hollybike/image/type/event_image_details.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import '../../type/event_image.dart';
import 'image_details/image_gallery_details.dart';

class ImageGalleryBottomModal extends StatefulWidget {
  final EventImage image;
  final void Function() onImageDeleted;

  const ImageGalleryBottomModal({
    super.key,
    required this.image,
    required this.onImageDeleted,
  });

  @override
  State<ImageGalleryBottomModal> createState() =>
      _ImageGalleryBottomModalState();
}

class _ImageGalleryBottomModalState extends State<ImageGalleryBottomModal> {
  bool _isImageOwner = false;

  @override
  void initState() {
    super.initState();
    context.read<EventImageDetailsBloc>().add(
      GetEventImageDetails(imageId: widget.image.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dynamicContentHeight = (screenHeight * 0.44).clamp(300.0, 420.0);

    return BlocListener<EventImageDetailsBloc, EventImageDetailsState>(
      listener: (context, state) {
        if (state is DeleteImageSuccess) {
          widget.onImageDeleted();
        }

        if (state is EventImageDetailsLoadSuccess) {
          setState(() {
            _isImageOwner = state.imageDetails?.isOwner ?? false;
          });
        }

        if (state is DownloadImageSuccess) {
          Toast.showSuccessToast(context, 'Image téléchargée');
        }

        if (state is EventImageDetailsLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassBottomModal(
          maxContentHeight: dynamicContentHeight,
          contentPadding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildMetaRow(context),
                const SizedBox(height: 10),
                _buildActions(context),
                const SizedBox(height: 10),
                _buildDetailsPanel(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.onPrimary.withValues(alpha: 0.05),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BlocBuilder<EventImageDetailsBloc, EventImageDetailsState>(
          builder: (context, state) {
            if (state is EventImageDetailsLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.imageDetails == null) {
              return Center(
                child: Text(
                  'Image non trouvée',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return ImageGalleryDetails(
              imageDetails: state.imageDetails as EventImageDetails,
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.secondary.withValues(alpha: 0.16),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.34),
              width: 1,
            ),
          ),
          child: Icon(Icons.photo_rounded, size: 18, color: scheme.secondary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Détails de la photo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.88),
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: IconButton.styleFrom(
            backgroundColor: scheme.onPrimary.withValues(alpha: 0.1),
            foregroundColor: scheme.onPrimary.withValues(alpha: 0.72),
          ),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: scheme.onPrimary.withValues(alpha: 0.06),
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildMetaItem(
            context,
            icon: Icons.straighten_rounded,
            text: '${widget.image.width}x${widget.image.height}',
          ),
          const SizedBox(width: 16),
          _buildMetaItem(
            context,
            icon: Icons.data_object_rounded,
            text: '${(widget.image.size / 1024).round()} KB',
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 15, color: scheme.onPrimary.withValues(alpha: 0.6)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final actions = <Widget>[
      _ActionButton(
        icon: Icons.share_rounded,
        label: 'Partager',
        onTap: _onShareImage,
      ),
      _ActionButton(
        icon: Icons.download_rounded,
        label: 'Télécharger',
        onTap: _onDownloadImage,
      ),
    ];

    if (_isImageOwner) {
      actions.add(
        _ActionButton(
          icon: Icons.delete_outline_rounded,
          label: 'Supprimer',
          destructive: true,
          onTap: _onDeleteImage,
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: actions);
  }

  Future<String> _downloadImageToPath(String imagePath) async {
    final response = await get(Uri.parse(widget.image.url));
    final filePathAndName = path.join(
      imagePath,
      'hollybike-${widget.image.id}.jpg',
    );
    final file = File(filePathAndName);
    file.writeAsBytesSync(response.bodyBytes);

    return filePathAndName;
  }

  Future<void> _onShareImage() async {
    final directory = Directory.systemTemp;
    final imagePath = await _downloadImageToPath(directory.path);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(imagePath)],
        text: 'Partage de l\'image depuis Hollybike',
      ),
    );
  }

  void _onDownloadImage() {
    context.read<EventImageDetailsBloc>().add(
      DownloadImage(imageUrl: widget.image.url, imgId: widget.image.id),
    );
  }

  Future<void> _onDeleteImage() async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: 'Suppression de l\'image',
      message: 'Êtes-vous sûr de vouloir supprimer cette image ?',
      cancelLabel: 'Annuler',
      confirmLabel: 'Confirmer',
      destructiveConfirm: true,
    );

    if (confirmed == true && mounted) {
      context.read<EventImageDetailsBloc>().add(
        DeleteImage(imageId: widget.image.id),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = destructive ? scheme.error : scheme.secondary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: tone.withValues(alpha: 0.14),
          border: Border.all(color: tone.withValues(alpha: 0.34), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: tone),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: tone,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
