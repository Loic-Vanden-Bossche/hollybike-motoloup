import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hollybike/journey/screen/import_gpx_tool_screen.dart';
import 'package:hollybike/shared/utils/one_shot_guard.dart';

void main() {
  test('handleGpxDownloadOnce processes only the first GPX callback', () {
    final guard = OneShotGuard();
    final file = File('first.gpx');

    var closeCalls = 0;
    var downloadCalls = 0;

    final first = handleGpxDownloadOnce(
      guard: guard,
      file: file,
      onClose: () => closeCalls++,
      onGpxDownloaded: (_) => downloadCalls++,
    );

    final second = handleGpxDownloadOnce(
      guard: guard,
      file: file,
      onClose: () => closeCalls++,
      onGpxDownloaded: (_) => downloadCalls++,
    );

    expect(first, isTrue);
    expect(second, isFalse);
    expect(closeCalls, 1);
    expect(downloadCalls, 1);
  });
}
