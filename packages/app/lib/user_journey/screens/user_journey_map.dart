/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/types/geojson.dart';
import 'package:hollybike/shared/utils/waiter.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_action_icon.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';
import 'package:hollybike/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

part 'user_journey_map/models/user_journey_metric_layer.dart';
part 'user_journey_map/user_journey_map_metric_building.dart';
part 'user_journey_map/widgets/user_journey_map_metric_picker.dart';
part 'user_journey_map/widgets/user_journey_map_metric_legend.dart';

@RoutePage()
class UserJourneyMapScreen extends StatefulWidget {
  final String fileUrl;
  final String title;

  const UserJourneyMapScreen({
    super.key,
    required this.fileUrl,
    required this.title,
  });

  @override
  State<UserJourneyMapScreen> createState() => _UserJourneyMapScreenState();
}

class _UserJourneyMapScreenState extends State<UserJourneyMapScreen> {
  static const _topOverlayOffset = 62.0;
  static const _metricSourceId = 'track-metric-source';
  static const _metricLayerId = 'track-metric-layer';
  static const _defaultBucketColors = <int>[
    0xFF2DC4B2,
    0xFF3BB3C3,
    0xFF669EC4,
    0xFF8B88B6,
    0xFFA2719B,
    0xFFAA5E79,
    0xFFB44A57,
    0xFFD83A2E,
  ];
  static const _metricLabels = <String, String>{
    'speed': 'Vitesse',
    'accuracyM': 'Precision',
    'gpsSpeedMps': 'Vitesse GPS',
    'speedDeltaGpsMinusEkfMps': 'Ecart GPS-EKF',
    'ekfVxMps': 'EKF Vx',
    'ekfVyMps': 'EKF Vy',
    'ekfSpeedMps': 'Vitesse EKF',
    'headingDeg': 'Cap',
    'dtSeconds': 'Delta temps',
    'segmentDistanceM': 'Distance segment',
    'cumulativeDistanceM': 'Distance cumulee',
    'elevationDeltaM': 'Delta altitude',
    'cumulativeElevationGainM': 'Denivele positif',
    'cumulativeElevationLossM': 'Denivele negatif',
    'linearAccelerationMps2': 'Acceleration lineaire',
    'gForce': 'Force G',
    'jerkMps3': 'Jerk',
    'rawAltitude': 'Altitude',
    'rawLatitude': 'Latitude brute',
    'rawLongitude': 'Longitude brute',
    'smoothedLatitude': 'Latitude lissee',
    'smoothedLongitude': 'Longitude lissée',
  };
  static const _baseTraceColor = 0xFF3457D5;

  bool _mapLoading = true;
  bool _mapError = false;
  MapboxMap? _map;
  PolylineAnnotationManager? _trackAnnotationManager;
  PointAnnotationManager? _cursorAnnotationManager;
  PointAnnotation? _cursorAnnotation;
  Uint8List? _cursorMarkerImage;
  GeoJsonSource? _metricSource;
  List<_MetricLayer> _metricLayers = const [];
  List<List<double>> _trackCoordinates = const [];
  int? _selectedChartPointIndex;
  String? _selectedMetricKey;
  bool _metricsExpanded = true;
  int _chartSelectionRequestId = 0;

