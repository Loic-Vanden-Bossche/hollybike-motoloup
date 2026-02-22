/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/bloc_provided_builder.dart';

import '../../shared/widgets/hud/hud.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import '../widgets/profile_modal/profile_modal.dart';
import '../widgets/profile_page/profile_page.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  final String? urlId;

  const ProfileScreen({super.key, @PathParam('id') this.urlId});

  @override
  Widget build(BuildContext context) {
    return Hud(
      // No appBar — the profile banner manages nav controls
      body: BlocProvidedBuilder<ProfileBloc, ProfileState>(
        builder: (context, bloc, state) => _buildProfilePage(context, bloc),
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context, ProfileBloc bloc) {
    final id = urlId == null ? null : int.tryParse(urlId!);
    if (id == null) return _buildError();

    final currentProfile = bloc.currentProfile;
    if (currentProfile is ProfileLoadingEvent) return _buildLoading();
    if (currentProfile is ProfileLoadErrorEvent) return _buildError();

    final user = bloc.getUserById(id);
    if (user is UserLoadingEvent) return _buildLoading(id: id);
    if (user is UserLoadErrorEvent) return _buildError();

    if (currentProfile is ProfileLoadSuccessEvent &&
        user is UserLoadSuccessEvent) {
      final isMe = currentProfile.profile.id == user.user.id;

      return ProfilePage(
        id: id,
        profileLoading: false,
        isMe: isMe,
        email: isMe ? currentProfile.profile.email : null,
        profile: user.user,
        association: currentProfile.profile.association,
        onBack: () => AutoRouter.of(context).maybePop(),
        onSettings: isMe ? () => _openSettings(context) : null,
      );
    }

    return const SizedBox();
  }

  Widget _buildLoading({int? id}) {
    return ProfilePage(
      id: id,
      profileLoading: true,
      profile: null,
      association: null,
    );
  }

  Widget _buildError() {
    return const ProfilePage(
      id: null,
      profileLoading: false,
      profile: null,
      association: null,
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
