/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_journey_bloc/event_journey_bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_menu.dart';
import 'package:hollybike/event/widgets/journey/upload_journey_modal.dart';
import 'package:hollybike/journey/widgets/journey_tools_modal.dart';
import 'package:hollybike/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:hollybike/profile/bloc/profile_journeys_bloc/profile_journeys_bloc.dart';
import 'package:hollybike/user_journey/services/user_journey_repository.dart';
import 'package:hollybike/user_journey/widgets/user_journey_list_modal.dart';

import '../../../journey/bloc/journeys_library_bloc/journeys_library_bloc.dart';
import '../../../journey/service/journey_repository.dart';
import '../../../journey/utils/get_journey_file_and_upload_to_event.dart';
import '../../../journey/widgets/journey_library_modal.dart';
import '../../../shared/utils/one_shot_guard.dart';
import '../../bloc/event_journey_bloc/event_journey_event.dart';

import 'package:http/http.dart' as http;

import 'package:path/path.dart' as path;

void journeyImportModalFromType(
  BuildContext context,
  NewJourneyType type,
  Event event, {
  void Function()? selected,
}) async {
  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));

    final tempDir = Directory.systemTemp;
    final filePath = path.join(
      tempDir.path,
      'temp-import-user-journey.geojson',
    );
    final file = File(filePath);
    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future<void> uploadJourneyFile(File file, bool isGpx) async {
    if (!context.mounted) {
      return;
    }

    BlocProvider.of<EventJourneyBloc>(context).add(
      UploadJourneyFileToEvent(
        eventId: event.id,
        name: event.name,
        stepName: null,
        file: file,
      ),
    );

    if (!context.mounted) {
      return;
    }

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<EventJourneyBloc>(context),
          child: UploadJourneyModal(isGpx: isGpx),
        );
      },
    );
  }

  switch (type) {
    case NewJourneyType.library:
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider.value(
            value: BlocProvider.of<EventJourneyBloc>(context),
            child: BlocProvider<JourneysLibraryBloc>(
              create:
                  (context) => JourneysLibraryBloc(
                    journeyRepository: RepositoryProvider.of<JourneyRepository>(
                      context,
                    ),
                  ),
              child: JourneyLibraryModal(
                event: event,
                onJourneyAdded: () {
                  selected?.call();
                },
              ),
            ),
          );
        },
      );
      break;
    case NewJourneyType.userJourney:
      final profileBloc = BlocProvider.of<ProfileBloc>(context);

      final currentProfileEvent = profileBloc.currentProfile;

      final currentProfile =
          currentProfileEvent is ProfileLoadSuccessEvent
              ? currentProfileEvent.profile
              : null;

      if (currentProfile == null) {
        return;
      }

      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) {
          return BlocProvider<ProfileJourneysBloc>(
            create:
                (context) => ProfileJourneysBloc(
                  userJourneyRepository:
                      RepositoryProvider.of<UserJourneyRepository>(context),
                  userId: currentProfile.id,
                ),
            child: UserJourneyListModal(
              fileSelected: (url) async {
                final file = await downloadFile(url);

                await uploadJourneyFile(file, true);
                selected?.call();
              },
              user: currentProfile.toMinimalUser(),
            ),
          );
        },
      );
      break;
    case NewJourneyType.file:
      final platformFile = await getJourneyFile(context, event);

      final filePath = platformFile?.path;

      if (filePath != null) {
        final file = File(filePath);

        final isGpx = platformFile?.extension == '.gpx';

        await uploadJourneyFile(file, isGpx);

        selected?.call();
      }
      break;
    case NewJourneyType.external:
      final externalUploadGuard = OneShotGuard();

      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return JourneyToolsModal(
            onGpxDownloaded: (file) async {
              await handleExternalGpxDownloadedOnce(
                guard: externalUploadGuard,
                file: file,
                uploadJourneyFile:
                    (selectedFile) => uploadJourneyFile(selectedFile, true),
                onSelected: selected,
              );
            },
          );
        },
      );

      break;
  }
}

Future<bool> handleExternalGpxDownloadedOnce({
  required OneShotGuard guard,
  required File file,
  required Future<void> Function(File file) uploadJourneyFile,
  void Function()? onSelected,
}) async {
  if (!guard.consume()) {
    return false;
  }

  await uploadJourneyFile(file);
  onSelected?.call();
  return true;
}
