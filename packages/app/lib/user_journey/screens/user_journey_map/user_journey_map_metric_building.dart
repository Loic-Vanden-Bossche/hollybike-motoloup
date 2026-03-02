part of '../user_journey_map.dart';

extension _UserJourneyMapMetricBuilding on _UserJourneyMapScreenState {
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
      label:
          _UserJourneyMapScreenState._metricLabels[key] ??
          _prettifyMetricKey(key),
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
            'geometry': {'type': 'LineString', 'coordinates': coordinates},
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
          'bucket': _bucketIndexForPalette(
            subValue,
            minValue,
            maxValue,
            palette,
          ),
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
    final color = _styleColor(
      _UserJourneyMapScreenState._defaultBucketColors.first,
    );
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
        return _UserJourneyMapScreenState._defaultBucketColors;
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
          supportsPointAlignedValues
              ? index
              : math.min(index, values.length - 1);
      final xIndex =
          supportsPointAlignedValues
              ? index
              : math.min(index + 1, timeValues.length - 1);
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
          supportsPointAlignedValues
              ? index
              : math.min(index, values.length - 1);
      final xIndex =
          supportsPointAlignedValues
              ? index
              : math.min(index + 1, timeValues.length - 1);
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
