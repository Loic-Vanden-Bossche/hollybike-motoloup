part of '../../user_journey_map.dart';

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
