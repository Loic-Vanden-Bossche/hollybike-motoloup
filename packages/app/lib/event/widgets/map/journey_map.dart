/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_bloc.dart';
import 'package:hollybike/event/bloc/event_map_images/event_map_images_state.dart';
import 'package:hollybike/event/widgets/map/photo_map_marker_manager.dart';
import 'package:hollybike/image/type/geolocated_event_image.dart';
import 'package:hollybike/journey/service/journey_position_manager.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_bloc.dart';
import 'package:hollybike/positions/bloc/user_positions/user_positions_state.dart';
import 'package:hollybike/shared/types/geojson.dart';
import 'package:hollybike/shared/utils/waiter.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'event_map_photo_carousel.dart' show kCarouselTotalHeight;

// ── Controller ────────────────────────────────────────────────────────────────

class JourneyMapController {
  _JourneyMapState? _state;

  void _attach(_JourneyMapState state) => _state = state;
  void _detach() => _state = null;

  Future<void> showMarkerFor(GeolocatedEventImage image) async =>
      _state?._showMarkerFor(image);

  Future<void> panCameraTo(GeolocatedEventImage image) async =>
      _state?._panCameraTo(image);

  void hideMarker() => _state?._markerManager?.hide();
}

// ── Widget ────────────────────────────────────────────────────────────────────

class JourneyMap extends StatefulWidget {
  final MinimalJourney? journey;
  final bool showLivePositions;
  final JourneyMapController controller;
  final void Function() onMapLoaded;
  final void Function()? onMapInteractionStart;

  const JourneyMap({
    super.key,
    required this.journey,
    this.showLivePositions = true,
    required this.controller,
    required this.onMapLoaded,
    this.onMapInteractionStart,
  });

  @override
  State<JourneyMap> createState() => _JourneyMapState();
}

class _JourneyMapState extends State<JourneyMap> {
  static const _heatmapSourceId = 'photos-heatmap-source';
  static const _heatmapLayerId = 'photos-heatmap-layer';

  MapboxMap? _map;
  GeoJsonSource? _heatmapSource;
  PhotoMapMarkerManager? _markerManager;
  String? _geoJsonRaw;
  StreamSubscription<UserPositionsState>? _positionsSubscription;

  bool _mapLoading = true;
  bool _pointerDown = false;
  bool _interactionDispatched = false;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void dispose() {
    widget.controller._detach();
    _markerManager?.hide();
    _positionsSubscription?.cancel();
    super.dispose();
  }

  // ── Map creation ───────────────────────────────────────────────────────────

  Future<String> _getGeoJsonData(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    return response.body;
  }

