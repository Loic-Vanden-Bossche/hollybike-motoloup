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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Prévisions météo',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
                builder: (context, state) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 400,
                    ),
                    child: _buildWeatherForecast(
                      context,
                      state.weatherForecast,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherForecast(
    BuildContext context,
    WeatherForecastGrouped? weatherForecast,
  ) {
    if (weatherForecast == null) {
      return const SizedBox();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      MultiSliver(children: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: PinnedHeaderDelegate(
                            height: 50,
                            animationDuration: 300,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildDayHeader(dailyWeather),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          sliver: Builder(builder: (context) {
                            if (dailyWeather.hourlyWeather.isEmpty) {
                              return const SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 70,
                                  child: Center(
                                    child: Text(
                                      'Pas de données disponibles pour ce jour',
                                    ),
                                  ),
                                ),
                              );
                            }

                            return SliverList.separated(
                              itemCount: dailyWeather.hourlyWeather.length,
                              itemBuilder: (context, index) {
                                final hourlyWeather =
                                    dailyWeather.hourlyWeather[index];

                                return TweenAnimationBuilder(
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  builder: (context, double value, child) {
                                    return Transform.translate(
                                      offset: Offset(30 * (1 - value), 0),
                                      child: Opacity(
                                        opacity: value,
                                        child: _buildHourlyData(hourlyWeather),
                                      ),
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withValues(alpha: 0.5),
                                height: 0.5,
                                thickness: 0.5,
                              ),
                            );
                          }),
                        ),
                      ])
                    ],
                  ),
                ],
              );
            }).toList(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) {
    final bloc = BlocProvider.of<WeatherForecastBloc>(context);

    bloc.add(
      FetchWeatherForecast(),
    );

    return bloc.firstWhenNotLoading;
  }

  Widget _buildDayHeader(DailyWeatherGrouped dailyWeather) {
    final date = dailyWeather.date;

    DateTime dateTime = DateTime.parse(date);
    String dayName = DateFormat('EEEE d', 'fr_FR').format(dateTime);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${dayName.capitalize()} ',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: '- ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal, // Make dash not bold
            ),
          ),
          TextSpan(
            text:
                '${dailyWeather.maxTemperature} / ${dailyWeather.minTemperature}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyData(HourlyWeather hourlyWeather) {
    String hourString = hourlyWeather.time;
    String temperature = hourlyWeather.temperature;
    String weatherCondition =
        getWeatherConditionLabel(hourlyWeather.weatherCondition);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Lottie.asset(
            getWeatherConditionLottiePath(
              hourlyWeather.weatherCondition,
              hourlyWeather.isDay,
            ),
            height: 30,
            animate: false,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              hourString,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              temperature,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '-  $weatherCondition',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
