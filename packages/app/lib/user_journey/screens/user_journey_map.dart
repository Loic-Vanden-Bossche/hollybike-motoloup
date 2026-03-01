/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

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

          _metricSource = await map.style.getSource(_metricSourceId) as GeoJsonSource?;

          _trackAnnotationManager ??=
              await map.annotations.createPolylineAnnotationManager(
                below: labelLayerId,
              );
          _cursorAnnotationManager ??=
              await map.annotations.createPointAnnotationManager(
                below: labelLayerId,
              );
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
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final center = const Offset(size / 2, size / 2);

    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = const Color(0xFFFFFFFF),
    );

    final image = await recorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final bytes = await image.toByteData(format: ImageByteFormat.png);
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

  String _styleColor(int color) {
    final rgb = color & 0x00FFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  List<_MetricLayer> _buildMetricLayers(String geoJsonRaw) {
    final decoded = jsonDecode(geoJsonRaw);
    final root =
        decoded is Map<String, dynamic>
            ? decoded
            : Map<String, dynamic>.from(decoded as Map);
    final feature = _extractFeature(root);
    if (feature == null) {
      return const [];
    }

    final geometry = _asMap(feature['geometry']);
    final properties = _asMap(feature['properties']);

    if (geometry == null || properties == null) {
      return const [];
    }

    final coordinates = _parseCoordinates(geometry['coordinates']);
    if (coordinates.length < 2) {
      return const [];
    }

    final timeValues = _buildTimeValues(properties, coordinates.length);

    final metrics = <_MetricLayer>[];
    for (final entry in properties.entries) {
      final values = _parseNumericArray(entry.value);
      if (values == null) {
        continue;
      }

      final metric = _buildMetricLayer(
        key: entry.key,
        values: values,
        coordinates: coordinates,
        timeValues: timeValues,
      );

      if (metric != null) {
        metrics.add(metric);
      }
    }

    metrics.sort((a, b) => a.label.compareTo(b.label));
    return metrics;
  }

  List<List<double>> _extractCoordinatesFromGeoJson(String geoJsonRaw) {
    final decoded = jsonDecode(geoJsonRaw);
    final root =
        decoded is Map<String, dynamic>
            ? decoded
            : Map<String, dynamic>.from(decoded as Map);
    final feature = _extractFeature(root);
    final geometry = feature == null ? null : _asMap(feature['geometry']);
    if (geometry == null) {
      return const [];
    }

    return _parseCoordinates(geometry['coordinates']);
  }

  Map<String, dynamic>? _extractFeature(Map<String, dynamic> root) {
    final type = root['type'];
    if (type == 'Feature') {
      return root;
    }

    if (type == 'FeatureCollection') {
      final features = root['features'];
      if (features is List && features.isNotEmpty) {
        return _asMap(features.first);
      }
    }

    return null;
  }

  _MetricLayer? _buildMetricLayer({
    required String key,
    required List<double> values,
    required List<List<double>> coordinates,
    required List<double> timeValues,
  }) {
    final palette = _paletteForMetric(key);
    final segmentCount = coordinates.length - 1;
    if (segmentCount <= 0) {
      return null;
    }

    final supportsPointAlignedValues = values.length >= coordinates.length;
    final supportsSegmentAlignedValues = values.length >= segmentCount;

    if (!supportsPointAlignedValues && !supportsSegmentAlignedValues) {
      return null;
    }

    final segmentValues = <double>[];
    for (var index = 0; index < segmentCount; index++) {
      final valueIndex =
          supportsPointAlignedValues
              ? index + 1
              : math.min(index, values.length - 1);
      final value = values[valueIndex];
      if (value.isFinite) {
        segmentValues.add(value);
      }
    }

    if (segmentValues.isEmpty) {
      return null;
    }

    var minValue = segmentValues.first;
    var maxValue = segmentValues.first;
    for (final value in segmentValues.skip(1)) {
      if (value < minValue) {
        minValue = value;
      }
      if (value > maxValue) {
        maxValue = value;
      }
    }

    final features = <Map<String, dynamic>>[];
    for (var index = 0; index < segmentCount; index++) {
      final valueIndex =
          supportsPointAlignedValues
              ? index + 1
              : math.min(index, values.length - 1);
      final value = values[valueIndex];
      if (!value.isFinite) {
        continue;
      }

      final startValueIndex =
          supportsPointAlignedValues
              ? index
              : math.max(0, math.min(index - 1, values.length - 1));
      final startValue = values[startValueIndex];
      final startMetricValue = startValue.isFinite ? startValue : value;
      features.addAll(
        _buildGradientFeatures(
          start: coordinates[index],
          end: coordinates[index + 1],
          startValue: startMetricValue,
          endValue: value,
          metricKey: key,
          metricValue: value,
          minValue: minValue,
          maxValue: maxValue,
          palette: palette,
        ),
      );
    }

    if (features.isEmpty) {
      return null;
    }

    return _MetricLayer(
      key: key,
      label: _metricLabels[key] ?? _prettifyMetricKey(key),
      minValue: minValue,
      maxValue: maxValue,
      chartSpots: _buildChartSpots(
        values: values,
        timeValues: timeValues,
        pointCount: coordinates.length,
        supportsPointAlignedValues: supportsPointAlignedValues,
      ),
      chartCoordinateIndices: _buildChartCoordinateIndices(
        values: values,
        timeValues: timeValues,
        pointCount: coordinates.length,
        supportsPointAlignedValues: supportsPointAlignedValues,
      ),
      chartMaxX: timeValues.isEmpty ? 0 : timeValues.last,
      gradientExpression: _buildMetricGradientExpression(
        coordinates: coordinates,
        values: values,
        minValue: minValue,
        maxValue: maxValue,
        supportsPointAlignedValues: supportsPointAlignedValues,
        palette: palette,
      ),
      paletteColors: palette,
      gradientSourceData: jsonEncode({
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': {'metricKey': key},
            'geometry': {
              'type': 'LineString',
              'coordinates': coordinates,
            },
          },
        ],
      }),
    );
  }

  List<double> _buildTimeValues(
    Map<String, dynamic> properties,
    int pointCount,
  ) {
    final rawDtSeconds = _parseNumericArray(properties['dtSeconds']);
    if (rawDtSeconds == null || rawDtSeconds.isEmpty) {
      return List<double>.generate(pointCount, (index) => index.toDouble());
    }

    final times = <double>[0];
    var total = 0.0;
    final targetCount = math.max(1, pointCount - 1);
    for (var index = 0; index < targetCount; index++) {
      final dt = rawDtSeconds[math.min(index, rawDtSeconds.length - 1)];
      total += dt.isFinite ? math.max(0, dt) : 0;
      times.add(total);
    }

    while (times.length < pointCount) {
      times.add(times.isEmpty ? 0 : times.last);
    }

    return times;
  }

  int _bucketIndexForPalette(
    double value,
    double minValue,
    double maxValue,
    List<int> palette,
  ) {
    if (maxValue <= minValue) {
      return 0;
    }

    final normalized = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );
    final bucket = (normalized * (palette.length - 1)).floor();
    return bucket.clamp(0, palette.length - 1);
  }

  List<Map<String, dynamic>> _buildGradientFeatures({
    required List<double> start,
    required List<double> end,
    required double startValue,
    required double endValue,
    required String metricKey,
    required double metricValue,
    required double minValue,
    required double maxValue,
    required List<int> palette,
  }) {
    const subdivisions = 6;
    final features = <Map<String, dynamic>>[];

    for (var index = 0; index < subdivisions; index++) {
      final t0 = index / subdivisions;
      final t1 = (index + 1) / subdivisions;
      final subStart = _interpolateCoordinate(start, end, t0);
      final subEnd = _interpolateCoordinate(start, end, t1);
      final subValue = startValue + ((endValue - startValue) * ((t0 + t1) / 2));

      features.add({
        'type': 'Feature',
        'properties': {
          'metricKey': metricKey,
          'metricValue': metricValue,
          'bucket': _bucketIndexForPalette(subValue, minValue, maxValue, palette),
          'color': _interpolatedMetricColor(
            subValue,
            minValue,
            maxValue,
            palette,
          ),
        },
        'geometry': {
          'type': 'LineString',
          'coordinates': [subStart, subEnd],
        },
      });
    }

    return features;
  }

  List<double> _interpolateCoordinate(
    List<double> start,
    List<double> end,
    double t,
  ) {
    return <double>[
      start[0] + ((end[0] - start[0]) * t),
      start[1] + ((end[1] - start[1]) * t),
    ];
  }

  String _interpolatedMetricColor(
    double value,
    double minValue,
    double maxValue,
    List<int> palette,
  ) {
    if (maxValue <= minValue) {
      return _styleColor(palette.first);
    }

    final normalized = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );
    final scaled = normalized * (palette.length - 1);
    final lowerIndex = scaled.floor().clamp(0, palette.length - 1);
    final upperIndex = scaled.ceil().clamp(0, palette.length - 1);
    final t = scaled - lowerIndex;

    final lowerColor = palette[lowerIndex];
    final upperColor = palette[upperIndex];

    final lowerRed = (lowerColor >> 16) & 0xFF;
    final lowerGreen = (lowerColor >> 8) & 0xFF;
    final lowerBlue = lowerColor & 0xFF;

    final upperRed = (upperColor >> 16) & 0xFF;
    final upperGreen = (upperColor >> 8) & 0xFF;
    final upperBlue = upperColor & 0xFF;

    final red = (lowerRed + ((upperRed - lowerRed) * t)).round();
    final green = (lowerGreen + ((upperGreen - lowerGreen) * t)).round();
    final blue = (lowerBlue + ((upperBlue - lowerBlue) * t)).round();

    return _styleColor((red << 16) | (green << 8) | blue);
  }

  List<Object> _buildMetricGradientExpression({
    required List<List<double>> coordinates,
    required List<double> values,
    required double minValue,
    required double maxValue,
    required bool supportsPointAlignedValues,
    required List<int> palette,
  }) {
    final pointValues = <double>[];
    for (var index = 0; index < coordinates.length; index++) {
      final valueIndex =
          supportsPointAlignedValues
              ? index
              : math.min(index, values.length - 1);
      pointValues.add(values[valueIndex]);
    }

    final progressStops = _buildLineProgressStops(coordinates);
    final expression = <Object>[
      'interpolate',
      ['linear'],
      ['line-progress'],
    ];

    for (var index = 0; index < progressStops.length; index++) {
      final value = pointValues[index];
      expression.add(progressStops[index]);
      expression.add(
        _interpolatedMetricColor(value, minValue, maxValue, palette),
      );
    }

    return expression;
  }

  List<double> _buildLineProgressStops(List<List<double>> coordinates) {
    if (coordinates.length < 2) {
      return const [0, 1];
    }

    final cumulative = <double>[0];
    var totalDistance = 0.0;
    for (var index = 1; index < coordinates.length; index++) {
      totalDistance += _coordinateDistance(
        coordinates[index - 1],
        coordinates[index],
      );
      cumulative.add(totalDistance);
    }

    if (totalDistance <= 0) {
      return List<double>.generate(
        coordinates.length,
        (index) => index == coordinates.length - 1 ? 1 : 0,
      );
    }

    return cumulative.map((value) => value / totalDistance).toList();
  }

  double _coordinateDistance(List<double> start, List<double> end) {
    final dx = end[0] - start[0];
    final dy = end[1] - start[1];
    return math.sqrt((dx * dx) + (dy * dy));
  }

  String _emptyFeatureCollection() {
    return jsonEncode({'type': 'FeatureCollection', 'features': const []});
  }

  List<Object> _fallbackGradient() {
    final color = _styleColor(_defaultBucketColors.first);
    return <Object>[
      'interpolate',
      ['linear'],
      ['line-progress'],
      0,
      color,
      1,
      color,
    ];
  }

  List<int> _paletteForMetric(String key) {
    switch (key) {
      case 'speed':
      case 'gpsSpeedMps':
      case 'ekfSpeedMps':
        return const [
          0xFF2DC4B2,
          0xFF3BB3C3,
          0xFF669EC4,
          0xFF8B88B6,
          0xFFA2719B,
          0xFFAA5E79,
          0xFFB44A57,
          0xFFD83A2E,
        ];
      case 'rawAltitude':
        return const [
          0xFF1B4332,
          0xFF2D6A4F,
          0xFF40916C,
          0xFF74C69D,
          0xFFB7E4C7,
          0xFFE9C46A,
          0xFFBC6C25,
          0xFFF8F9FA,
        ];
      case 'gForce':
        return const [
          0xFFFEF3C7,
          0xFFFDE68A,
          0xFFFBBF24,
          0xFFF59E0B,
          0xFFF97316,
          0xFFEF4444,
          0xFFDC2626,
          0xFF991B1B,
        ];
      case 'cumulativeElevationGainM':
        return const [
          0xFFE8F5E9,
          0xFFC8E6C9,
          0xFFA5D6A7,
          0xFF81C784,
          0xFF66BB6A,
          0xFF43A047,
          0xFF2E7D32,
          0xFF1B5E20,
        ];
      case 'cumulativeElevationLossM':
        return const [
          0xFFE3F2FD,
          0xFFBBDEFB,
          0xFF90CAF9,
          0xFF64B5F6,
          0xFF42A5F5,
          0xFF1E88E5,
          0xFF1565C0,
          0xFF0D47A1,
        ];
      case 'linearAccelerationMps2':
        return const [
          0xFFF3E8FF,
          0xFFE9D5FF,
          0xFFD8B4FE,
          0xFFC084FC,
          0xFFA855F7,
          0xFF9333EA,
          0xFF7E22CE,
          0xFF581C87,
        ];
      default:
        return _defaultBucketColors;
    }
  }

  List<FlSpot> _buildChartSpots({
    required List<double> values,
    required List<double> timeValues,
    required int pointCount,
    required bool supportsPointAlignedValues,
  }) {
    if (timeValues.isEmpty || pointCount <= 0) {
      return const [];
    }

    final spots = <FlSpot>[];
    final count =
        supportsPointAlignedValues
            ? math.min(pointCount, values.length)
            : math.min(pointCount - 1, values.length);

    for (var index = 0; index < count; index++) {
      final valueIndex =
          supportsPointAlignedValues ? index : math.min(index, values.length - 1);
      final xIndex =
          supportsPointAlignedValues ? index : math.min(index + 1, timeValues.length - 1);
      final value = values[valueIndex];
      if (!value.isFinite) {
        continue;
      }

      spots.add(FlSpot(timeValues[xIndex], value));
    }

    return spots;
  }

  List<int> _buildChartCoordinateIndices({
    required List<double> values,
    required List<double> timeValues,
    required int pointCount,
    required bool supportsPointAlignedValues,
  }) {
    if (timeValues.isEmpty || pointCount <= 0) {
      return const [];
    }

    final coordinateIndices = <int>[];
    final count =
        supportsPointAlignedValues
            ? math.min(pointCount, values.length)
            : math.min(pointCount - 1, values.length);

    for (var index = 0; index < count; index++) {
      final valueIndex =
          supportsPointAlignedValues ? index : math.min(index, values.length - 1);
      final xIndex =
          supportsPointAlignedValues ? index : math.min(index + 1, timeValues.length - 1);
      final value = values[valueIndex];
      if (!value.isFinite) {
        continue;
      }

      coordinateIndices.add(xIndex);
    }

    return coordinateIndices;
  }

  List<List<double>> _parseCoordinates(dynamic rawCoordinates) {
    if (rawCoordinates is! List) {
      return const [];
    }

    final coordinates = <List<double>>[];
    for (final coordinate in rawCoordinates) {
      if (coordinate is! List || coordinate.length < 2) {
        continue;
      }

      final longitude = _toDouble(coordinate[0]);
      final latitude = _toDouble(coordinate[1]);
      if (longitude == null || latitude == null) {
        continue;
      }

      coordinates.add([longitude, latitude]);
    }
    return coordinates;
  }

  List<double>? _parseNumericArray(dynamic rawValues) {
    if (rawValues is! List || rawValues.length < 2) {
      return null;
    }

    final values = <double>[];
    for (final rawValue in rawValues) {
      final value = _toDouble(rawValue);
      if (value == null) {
        return null;
      }
      values.add(value);
    }

    return values;
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return null;
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  List<Position> _toPositions(List<List<double>> coordinates) {
    return coordinates
        .map((coordinate) => Position(coordinate[0], coordinate[1]))
        .toList();
  }

  String _prettifyMetricKey(String key) {
    final buffer = StringBuffer();
    for (var index = 0; index < key.length; index++) {
      final char = key[index];
      final isUpperCase =
          char.toUpperCase() == char && char.toLowerCase() != char;
      if (index == 0) {
        buffer.write(char.toUpperCase());
        continue;
      }

      if (isUpperCase) {
        buffer.write(' ');
      }
      buffer.write(char);
    }

    return buffer.toString();
  }
}