  @override
  Widget build(BuildContext context) {
    return Hud(
      appBar: TopBar(
        prefix: TopBarActionIcon(
          icon: Icons.arrow_back,
          onPressed: () => context.router.maybePop(),
        ),
        title: TopBarTitle(widget.title),
      ),
      body: SizedBox(
        child: Builder(
          builder: (context) {
            if (_mapError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Erreur lors du chargement de la carte"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.router.maybePop(),
                      child: const Text("Retour"),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: <Widget>[
                MapWidget(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  key: const ValueKey("mapWidget"),
                  onMapCreated: _onMapCreated,
                ),
                if (!_mapLoading && _metricLayers.isNotEmpty) ...[
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 24),
                      child: _MetricLegend(
                        metric: _selectedMetric,
                        metrics: _metricLayers,
                        selectedMetricKey: _selectedMetricKey,
                        onMetricChanged: _setSelectedMetric,
                        isExpanded: _metricsExpanded,
                        onToggleExpanded: _toggleMetricsExpanded,
                        selectedChartPointIndex: _selectedChartPointIndex,
                        onChartPointSelected: _setSelectedChartPointIndex,
                      ),
                    ),
                  ),
                ],
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
            );
          },
        ),
      ),
    );
  }

  _MetricLayer? get _selectedMetric {
    final selectedMetricKey = _selectedMetricKey;
    if (selectedMetricKey == null) {
      return null;
    }

    for (final metric in _metricLayers) {
      if (metric.key == selectedMetricKey) {
        return metric;
      }
    }

    return null;
  }

  void _onMapCreated(MapboxMap map) {
    _map = map;
    final isDark = BlocProvider.of<ThemeBloc>(context).state.isDark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    waitConcurrently(
          map.loadStyleURI(
            isDark
                ? "mapbox://styles/mapbox/navigation-night-v1"
                : "mapbox://styles/mapbox/navigation-day-v1",
          ),
          _getGeoJsonData(widget.fileUrl),
        )
        .then((values) async {
          final (_, geoJsonRaw) = values;
          final coordinates = _extractCoordinatesFromGeoJson(geoJsonRaw);
          final metrics = _buildMetricLayers(geoJsonRaw);
          final labelLayerId = await _resolveFirstTextSymbolLayerId(map);
          final buildingLayerPosition = _layerPositionBelow(labelLayerId);
          final initialMetric =
              metrics.isEmpty
                  ? null
                  : metrics.firstWhere(
                    (metric) => metric.key == 'speed',
                    orElse: () => metrics.first,
                  );

          await Future.wait([
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
              FillExtrusionLayer(
                id: '3d-buildings',
                sourceId: 'composite',
                sourceLayer: 'building',
                fillExtrusionColor: 0xFF515E72,
                fillExtrusionOpacity: 0.8,
                fillExtrusionHeightExpression: [
                  "interpolate",
                  ["linear"],
                  ["zoom"],
                  15,
                  0,
                  15.05,
                  ["get", "height"],
                ],
                fillExtrusionBaseExpression: [
                  "interpolate",
                  ["linear"],
                  ["zoom"],
                  15,
                  0,
                  15.05,
                  ["get", "min_height"],
                ],
              ),
              buildingLayerPosition,
            ),
            map.style.addSource(
              GeoJsonSource(
                id: _metricSourceId,
                data: _emptyFeatureCollection(),
                tolerance: 0,
                lineMetrics: true,
              ),
            ),
            map.style.addLayerAt(
              LineLayer(
                id: _metricLayerId,
                sourceId: _metricSourceId,
                lineJoin: LineJoin.ROUND,
                lineCap: LineCap.ROUND,
                lineWidth: 6,
                lineEmissiveStrength: 1,
                visibility:
                    initialMetric == null
                        ? Visibility.NONE
                        : Visibility.VISIBLE,
                lineGradientExpression:
                    initialMetric?.gradientExpression ?? _fallbackGradient(),
              ),
              _layerPositionBelow(labelLayerId),
            ),
          ]);

          _metricSource =
              await map.style.getSource(_metricSourceId) as GeoJsonSource?;

          _trackAnnotationManager ??= await map.annotations
              .createPolylineAnnotationManager(below: labelLayerId);
          _cursorAnnotationManager ??= await map.annotations
              .createPointAnnotationManager(below: labelLayerId);
          _cursorMarkerImage ??= await _buildCursorMarkerImage(primaryColor);
          await _cursorAnnotationManager!.setIconAllowOverlap(true);
          await _cursorAnnotationManager!.setIconIgnorePlacement(true);
          await _trackAnnotationManager!.setLineCap(LineCap.ROUND);
          await _refreshTraceAnnotations(
            coordinates: coordinates,
            metric: initialMetric,
          );

          final bbox = GeoJSON.fromJsonString(geoJsonRaw).dynamicBBox();

          final bounds = CoordinateBounds(
            southwest: Point(coordinates: Position(bbox[0], bbox[1])),
            northeast: Point(coordinates: Position(bbox[2], bbox[3])),
            infiniteBounds: false,
          );

          final cameraOptions = await map.cameraForCoordinateBounds(
            bounds,
            MbxEdgeInsets(top: 25, left: 50, right: 50, bottom: 75),
            null,
            30,
            null,
            null,
          );

          final cameraBounds = await map.coordinateBoundsForCamera(
            cameraOptions,
          );

          await map.setBounds(CameraBoundsOptions(bounds: cameraBounds));
          await map.setCamera(cameraOptions);

          await Future.delayed(const Duration(milliseconds: 100));

          if (!mounted) {
            return;
          }

          setState(() {
            _metricLayers = metrics;
            _trackCoordinates = coordinates;
            _selectedMetricKey = initialMetric?.key;
            _mapLoading = false;
          });

          await map.easeTo(
            CameraOptions(
              center: cameraOptions.center,
              zoom: (cameraOptions.zoom ?? 0) + 0.9,
              bearing: cameraOptions.bearing,
              pitch: cameraOptions.pitch,
            ),
            MapAnimationOptions(duration: 600),
          );
        })
        .catchError((e) {
          log('Error while loading map', error: e);
          if (!mounted) {
            return;
          }
          setState(() {
            _mapError = true;
          });
        });
  }

  Future<String?> _resolveFirstTextSymbolLayerId(MapboxMap map) async {
    final layers = await map.style.getStyleLayers();

    for (final layer in layers) {
      if (layer == null || layer.type != 'symbol') {
        continue;
      }

      try {
        final textField = await map.style.getStyleLayerProperty(
          layer.id,
          'text-field',
        );
        if (textField.value != null) {
          return layer.id;
        }
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  LayerPosition _layerPositionBelow(String? layerId) {
    if (layerId != null) {
      return LayerPosition(below: layerId);
    }

    return LayerPosition();
  }

  Future<String> _getGeoJsonData(String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    return response.body;
  }

  Future<void> _setSelectedMetric(String? metricKey) async {
    if (_selectedMetricKey == metricKey) {
      return;
    }

    final metric = _metricLayers.cast<_MetricLayer?>().firstWhere(
      (item) => item?.key == metricKey,
      orElse: () => null,
    );

    if (_map == null || _trackCoordinates.length < 2) {
      return;
    }

    await _refreshTraceAnnotations(
      coordinates: _trackCoordinates,
      metric: metric,
    );
    await _setSelectedChartPointIndex(null);

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedMetricKey = metricKey;
      if (metricKey == null) {
        _metricsExpanded = false;
      }
    });
  }

  void _toggleMetricsExpanded() {
    if (!mounted) {
      return;
    }

    setState(() {
      _metricsExpanded = !_metricsExpanded;
    });
  }

  Future<void> _refreshTraceAnnotations({
    required List<List<double>> coordinates,
    required _MetricLayer? metric,
  }) async {
    final trackAnnotationManager = _trackAnnotationManager;
    final metricSource = _metricSource;
    final map = _map;
    if (trackAnnotationManager == null || metricSource == null || map == null) {
      return;
    }

    await trackAnnotationManager.deleteAll();

    await trackAnnotationManager.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: _toPositions(coordinates)),
        lineColor: _baseTraceColor,
        lineJoin: LineJoin.ROUND,
        lineWidth: 5,
        lineOpacity: metric == null ? 1 : 0,
        lineEmissiveStrength: 1,
      ),
    );

    await metricSource.updateGeoJSON(
      metric?.gradientSourceData ?? _emptyFeatureCollection(),
    );
    await map.style.setStyleLayerProperty(
      _metricLayerId,
      'visibility',
      metric == null ? 'none' : 'visible',
    );
    if (metric != null) {
      await map.style.setStyleLayerProperty(
        _metricLayerId,
        'line-gradient',
        metric.gradientExpression,
      );
    }
  }

  Future<void> _setSelectedChartPointIndex(int? chartPointIndex) async {
    final requestId = ++_chartSelectionRequestId;
    final metric = _selectedMetric;
    final cursorAnnotationManager = _cursorAnnotationManager;
    final cursorMarkerImage = _cursorMarkerImage;
    if (metric == null ||
        cursorAnnotationManager == null ||
        cursorMarkerImage == null) {
      return;
    }

    if (chartPointIndex == null ||
        chartPointIndex < 0 ||
        chartPointIndex >= metric.chartCoordinateIndices.length) {
      final cursorAnnotation = _cursorAnnotation;
      if (cursorAnnotation != null) {
        _cursorAnnotation = null;
        await cursorAnnotationManager.delete(cursorAnnotation);
        if (requestId != _chartSelectionRequestId) {
          return;
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedChartPointIndex = null;
      });
      return;
    }

    final coordinateIndex = metric.chartCoordinateIndices[chartPointIndex];
    if (coordinateIndex < 0 || coordinateIndex >= _trackCoordinates.length) {
      return;
    }

    final coordinate = _trackCoordinates[coordinateIndex];
    final point = Point(coordinates: Position(coordinate[0], coordinate[1]));
    final existingCursorAnnotation = _cursorAnnotation;
    if (existingCursorAnnotation == null) {
      final createdAnnotation = await cursorAnnotationManager.create(
        PointAnnotationOptions(
          geometry: point,
          image: cursorMarkerImage,
          iconSize: 1,
        ),
      );
      if (requestId != _chartSelectionRequestId) {
        await cursorAnnotationManager.delete(createdAnnotation);
        return;
      }
      _cursorAnnotation = createdAnnotation;
    } else {
      try {
        existingCursorAnnotation.geometry = point;
        await cursorAnnotationManager.update(existingCursorAnnotation);
        if (requestId != _chartSelectionRequestId) {
          return;
        }
      } catch (_) {
        final recreatedAnnotation = await cursorAnnotationManager.create(
          PointAnnotationOptions(
            geometry: point,
            image: cursorMarkerImage,
            iconSize: 1,
          ),
        );
        if (requestId != _chartSelectionRequestId) {
          await cursorAnnotationManager.delete(recreatedAnnotation);
          return;
        }
        _cursorAnnotation = recreatedAnnotation;
      }
    }

    await _followCursorIfNeeded(point);
    if (requestId != _chartSelectionRequestId) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedChartPointIndex = chartPointIndex;
    });
  }

  Future<Uint8List> _buildCursorMarkerImage(Color primaryColor) async {
    const size = 56.0;
    const outerRadius = 14.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = const ui.Offset(size / 2, size / 2);

    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = const Color(0xFFFFFFFF),
    );

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

  Future<void> _followCursorIfNeeded(Point point) async {
    final map = _map;
    if (map == null || !mounted) {
      return;
    }

    final screenSize = MediaQuery.sizeOf(context);
    final pixel = await map.pixelForCoordinate(point);
    final leftInset = 24.0;
    final rightInset = 180.0;
    final topInset = _topOverlayOffset + 36;
    final bottomInset = 240.0;
    final isVisible =
        pixel.x >= leftInset &&
        pixel.x <= (screenSize.width - rightInset) &&
        pixel.y >= topInset &&
        pixel.y <= (screenSize.height - bottomInset);

    if (isVisible) {
      return;
    }

    final cameraState = await map.getCameraState();
    await map.easeTo(
      CameraOptions(
        center: point,
        zoom: cameraState.zoom,
        bearing: cameraState.bearing,
        pitch: cameraState.pitch,
        padding: cameraState.padding,
      ),
      MapAnimationOptions(duration: 180),
    );
  }
}
