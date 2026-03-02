/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/image/type/geolocated_event_image.dart';

abstract class EventMapImagesState {
  const EventMapImagesState();
}

class EventMapImagesInitial extends EventMapImagesState {}

class EventMapImagesLoading extends EventMapImagesState {}

class EventMapImagesLoaded extends EventMapImagesState {
  final List<GeolocatedEventImage> images;

  const EventMapImagesLoaded(this.images);
}

class EventMapImagesError extends EventMapImagesState {
  final String message;

  const EventMapImagesError(this.message);
}