class _MetricPicker extends StatelessWidget {
  static const _primaryMetricKeys = <String>{
    'rawAltitude',
    'cumulativeElevationGainM',
    'cumulativeElevationLossM',
    'speed',
    'gForce',
  };
  static const _moreOptionValue = '__more_metrics__';

  final String? selectedMetricKey;
  final List<_MetricLayer> metrics;
  final ValueChanged<String?> onChanged;

  const _MetricPicker({
    required this.selectedMetricKey,
    required this.metrics,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryMetrics =
        metrics
            .where((metric) => _primaryMetricKeys.contains(metric.key))
            .toList();
    final hiddenMetrics =
        metrics
            .where((metric) => !_primaryMetricKeys.contains(metric.key))
            .toList();
    final selectedHiddenMetric =
        hiddenMetrics.cast<_MetricLayer?>().firstWhere(
          (metric) => metric?.key == selectedMetricKey,
          orElse: () => null,
        );
    final dropdownMetrics = [
      ...primaryMetrics,
      if (selectedHiddenMetric != null) selectedHiddenMetric,
    ];

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(canvasColor: Theme.of(context).colorScheme.primary),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value:
              selectedMetricKey == null ||
                      dropdownMetrics.any(
                        (metric) => metric.key == selectedMetricKey,
                      )
                  ? selectedMetricKey
                  : null,
          isExpanded: true,
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Theme.of(context).colorScheme.primary,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.92),
            fontWeight: FontWeight.w700,
          ),
          iconEnabledColor: Theme.of(
            context,
          ).colorScheme.onPrimary.withValues(alpha: 0.88),
          hint: Text(
            'Couche metrique',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.88),
            ),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: _MetricOptionLabel(
                label: 'Trace de base',
                paletteColors: [_UserJourneyMapScreenState._baseTraceColor],
              ),
            ),
            ...dropdownMetrics.map(
              (metric) => DropdownMenuItem<String?>(
                value: metric.key,
                child: _MetricOptionLabel(
                  label: metric.label,
                  paletteColors: metric.paletteColors,
                ),
              ),
            ),
            if (hiddenMetrics.isNotEmpty)
              const DropdownMenuItem<String?>(
                value: _moreOptionValue,
                child: Text('Plus...'),
              ),
          ],
          onChanged: (value) async {
            if (value != _moreOptionValue) {
              onChanged(value);
              return;
            }

            final selectedMetric = await showModalBottomSheet<String>(
              context: context,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder:
                  (context) => SafeArea(
                    top: false,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Text(
                            'Plus de metriques',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        ...hiddenMetrics.map(
                          (metric) => ListTile(
                            title: Text(
                              metric.label,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight:
                                        selectedMetricKey == metric.key
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                  ),
                            ),
                            onTap: () => Navigator.of(context).pop(metric.key),
                          ),
                        ),
                      ],
                    ),
                  ),
            );

            if (selectedMetric != null) {
              onChanged(selectedMetric);
            }
          },
          selectedItemBuilder:
              (context) => [
                const _MetricOptionLabel(
                  label: 'Trace de base',
                  paletteColors: [_UserJourneyMapScreenState._baseTraceColor],
                  selected: true,
                ),
                ...dropdownMetrics.map(
                  (metric) => _MetricOptionLabel(
                    label: metric.label,
                    paletteColors: metric.paletteColors,
                    selected: true,
                  ),
                ),
                if (hiddenMetrics.isNotEmpty)
                  const _MetricOptionLabel(
                    label: 'Plus...',
                    selected: true,
                  ),
              ],
        ),
      ),
    );
  }
}

