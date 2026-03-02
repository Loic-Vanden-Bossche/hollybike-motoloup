part of '../../user_journey_map.dart';

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
    final selectedHiddenMetric = hiddenMetrics.cast<_MetricLayer?>().firstWhere(
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
                chartSpots: [],
              ),
            ),
            ...dropdownMetrics.map(
              (metric) => DropdownMenuItem<String?>(
                value: metric.key,
                child: _MetricOptionLabel(
                  label: metric.label,
                  paletteColors: metric.paletteColors,
                  chartSpots: metric.chartSpots,
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
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ...hiddenMetrics.map(
                          (metric) => ListTile(
                            title: Text(
                              metric.label,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                  chartSpots: [],
                  selected: true,
                ),
                ...dropdownMetrics.map(
                  (metric) => _MetricOptionLabel(
                    label: metric.label,
                    paletteColors: metric.paletteColors,
                    chartSpots: metric.chartSpots,
                    selected: true,
                  ),
                ),
                if (hiddenMetrics.isNotEmpty)
                  const _MetricOptionLabel(label: 'Plus...', selected: true),
              ],
        ),
      ),
    );
  }
}

class _MetricOptionLabel extends StatelessWidget {
  final String label;
  final List<int>? paletteColors;
  final List<FlSpot>? chartSpots;
  final bool selected;

  const _MetricOptionLabel({
    required this.label,
    this.paletteColors,
    this.chartSpots,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (paletteColors != null) ...[
          _MetricGraphPreview(
            colors: paletteColors!,
            spots: chartSpots ?? const [],
          ),
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

class _MetricGraphPreview extends StatelessWidget {
  final List<int> colors;
  final List<FlSpot> spots;

  const _MetricGraphPreview({required this.colors, required this.spots});

  @override
  Widget build(BuildContext context) {
    final palette =
        colors.isEmpty
            ? const [0xFFFFFFFF, 0xFFFFFFFF]
            : colors.length == 1
            ? [colors.first, colors.first]
            : colors;
    return SizedBox(
      width: 36,
      height: 18,
      child: CustomPaint(
        painter: _MetricGraphPreviewPainter(colors: palette, spots: spots),
      ),
    );
  }
}

class _MetricGraphPreviewPainter extends CustomPainter {
  final List<int> colors;
  final List<FlSpot> spots;

  const _MetricGraphPreviewPainter({required this.colors, required this.spots});

  @override
  void paint(Canvas canvas, ui.Size size) {
    final borderRadius = Radius.circular(size.height / 2);
    final clipPath =
        Path()
          ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, borderRadius));
    canvas.save();
    canvas.clipPath(clipPath);

    final backgroundPaint =
        Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.08);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final previewSpots =
        spots.length >= 2
            ? spots
            : const [
              FlSpot(0, 0.4),
              FlSpot(0.33, 0.6),
              FlSpot(0.66, 0.45),
              FlSpot(1, 0.7),
            ];

    final minX = previewSpots.first.x;
    final maxX = previewSpots.last.x;
    final minY = previewSpots
        .map((spot) => spot.y)
        .reduce((value, element) => math.min(value, element));
    final maxY = previewSpots
        .map((spot) => spot.y)
        .reduce((value, element) => math.max(value, element));
    final xRange = maxX - minX == 0 ? 1.0 : maxX - minX;
    final yRange = maxY - minY == 0 ? 1.0 : maxY - minY;

    final path = Path();
    for (var index = 0; index < previewSpots.length; index++) {
      final spot = previewSpots[index];
      final dx = ((spot.x - minX) / xRange) * size.width;
      final dy =
          size.height - (((spot.y - minY) / yRange) * (size.height - 4)) - 2;
      if (index == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    final strokePaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: colors.map((color) => Color(color)).toList(),
          ).createShader(Offset.zero & size)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MetricGraphPreviewPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.spots != spots;
  }
}
