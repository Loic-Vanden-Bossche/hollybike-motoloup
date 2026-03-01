part of '../../user_journey_map.dart';

class _MetricLegend extends StatelessWidget {
  final _MetricLayer? metric;
  final List<_MetricLayer> metrics;
  final String? selectedMetricKey;
  final ValueChanged<String?> onMetricChanged;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final int? selectedChartPointIndex;
  final ValueChanged<int?> onChartPointSelected;

  const _MetricLegend({
    required this.metric,
    required this.metrics,
    required this.selectedMetricKey,
    required this.onMetricChanged,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.selectedChartPointIndex,
    required this.onChartPointSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveExpanded = isExpanded && metric != null;

    return _GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _MetricPicker(
                  selectedMetricKey: selectedMetricKey,
                  metrics: metrics,
                  onChanged: onMetricChanged,
                ),
              ),
              const SizedBox(width: 10),
              _MetricLegendToggleButton(
                isExpanded: effectiveExpanded,
                onPressed: metric == null ? null : onToggleExpanded,
              ),
            ],
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child:
                  effectiveExpanded
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              gradient: LinearGradient(
                                colors:
                                    metric!.paletteColors
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
                                _formatMetricValue(
                                  metric!.key,
                                  metric!.minValue,
                                ),
                                style: textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.82),
                                ),
                              ),
                              Text(
                                _formatMetricValue(
                                  metric!.key,
                                  metric!.maxValue,
                                ),
                                style: textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.82),
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
                      )
                      : const SizedBox.shrink(),
            ),
          ),
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

class _MetricLegendToggleButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onPressed;

  const _MetricLegendToggleButton({
    required this.isExpanded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.onPrimary.withValues(
              alpha: onPressed == null ? 0.06 : 0.1,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.onPrimary.withValues(
                alpha: onPressed == null ? 0.1 : 0.14,
              ),
            ),
          ),
          child: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOutCubic,
            child: Icon(
              Icons.keyboard_arrow_down,
              color: scheme.onPrimary.withValues(
                alpha: onPressed == null ? 0.6 : 1,
              ),
            ),
          ),
        ),
      ),
    );
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
    final yPadding =
        minY == maxY ? math.max(1, minY.abs() * 0.1) : (maxY - minY) * 0.12;

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval:
              (maxY - minY).abs() <= 0 ? 1 : (maxY - minY).abs() / 4,
          getDrawingHorizontalLine:
              (_) => FlLine(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                strokeWidth: 1,
              ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
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
                selectedChartPointIndex == null
                    ? const []
                    : [selectedChartPointIndex!],
            isCurved: true,
            curveSmoothness: 0.18,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors:
                  metric.paletteColors.map((color) => Color(color)).toList(),
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
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
