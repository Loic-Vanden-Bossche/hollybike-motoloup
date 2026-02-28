/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
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
  static const _tracksSourceId = 'tracks';
  static const _tracksLayerId = 'tracks-layer';
  static const _metricSourceId = 'track-metric-segments';
  static const _metricLayerId = 'track-metric-layer';
  static const _bucketColors = <int>[
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

  bool _mapLoading = true;
  bool _mapError = false;
  MapboxMap? _map;
  GeoJsonSource? _metricSource;
  List<_MetricLayer> _metricLayers = const [];
  String? _selectedMetricKey;

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
                    top: 0,
                    right: 16,
                    child: SafeArea(
                      minimum: const EdgeInsets.only(top: _topOverlayOffset),
                      child: _MetricPicker(
                        selectedMetricKey: _selectedMetricKey,
                        metrics: _metricLayers,
                        onChanged: _setSelectedMetric,
                      ),
                    ),
                  ),
                  if (_selectedMetric != null)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        minimum: const EdgeInsets.only(bottom: 24),
                        child: _MetricLegend(metric: _selectedMetric!),
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
          final metrics = _buildMetricLayers(geoJsonRaw);
          final initialMetric =
              metrics.isEmpty
                  ? null
                  : metrics.firstWhere(
                    (metric) => metric.key == 'speed',
                    orElse: () => metrics.first,
                  );

          final metricSource = GeoJsonSource(
            id: _metricSourceId,
            data:
                initialMetric?.sourceData ??
                jsonEncode({'type': 'FeatureCollection', 'features': const []}),
          );

          _metricSource = metricSource;

          await Future.wait([
            map.style.addSource(
              GeoJsonSource(id: _tracksSourceId, data: geoJsonRaw),
            ),
            map.style.addSource(metricSource),
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
                id: _tracksLayerId,
                sourceId: _tracksSourceId,
                lineJoin: LineJoin.ROUND,
                lineCap: LineCap.ROUND,
                lineColor: 0xFF3457D5,
                lineOpacity: metrics.isEmpty ? 1 : 0.35,
                lineWidth: metrics.isEmpty ? 5 : 4,
                lineEmissiveStrength: 1,
              ),
              LayerPosition(above: 'traffic-bridge-road-link-navigation'),
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
                lineColorExpression: _bucketColorExpression(),
              ),
              LayerPosition(above: _tracksLayerId),
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
              LayerPosition(above: _metricLayerId),
            ),
          ]);

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

    final metricSource = _metricSource;
    final map = _map;
    if (metricSource == null || map == null) {
      return;
    }

    await metricSource.updateGeoJSON(
      metric?.sourceData ??
          jsonEncode({'type': 'FeatureCollection', 'features': const []}),
    );

    await map.style.setStyleLayerProperty(
      _metricLayerId,
      'visibility',
      metric == null ? 'none' : 'visible',
    );
    await map.style.setStyleLayerProperty(
      _tracksLayerId,
      'line-opacity',
      metric == null ? 1 : 0.35,
    );
    await map.style.setStyleLayerProperty(
      _tracksLayerId,
      'line-width',
      metric == null ? 5 : 4,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedMetricKey = metricKey;
    });
  }

  List<Object> _bucketColorExpression() {
    final expression = <Object>[
      'match',
      ['get', 'bucket'],
    ];
    for (var index = 0; index < _bucketColors.length; index++) {
      expression.add(index);
      expression.add(_styleColor(_bucketColors[index]));
    }
    expression.add(_styleColor(_bucketColors.last));
    return expression;
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
      );

      if (metric != null) {
        metrics.add(metric);
      }
    }

    metrics.sort((a, b) => a.label.compareTo(b.label));
    return metrics;
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
  }) {
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

      features.add({
        'type': 'Feature',
        'properties': {
          'metricKey': key,
          'metricValue': value,
          'bucket': _bucketIndex(value, minValue, maxValue),
        },
        'geometry': {
          'type': 'LineString',
          'coordinates': [coordinates[index], coordinates[index + 1]],
        },
      });
    }

    if (features.isEmpty) {
      return null;
    }

    return _MetricLayer(
      key: key,
      label: _metricLabels[key] ?? _prettifyMetricKey(key),
      minValue: minValue,
      maxValue: maxValue,
      sourceData: jsonEncode({
        'type': 'FeatureCollection',
        'features': features,
      }),
    );
  }

  int _bucketIndex(double value, double minValue, double maxValue) {
    if (maxValue <= minValue) {
      return 0;
    }

    final normalized = ((value - minValue) / (maxValue - minValue)).clamp(
      0.0,
      1.0,
    );
    final bucket = (normalized * (_bucketColors.length - 1)).floor();
    return bucket.clamp(0, _bucketColors.length - 1);
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
    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(canvasColor: Theme.of(context).colorScheme.primary),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: selectedMetricKey,
            borderRadius: BorderRadius.circular(16),
            dropdownColor: Theme.of(context).colorScheme.primary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.92),
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
                child: Text('Trace de base'),
              ),
              ...metrics.map(
                (metric) => DropdownMenuItem<String?>(
                  value: metric.key,
                  child: Text(metric.label),
                ),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _MetricLegend extends StatelessWidget {
  final _MetricLayer metric;

  const _MetricLegend({required this.metric});

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
          Text(
            metric.label,
            style: textTheme.titleSmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  Color(_UserJourneyMapScreenState._bucketColors[0]),
                  Color(_UserJourneyMapScreenState._bucketColors[1]),
                  Color(_UserJourneyMapScreenState._bucketColors[2]),
                  Color(_UserJourneyMapScreenState._bucketColors[3]),
                  Color(_UserJourneyMapScreenState._bucketColors[4]),
                  Color(_UserJourneyMapScreenState._bucketColors[5]),
                  Color(_UserJourneyMapScreenState._bucketColors[6]),
                  Color(_UserJourneyMapScreenState._bucketColors[7]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatMetricValue(metric.minValue),
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.82),
                ),
              ),
              Text(
                _formatMetricValue(metric.maxValue),
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatMetricValue(double value) {
    if (value.abs() >= 100 || value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    if (value.abs() >= 10) {
      return value.toStringAsFixed(1);
    }

    return value.toStringAsFixed(2);
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
  final String sourceData;

  const _MetricLayer({
    required this.key,
    required this.label,
    required this.minValue,
    required this.maxValue,
    required this.sourceData,
  });
}
