/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_confirmation_dialog.dart';
import '../../event/types/event.dart';

Future<PlatformFile?> getJourneyFile(BuildContext context, Event event) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  if (result == null) {
    return null;
  }

  final extension = result.files.single.extension;

  if (!context.mounted) return null;

  if (extension != 'gpx' && extension != 'geojson') {
    showGlassConfirmationDialog(
      context: context,
      title: "Fichier invalide",
      message: "Le fichier doit être au format GPX ou GEOJSON",
      showCancel: false,
      confirmLabel: "Ok",
    );

    return null;
  }

  return result.files.single;
}