  void _onMapCreated(MapboxMap map) {
    _map = map;
    final isDark = BlocProvider.of<ThemeBloc>(context).state.isDark;
    final file = widget.journey?.file;

    waitConcurrently(
          map.loadStyleURI(
            isDark
                ? 'mapbox://styles/mapbox/navigation-night-v1'
                : 'mapbox://styles/mapbox/navigation-day-v1',
          ),
          file == null ? Future.value(null) : _getGeoJsonData(file),
        )
        .then((values) async {
          if (!mounted) return;
          final (_, geoJsonRaw) = values;
          _geoJsonRaw = geoJsonRaw;
          final userPositionsBloc = BlocProvider.of<UserPositionsBloc>(context);

          await Future.wait([
            if (geoJsonRaw != null)
              map.style.addSource(
                GeoJsonSource(id: 'tracks', data: geoJsonRaw),
              ),
            map.style.setLights(
              AmbientLight(id: 'ambient-light', intensity: isDark ? 0.5 : 1),
              DirectionalLight(
                castShadows: true,
                shadowIntensity: 1,
                id: 'directional-light',
                intensity: isDark ? 0.5 : 1,
                color: 0XFFEC9F53,
                direction: [0, 90],
              ),
            ),
            map.style.addLayerAt(
              LineLayer(
                id: 'tracks-layer',
                sourceId: 'tracks',
                lineJoin: LineJoin.ROUND,
                lineCap: LineCap.ROUND,
                lineColor: 0xFF3457D5,
                lineWidth: 5,
                lineEmissiveStrength: 1,
              ),
              LayerPosition(above: 'traffic-bridge-road-link-navigation'),
            ),
            _initHeatmap(map),
            _initPhotoMarker(map),
            map.annotations.createPointAnnotationManager().then((
              pointManager,
            ) async {
              if (!mounted) return;
              final journeyPositionManager = JourneyPositionManager(
                pointManager: pointManager,
                context: context,
              );
              final initialPositions =
                  widget.showLivePositions
                      ? userPositionsBloc.state.userPositions
                      : const <WebsocketReceivePosition>[];

              _positionsSubscription?.cancel();
              Timer(const Duration(seconds: 1), () {
                journeyPositionManager.updatePositions(initialPositions);
                _positionsSubscription = userPositionsBloc.stream.listen((
                  state,
                ) {
                  final visiblePositions =
                      widget.showLivePositions
                          ? state.userPositions
                          : const <WebsocketReceivePosition>[];
                  journeyPositionManager.updatePositions(visiblePositions);
                  _setCameraOptions(visiblePositions, map, updateMode: true);
                });
              });
            }),
          ]);

          final userPositions =
              widget.showLivePositions
                  ? userPositionsBloc.state.userPositions
                  : const <WebsocketReceivePosition>[];
          final cameraOptions = await _setCameraOptions(userPositions, map);

          setState(() => _mapLoading = false);
          widget.onMapLoaded();

          await map.easeTo(
            CameraOptions(
              center: cameraOptions.center,
              zoom: (cameraOptions.zoom ?? 0) + 0.9,
              bearing: cameraOptions.bearing,
              pitch: cameraOptions.pitch,
            ),
            MapAnimationOptions(duration: 600),
          );

          if (!mounted) return;

          // Catch-up: images may have loaded before map was ready.
          final imagesState = context.read<EventMapImagesBloc>().state;
          if (imagesState is EventMapImagesLoaded &&
              imagesState.images.isNotEmpty) {
            await _updateHeatmap(imagesState.images);
            await _fitAllImages(imagesState.images);
          }
        })
        .catchError((error) {
          if (kDebugMode) print('Error loading map: $error');
          setState(() => _mapLoading = false);
        });
  }

  // ── Camera ─────────────────────────────────────────────────────────────────

