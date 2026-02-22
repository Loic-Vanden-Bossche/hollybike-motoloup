/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/profile/widgets/profile_page/profile_page.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/profile_modal/profile_modal.dart';

@RoutePage()
class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Hud(
      displayNavBar: true,
      // No appBar — the profile banner manages nav controls
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) {
          final currentProfile = bloc.currentProfile;

          if (currentProfile is ProfileLoadingEvent) {
            return const ProfilePage(
              profileLoading: true,
              profile: null,
              association: null,
            );
          }

          if (currentProfile is ProfileLoadSuccessEvent) {
            return ProfilePage(
              profileLoading: false,
              email: currentProfile.profile.email,
              profile: currentProfile.profile.toMinimalUser(),
              association: currentProfile.profile.association,
              isMe: true,
              onSettings: () => _openSettings(context),
            );
          }

          return const ProfilePage(
            profileLoading: false,
            profile: null,
            association: null,
          );
        },
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileModal(),
    );
  }
}
