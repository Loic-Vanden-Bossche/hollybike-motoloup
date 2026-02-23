/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/utils/dates.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/ui/widgets/modal/glass_bottom_modal.dart';
import 'package:hollybike/weather/bloc/weather_forecast_bloc.dart';
import 'package:hollybike/weather/bloc/weather_forecast_event.dart';
import 'package:hollybike/weather/bloc/weather_forecast_state.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../shared/widgets/pinned_header_delegate.dart';
import '../types/weather_condition.dart';

class WeatherForecastModal extends StatelessWidget {
  const WeatherForecastModal({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GlassBottomModal(
      maxContentHeight: 480,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Prévisions météo',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.onPrimary.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: scheme.onPrimary.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Forecast content
          BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
            builder: (context, state) {
              if (state.weatherForecast == null) {
                return const SizedBox.shrink();
              }
              return _buildWeatherForecast(
                context,
                scheme,
                state.weatherForecast!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecast(
    BuildContext context,
    ColorScheme scheme,
    WeatherForecastGrouped weatherForecast,
  ) {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ThemedRefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: addSeparators(
              weatherForecast.dailyWeather.map((dailyWeather) {
                return SliverMainAxisGroup(
                  slivers: [
                    SliverStack(
                      children: [
                        SliverPositioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer.withValues(
                                alpha: 0.60,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: scheme.onPrimary.withValues(alpha: 0.10),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        MultiSliver(
                          children: [
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: PinnedHeaderDelegate(
                                height: 50,
                                animationDuration: 300,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: scheme.primaryContainer.withValues(
                                      alpha: 0.90,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: scheme.onPrimary.withValues(
                                          alpha: 0.08,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _buildDayHeader(scheme, dailyWeather),
                                  ),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                bottom: 12,
                                top: 4,
                              ),
                              sliver: Builder(
                                builder: (context) {
                                  if (dailyWeather.hourlyWeather.isEmpty) {
                                    return SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            'Pas de données pour ce jour',
                                            style: TextStyle(
                                              color: scheme.onPrimary
                                                  .withValues(alpha: 0.50),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return SliverList.separated(
                                    itemCount:
                                        dailyWeather.hourlyWeather.length,
                                    itemBuilder: (context, index) {
                                      final hourlyWeather =
                                          dailyWeather.hourlyWeather[index];

                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        builder: (
                                          context,
                                          double value,
                                          child,
                                        ) {
                                          return Transform.translate(
                                            offset: Offset(
                                              30 * (1 - value),
                                              0,
                                            ),
                                            child: Opacity(
                                              opacity: value,
                                              child: _buildHourlyRow(
                                                scheme,
                                                hourlyWeather,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (context, index) => Divider(
                                          color: scheme.onPrimary.withValues(
                                            alpha: 0.08,
                                          ),
                                          height: 1,
                                          thickness: 1,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) {
    final bloc = BlocProvider.of<WeatherForecastBloc>(context);
    bloc.add(FetchWeatherForecast());
    return bloc.firstWhenNotLoading;
  }

  Widget _buildDayHeader(ColorScheme scheme, DailyWeatherGrouped dailyWeather) {
    final dateTime = DateTime.parse(dailyWeather.date);
    final dayName = DateFormat('EEEE d', 'fr_FR').format(dateTime);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${dayName.capitalize()} ',
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 15,
              fontVariations: const [FontVariation.weight(700)],
            ),
          ),
          TextSpan(
            text:
                '— ${dailyWeather.maxTemperature}° / ${dailyWeather.minTemperature}°',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.55),
              fontSize: 13,
              fontVariations: const [FontVariation.weight(500)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyRow(ColorScheme scheme, HourlyWeather hourlyWeather) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Lottie.asset(
            getWeatherConditionLottiePath(
              hourlyWeather.weatherCondition,
              hourlyWeather.isDay,
            ),
            height: 28,
            animate: false,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            child: Text(
              hourlyWeather.time,
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.80),
                fontSize: 13,
                fontVariations: const [FontVariation.weight(600)],
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              hourlyWeather.temperature,
              style: TextStyle(
                color: scheme.onPrimary,
                fontSize: 13,
                fontVariations: const [FontVariation.weight(700)],
              ),
            ),
          ),
          Expanded(
            child: Text(
              getWeatherConditionLabel(hourlyWeather.weatherCondition),
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.55),
                fontSize: 11,
                fontVariations: const [FontVariation.weight(500)],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