  Future<CameraOptions> _setCameraOptions(
    List<WebsocketReceivePosition> userPositions,
    MapboxMap map, {
    bool updateMode = false,
  }) async {
    final userCoordinates =
        userPositions
            .map(
              (p) => Coordinate(longitude: p.longitude, latitude: p.latitude),
            )
            .toList();

    final geoJson = _geoJsonRaw;
    final bbox =
        geoJson == null
            ? GeoJSON.calculateBbox(userCoordinates)
            : GeoJSON.fromJsonString(
              geoJson,
            ).dynamicBBox(extraValues: userCoordinates);

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: Position(bbox[0], bbox[1])),
      northeast: Point(coordinates: Position(bbox[2], bbox[3])),
      infiniteBounds: false,
    );

    final cameraOptions = await map.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(top: 0, left: 0, right: 0, bottom: 0),
      null,
      30,
      null,
      null,
    );

    await map.setBounds(CameraBoundsOptions(bounds: bounds));

    if (!updateMode) {
      await map.setCamera(cameraOptions);
    }

    return cameraOptions;
  }

  Future<void> _fitAllImages(List<GeolocatedEventImage> images) async {
    final map = _map;
    if (map == null || images.isEmpty) return;

    final imageCoordinates =
        images
            .map(
              (img) => Coordinate(
                longitude: img.position.longitude,
                latitude: img.position.latitude,
              ),
            )
            .toList();

    final geoJson = _geoJsonRaw;
    final bbox =
        geoJson == null
            ? GeoJSON.calculateBbox(imageCoordinates)
            : GeoJSON.fromJsonString(
              geoJson,
            ).dynamicBBox(extraValues: imageCoordinates);

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: Position(bbox[0], bbox[1])),
      northeast: Point(coordinates: Position(bbox[2], bbox[3])),
      infiniteBounds: false,
    );

    await map.setBounds(CameraBoundsOptions(bounds: bounds));

    final cameraOptions = await map.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(
        top: 40,
        left: 40,
        right: 40,
        bottom: kCarouselTotalHeight + 40,
      ),
      null,
      null,
      null,
      null,
    );

    await map.easeTo(cameraOptions, MapAnimationOptions(duration: 600));
  }

  Future<void> _panCameraTo(GeolocatedEventImage image) async {
    final map = _map;
    if (map == null) return;

    await map.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            image.position.longitude,
            image.position.latitude,
          ),
        ),
        zoom: 14,
        padding: MbxEdgeInsets(
          top: 0,
          left: 0,
          right: 0,
          bottom: kCarouselTotalHeight + 16,
        ),
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  // ── Heatmap ────────────────────────────────────────────────────────────────

  Future<void> _initHeatmap(MapboxMap map) async {
    try {
      await map.style.addSource(
        GeoJsonSource(id: _heatmapSourceId, data: _emptyGeoJson),
      );

      await map.style.addLayer(
        HeatmapLayer(id: _heatmapLayerId, sourceId: _heatmapSourceId),
      );

      // Color ramp: transparent → teal → warm yellow → orange
      await map.style.setStyleLayerProperty(
        _heatmapLayerId,
        'heatmap-color',
        jsonEncode([
          'interpolate',
          ['linear'],
          ['heatmap-density'],
          0,
          'rgba(0,0,0,0)',
          0.15,
          'rgba(148,226,213,0.5)',
          0.4,
          'rgba(148,226,213,1)',
          0.7,
          'rgba(255,210,80,1)',
          1.0,
          'rgba(255,130,70,1)',
        ]),
      );

      // Radius grows with zoom
      await map.style.setStyleLayerProperty(
        _heatmapLayerId,
        'heatmap-radius',
        jsonEncode([
          'interpolate',
          ['linear'],
          ['zoom'],
          5,
          14,
          10,
          28,
          14,
          40,
        ]),
      );

      // Fade out heatmap as you zoom in (individual pins take over)
      await map.style.setStyleLayerProperty(
        _heatmapLayerId,
        'heatmap-opacity',
        jsonEncode([
          'interpolate',
          ['linear'],
          ['zoom'],
          8,
          0.9,
          13,
          0.6,
          15,
          0.0,
        ]),
      );

      await map.style.setStyleLayerProperty(
        _heatmapLayerId,
        'heatmap-intensity',
        1.2,
      );

      _heatmapSource =
          await map.style.getSource(_heatmapSourceId) as GeoJsonSource?;
    } catch (e) {
      log('Error initialising heatmap', error: e);
    }
  }

  Future<void> _updateHeatmap(List<GeolocatedEventImage> images) async {
    final source = _heatmapSource;
    if (source == null) return;
    try {
      await source.updateGeoJSON(_buildHeatmapGeoJson(images));
    } catch (e) {
      log('Error updating heatmap', error: e);
    }
  }

  static String _buildHeatmapGeoJson(List<GeolocatedEventImage> images) {
    final features =
        images
            .map(
              (img) => {
                'type': 'Feature',
                'geometry': {
                  'type': 'Point',
                  'coordinates': [
                    img.position.longitude,
                    img.position.latitude,
                  ],
                },
                'properties': <String, dynamic>{},
              },
            )
            .toList();

    return jsonEncode({'type': 'FeatureCollection', 'features': features});
  }

  static const _emptyGeoJson = '{"type":"FeatureCollection","features":[]}';

  // ── Photo marker ───────────────────────────────────────────────────────────

  Future<void> _initPhotoMarker(MapboxMap map) async {
    if (!mounted) return;
    final scheme = Theme.of(context).colorScheme;
    final pointManager = await map.annotations.createPointAnnotationManager();
    final manager = PhotoMapMarkerManager(
      pointManager: pointManager,
      borderColor: scheme.secondary,
    );
    await manager.init();
    if (!mounted) return;
    setState(() => _markerManager = manager);
  }

  Future<void> _showMarkerFor(GeolocatedEventImage image) async {
    await _markerManager?.showAt(image);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventMapImagesBloc, EventMapImagesState>(
      listener: (context, state) {
        if (state is EventMapImagesLoaded && state.images.isNotEmpty) {
          _updateHeatmap(state.images);
          _fitAllImages(state.images);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            onPointerDown: (_) {
              _pointerDown = true;
              _interactionDispatched = false;
            },
            onPointerMove: (_) {
              if (_pointerDown && !_interactionDispatched) {
                _interactionDispatched = true;
                widget.onMapInteractionStart?.call();
              }
            },
            onPointerUp: (_) {
              _pointerDown = false;
              _interactionDispatched = false;
            },
            onPointerCancel: (_) {
              _pointerDown = false;
              _interactionDispatched = false;
            },
            child: MapWidget(
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              key: const ValueKey('mapWidget'),
              onMapCreated: _onMapCreated,
            ),
          ),
          AnimatedOpacity(
            opacity: _mapLoading ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: IgnorePointer(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
