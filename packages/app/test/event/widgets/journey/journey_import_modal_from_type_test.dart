import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hollybike/event/widgets/journey/journey_import_modal_from_type.dart';
import 'package:hollybike/shared/utils/one_shot_guard.dart';

void main() {
  test('handleExternalGpxDownloadedOnce uploads only once for duplicate callbacks', () async {
    final guard = OneShotGuard();
    final file = File('external.gpx');

    var uploadCalls = 0;
    var selectedCalls = 0;

    final first = await handleExternalGpxDownloadedOnce(
      guard: guard,
      file: file,
      uploadJourneyFile: (_) async {
        uploadCalls++;
      },
      onSelected: () => selectedCalls++,
    );

    final second = await handleExternalGpxDownloadedOnce(
      guard: guard,
      file: file,
      uploadJourneyFile: (_) async {
        uploadCalls++;
      },
      onSelected: () => selectedCalls++,
    );

    expect(first, isTrue);
    expect(second, isFalse);
    expect(uploadCalls, 1);
    expect(selectedCalls, 1);
  });
}
