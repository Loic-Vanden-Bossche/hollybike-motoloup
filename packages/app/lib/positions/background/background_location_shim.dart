import 'background_location_facade.dart';

class BackgroundServiceShim {
  final BackgroundLocationFacade _owner;
  BackgroundServiceShim(this._owner);

  Future<bool> isTrackingRunning() => _owner.isTrackingRunning();

  Stream<void> getPositionStream() => _owner.getPositionStream();
}
