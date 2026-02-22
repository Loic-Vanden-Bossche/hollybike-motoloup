/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/profile/widgets/edit_profile/update_password_modal.dart';
import 'package:hollybike/profile/widgets/profile_picture_image_picker.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/shared/widgets/profile_pictures/profile_picture.dart';
import 'package:hollybike/ui/widgets/inputs/glass_input_decoration.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget implements AutoRouteWrapper {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();

  @override
  Widget wrappedRoute(context) {
    return BlocProvider(
      create:
          (context) => EditProfileBloc(
            profileRepository: context.read<ProfileRepository>(),
          ),
      child: this,
    );
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Profile? _currentProfile;
  late final TextEditingController _usernameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  OverlayEntry? _overlay;
  bool _touched = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _descriptionController = TextEditingController();

    final bloc = context.read<ProfileBloc>();
    final currentProfileEvent = bloc.currentProfile;

    if (currentProfileEvent is ProfileLoadSuccessEvent) {
      _usernameController.text = currentProfileEvent.profile.username;
      _descriptionController.text = currentProfileEvent.profile.role ?? '';
      _currentProfile = currentProfileEvent.profile;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final description =
          _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text;

      context.read<EditProfileBloc>().add(
        SaveProfileChanges(
          username: _usernameController.text,
          description: description,
          image: _selectedImage,
        ),
      );
    }
  }

  void _maybePop() {
    if (!_touched) {
      Navigator.of(context).pop();
      return;
    }
    _showQuitConfirmation();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _maybePop();
      },
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (_overlay != null) {
            _overlay?.remove();
            _overlay = null;
          }

          if (state is EditProfileLoadFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          }

          if (state is ResetPasswordFailure) {
            Toast.showErrorToast(context, state.errorMessage);
          }

          if (state is EditProfileLoadInProgress ||
              state is ResetPasswordInProgress) {
            _overlay = OverlayEntry(
              builder:
                  (_) => Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.55),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  ),
            );
            Overlay.of(context).insert(_overlay!);
          }

          if (state is EditProfileLoadSuccess) {
            Toast.showSuccessToast(context, state.successMessage);
            Navigator.of(context).pop();
          }

          if (state is ResetPasswordSuccess) {
            Toast.showSuccessToast(
              context,
              'Email de réinitialisation envoyé.',
            );
            Navigator.of(context).pop();
          }

          if (state is ResetPasswordNotAvailable) {
            _showServiceUnavailableDialog();
          }
        },
        builder: (context, state) {
          final currentProfile = _currentProfile;
          final isLoading = state is EditProfileLoadInProgress;

          return Hud(
            // No appBar — the hero section manages navigation
            body: Builder(
              builder: (context) {
                if (currentProfile == null) {
                  return const SizedBox();
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Glass hero ────────────────────────────────────────
                      _buildHero(context, currentProfile),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── INFORMATIONS section ──────────────────────
                              _sectionLabel(context, 'INFORMATIONS'),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _usernameController,
                                keyboardType: TextInputType.name,
                                autocorrect: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (_) => _markTouched(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Le nom d'utilisateur ne peut pas être vide.";
                                  }
                                  if (value.length > 1000) {
                                    return "Le nom d'utilisateur ne peut pas dépasser 1000 caractères.";
                                  }
                                  return null;
                                },
                                decoration: buildGlassInputDecoration(
                                  context,
                                  labelText: "Nom d'utilisateur",
                                  suffixIcon: Icon(
                                    Icons.account_circle_rounded,
                                    size: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _descriptionController,
                                autocorrect: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (_) => _markTouched(),
                                validator: (value) {
                                  if (value != null && value.length > 255) {
                                    return "Votre description ne peut pas dépasser 255 caractères.";
                                  }
                                  return null;
                                },
                                decoration: buildGlassInputDecoration(
                                  context,
                                  labelText: "Description (facultatif)",
                                  suffixIcon: Icon(
                                    Icons.description_rounded,
                                    size: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.35),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

                              // ── SÉCURITÉ section ──────────────────────────
                              _sectionLabel(context, 'SÉCURITÉ'),
                              const SizedBox(height: 10),
                              _buildPasswordRow(context, currentProfile.email),
                              const SizedBox(height: 32),

                              // ── Save button ───────────────────────────────
                              _buildSaveButton(context, isLoading),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero(BuildContext context, Profile currentProfile) {
    final scheme = Theme.of(context).colorScheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      child: Stack(
        children: [
          // Base gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.primary.withValues(alpha: 0.70),
                    scheme.primary.withValues(alpha: 0.52),
                  ],
                ),
              ),
            ),
          ),

          // Teal blob — top-left
          Positioned(
            top: -50,
            left: -35,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.secondary.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
          ),

          // Tertiary blob — bottom-right
          Positioned(
            bottom: -35,
            right: -25,
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.tertiary.withValues(alpha: 0.16),
                  ),
                ),
              ),
            ),
          ),

          // Content
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 22),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: scheme.onPrimary.withValues(alpha: 0.10),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nav row — back button only
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _maybePop,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer.withValues(
                              alpha: 0.55,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.onPrimary.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: scheme.onPrimary.withValues(alpha: 0.80),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Editable avatar
                  GestureDetector(
                    onTap: _showImagePickerModal,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scheme.secondary.withValues(alpha: 0.55),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.secondary.withValues(alpha: 0.22),
                                blurRadius: 22,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ProfilePicture(
                            user: currentProfile.toMinimalUser(),
                            file: _selectedImage,
                            size: 80,
                          ),
                        ),
                        // Camera badge
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scheme.secondary,
                              border: Border.all(
                                color: scheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 13,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Modifier mon profil',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 18,
                      fontVariations: const [FontVariation.weight(700)],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentProfile.username,
                    style: TextStyle(
                      color: scheme.onPrimary.withValues(alpha: 0.45),
                      fontSize: 13,
                      fontVariations: const [FontVariation.weight(500)],
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 3,
          height: 13,
          decoration: BoxDecoration(
            color: scheme.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.45),
            fontSize: 10,
            fontVariations: const [FontVariation.weight(700)],
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRow(BuildContext context, String email) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showUpdatePasswordModal(context, email),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.60),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.10),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 17,
              color: scheme.onPrimary.withValues(alpha: 0.55),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Changer le mot de passe',
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.80),
                  fontSize: 14,
                  fontVariations: const [FontVariation.weight(550)],
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: scheme.onPrimary.withValues(alpha: 0.30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isLoading) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: isLoading ? null : _onSubmit,
      child: AnimatedOpacity(
        opacity: isLoading ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: scheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.40),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_rounded, size: 16, color: scheme.secondary),
              const SizedBox(width: 8),
              Text(
                'Sauvegarder',
                style: TextStyle(
                  color: scheme.secondary,
                  fontSize: 14,
                  fontVariations: const [FontVariation.weight(650)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _markTouched() {
    if (!_touched) setState(() => _touched = true);
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showQuitConfirmation() async {
    final confirmed = await showGlassConfirmationDialog(
      context: context,
      title: 'Modifications non sauvegardées',
      message: 'Voulez-vous quitter sans sauvegarder vos modifications ?',
      cancelLabel: 'Rester',
      confirmLabel: 'Quitter',
      destructiveConfirm: true,
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showServiceUnavailableDialog() {
    showGlassConfirmationDialog(
      context: context,
      title: 'Service indisponible',
      message:
          "La réinitialisation du mot de passe n'est pas disponible, veuillez contacter un administrateur.",
      showCancel: false,
      confirmLabel: 'Ok',
    );
  }

  void _showUpdatePasswordModal(BuildContext context, String email) {
    showDialog<void>(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: context.read<EditProfileBloc>(),
            child: UpdatePasswordModal(email: email),
          ),
    );
  }

  void _showImagePickerModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ProfilePictureImagePickerModal(
            onImageSelected: (file) {
              setState(() {
                _selectedImage = file;
                _touched = true;
              });
            },
          ),
    );
  }
}
