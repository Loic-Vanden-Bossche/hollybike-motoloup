import 'background_location_facade.dart';

class BackgroundServiceShim {
  final BackgroundLocationFacade _owner;
  BackgroundServiceShim(this._owner);

  Future<bool> isTrackingRunning() => _owner.isTrackingRunning();

  Stream<double> getPositionStream() => _owner.getPositionStream();
}
