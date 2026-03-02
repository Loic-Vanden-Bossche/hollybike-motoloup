/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_event.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_state.dart';
import 'package:hollybike/image/services/image_repository.dart';

class EventMapImagesBloc
    extends Bloc<EventMapImagesEvent, EventMapImagesState> {
  final int eventId;
  final ImageRepository imageRepository;

  EventMapImagesBloc({required this.eventId, required this.imageRepository})
    : super(EventMapImagesInitial()) {
    on<LoadEventMapImages>(_onLoad);
  }

  Future<void> _onLoad(
    LoadEventMapImages event,
    Emitter<EventMapImagesState> emit,
  ) async {
    emit(EventMapImagesLoading());
    try {
      final images = await imageRepository.fetchGeolocatedEventImages(eventId);
      emit(EventMapImagesLoaded(images));
    } catch (e) {
      log('Error loading geolocated images', error: e);
      emit(EventMapImagesError('Impossible de charger les photos.'));
    }
  }
}