class _MetricOptionLabel extends StatelessWidget {
  final String label;
  final List<int>? paletteColors;
  final bool selected;

  const _MetricOptionLabel({
    required this.label,
    this.paletteColors,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (paletteColors != null) ...[
          _MetricPalettePreview(colors: paletteColors!),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: selected ? FontWeight.w700 : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricPalettePreview extends StatelessWidget {
  final List<int> colors;

  const _MetricPalettePreview({required this.colors});

  @override
  Widget build(BuildContext context) {
    final palette = colors.isEmpty ? const [0xFFFFFFFF] : colors;
    return Container(
      width: 32,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: palette.map((color) => Color(color)).toList(),
        ),
      ),
    );
  }
}

class _MetricLegend extends StatelessWidget {
  final _MetricLayer? metric;
  final List<_MetricLayer> metrics;
  final String? selectedMetricKey;
  final ValueChanged<String?> onMetricChanged;
  final int? selectedChartPointIndex;
  final ValueChanged<int?> onChartPointSelected;

  const _MetricLegend({
    required this.metric,
    required this.metrics,
    required this.selectedMetricKey,
    required this.onMetricChanged,
    required this.selectedChartPointIndex,
    required this.onChartPointSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricPicker(
            selectedMetricKey: selectedMetricKey,
            metrics: metrics,
            onChanged: onMetricChanged,
          ),
          if (metric != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: metric!.paletteColors
                      .map((color) => Color(color))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatMetricValue(metric!.key, metric!.minValue),
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.82),
                  ),
                ),
                Text(
                  _formatMetricValue(metric!.key, metric!.maxValue),
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 150,
              child: _MetricChart(
                metric: metric!,
                selectedChartPointIndex: selectedChartPointIndex,
                onPointSelected: onChartPointSelected,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMetricValue(String key, double value) {
    switch (key) {
      case 'speed':
      case 'gpsSpeedMps':
      case 'speedDeltaGpsMinusEkfMps':
      case 'ekfVxMps':
      case 'ekfVyMps':
      case 'ekfSpeedMps':
        return _formatSpeed(value);
      case 'accuracyM':
      case 'segmentDistanceM':
      case 'cumulativeDistanceM':
      case 'elevationDeltaM':
      case 'cumulativeElevationGainM':
      case 'cumulativeElevationLossM':
      case 'rawAltitude':
        return _formatDistance(value);
      case 'headingDeg':
        return '${_formatNumber(value, decimals: value.abs() >= 100 ? 0 : 1)}°';
      case 'dtSeconds':
        return _formatDuration(value);
      case 'linearAccelerationMps2':
        return '${_formatNumber(value)} m/s²';
      case 'jerkMps3':
        return '${_formatNumber(value)} m/s³';
      case 'gForce':
        return '${_formatNumber(value)} G';
      case 'rawLatitude':
      case 'rawLongitude':
      case 'smoothedLatitude':
      case 'smoothedLongitude':
        return '${value.toStringAsFixed(5)}°';
      default:
        return _formatNumber(value);
    }
  }

  String _formatSpeed(double value) {
    return '${_formatNumber(value * 3.6)} km/h';
  }

  String _formatDistance(double value) {
    final absoluteValue = value.abs();
    if (absoluteValue >= 1000) {
      return '${_formatNumber(value / 1000, decimals: 1)} km';
    }

    return '${_formatNumber(value, decimals: absoluteValue >= 100 ? 0 : 1)} m';
  }

  String _formatDuration(double value) {
    final absoluteValue = value.abs();
    if (absoluteValue >= 3600) {
      return '${_formatNumber(value / 3600, decimals: 1)} h';
    }

    if (absoluteValue >= 60) {
      return '${_formatNumber(value / 60, decimals: 1)} min';
    }

    return '${_formatNumber(value, decimals: absoluteValue >= 10 ? 0 : 1)} s';
  }

  String _formatNumber(double value, {int? decimals}) {
    final resolvedDecimals =
        decimals ??
        (value.abs() >= 100
            ? 0
            : value.abs() >= 10
            ? 1
            : 2);
    var formatted = value.toStringAsFixed(resolvedDecimals);

    if (formatted.contains('.')) {
      formatted = formatted.replaceFirst(RegExp(r'\.?0+$'), '');
    }

    return formatted;
  }
}

class _MetricChart extends StatelessWidget {
  final _MetricLayer metric;
  final int? selectedChartPointIndex;
  final ValueChanged<int?> onPointSelected;

  const _MetricChart({
    required this.metric,
    required this.selectedChartPointIndex,
    required this.onPointSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final spots = metric.chartSpots;
    if (spots.length < 2) {
      return Center(
        child: Text(
          'Pas assez de donnees pour le graphe',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: scheme.onPrimary.withValues(alpha: 0.72),
          ),
        ),
      );
    }

    final minX = spots.first.x;
    final maxX = metric.chartMaxX <= minX ? spots.last.x : metric.chartMaxX;
    final minY = spots
        .map((spot) => spot.y)
        .reduce((value, element) => math.min(value, element));
    final maxY = spots
        .map((spot) => spot.y)
        .reduce((value, element) => math.max(value, element));
    final yPadding = minY == maxY ? math.max(1, minY.abs() * 0.1) : (maxY - minY) * 0.12;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY).abs() <= 0 ? 1 : (maxY - minY).abs() / 4,
          getDrawingHorizontalLine:
              (_) => FlLine(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                strokeWidth: 1,
              ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: (maxY - minY).abs() <= 0 ? 1 : (maxY - minY).abs() / 2,
              getTitlesWidget:
                  (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      _formatAxisValue(metric.key, value),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: maxX <= minX ? 1 : (maxX - minX) / 2,
              getTitlesWidget:
                  (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _formatTimeAxis(value),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions) {
              onPointSelected(null);
              return;
            }

            final lineBarSpots = response?.lineBarSpots;
            if (lineBarSpots == null || lineBarSpots.isEmpty) {
              onPointSelected(null);
              return;
            }

            onPointSelected(lineBarSpots.first.spotIndex);
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => scheme.primary.withValues(alpha: 0.94),
            getTooltipItems:
                (touchedSpots) =>
                    touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${_formatTimeAxis(spot.x)}\n${_formatAxisValue(metric.key, spot.y)}',
                        Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: scheme.onPrimary,
                        ),
                      );
                    }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            showingIndicators:
                selectedChartPointIndex == null ? const [] : [selectedChartPointIndex!],
            isCurved: true,
            curveSmoothness: 0.18,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: metric.paletteColors
                  .map((color) => Color(color))
                  .toList(),
            ),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(metric.paletteColors.last).withValues(alpha: 0.22),
                  Color(metric.paletteColors.first).withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAxisValue(String key, double value) {
    switch (key) {
      case 'speed':
      case 'gpsSpeedMps':
      case 'speedDeltaGpsMinusEkfMps':
      case 'ekfVxMps':
      case 'ekfVyMps':
      case 'ekfSpeedMps':
        return '${_formatNumber(value * 3.6)} km/h';
      case 'accuracyM':
      case 'segmentDistanceM':
      case 'cumulativeDistanceM':
      case 'elevationDeltaM':
      case 'cumulativeElevationGainM':
      case 'cumulativeElevationLossM':
      case 'rawAltitude':
        return value.abs() >= 1000
            ? '${_formatNumber(value / 1000, decimals: 1)} km'
            : '${_formatNumber(value, decimals: value.abs() >= 100 ? 0 : 1)} m';
      case 'headingDeg':
        return '${_formatNumber(value, decimals: 0)}°';
      case 'linearAccelerationMps2':
        return '${_formatNumber(value)} m/s²';
      case 'jerkMps3':
        return '${_formatNumber(value)} m/s³';
      case 'gForce':
        return '${_formatNumber(value)} G';
      default:
        return _formatNumber(value);
    }
  }

  String _formatTimeAxis(double seconds) {
    final absoluteSeconds = seconds.abs();
    if (absoluteSeconds >= 3600) {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds.abs() % 3600) / 60).round();
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    }

    if (absoluteSeconds >= 60) {
      final minutes = (seconds / 60).floor();
      final remainingSeconds = (seconds.abs() % 60).round();
      return '${minutes}m${remainingSeconds.toString().padLeft(2, '0')}';
    }

    return '${seconds.round()}s';
  }

  String _formatNumber(double value, {int? decimals}) {
    final resolvedDecimals =
        decimals ??
        (value.abs() >= 100
            ? 0
            : value.abs() >= 10
            ? 1
            : 2);
    var formatted = value.toStringAsFixed(resolvedDecimals);
    if (formatted.contains('.')) {
      formatted = formatted.replaceFirst(RegExp(r'\.?0+$'), '');
    }
    return formatted;
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const _GlassPanel({
    required this.child,
    required this.padding,
    this.borderRadius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary.withValues(alpha: 0.66),
                scheme.primary.withValues(alpha: 0.52),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: scheme.onPrimary.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 22,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _MetricLayer {
  final String key;
  final String label;
  final double minValue;
  final double maxValue;
  final List<int> paletteColors;
  final List<FlSpot> chartSpots;
  final List<int> chartCoordinateIndices;
  final double chartMaxX;
  final List<Object> gradientExpression;
  final String gradientSourceData;

  const _MetricLayer({
    required this.key,
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.paletteColors,
    required this.chartSpots,
    required this.chartCoordinateIndices,
    required this.chartMaxX,
    required this.gradientExpression,
    required this.gradientSourceData,
  });
}
