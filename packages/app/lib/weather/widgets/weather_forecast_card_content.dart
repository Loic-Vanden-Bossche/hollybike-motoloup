/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/journey/widgets/journey_position.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/weather/types/weather_condition.dart';
import 'package:hollybike/weather/widgets/weather_forecast_empty_card.dart';
import 'package:hollybike/weather/widgets/weather_forecast_modal.dart';
import 'package:lottie/lottie.dart';

import '../bloc/weather_forecast_bloc.dart';
import '../bloc/weather_forecast_event.dart';
import '../bloc/weather_forecast_state.dart';
import '../services/weather_forecast_api.dart';
import '../types/weather_forecast_grouped.dart';

class WeatherForecastCardContent extends StatelessWidget {
  final Position destination;
  final DateTime startDate;
  final DateTime? endDate;

  const WeatherForecastCardContent({
    super.key,
    required this.destination,
    required this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => WeatherForecastBloc(
            weatherForecastApi: WeatherForecastApi(),
            destination: destination,
            startDate: startDate,
            endDate: endDate,
          )..add(FetchWeatherForecast()),
      child: BlocBuilder<WeatherForecastBloc, WeatherForecastState>(
        builder: (context, state) {
          final isLoading =
              state is WeatherForecastLoading ||
              state is WeatherForecastInitial;
          return AnimatedCrossFade(
            crossFadeState:
                isLoading
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
            firstChild: _buildLoadingCard(context),
            secondChild: _buildContentCard(context, state),
          );
        },
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 110,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withValues(alpha: 0.56),
                  scheme.primary.withValues(alpha: 0.42),
                ],
              ),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, WeatherForecastState state) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 110,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withValues(alpha: 0.56),
                      scheme.primary.withValues(alpha: 0.42),
                    ],
                  ),
                  border: Border.all(
                    color: scheme.onPrimary.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: _buildForecast(context, state.weatherForecast),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap:
                        state is WeatherForecastSuccess
                            ? () => _onTap(context)
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<WeatherForecastBloc>(context),
          child: const WeatherForecastModal(),
        );
      },
    );
  }

  Widget _buildForecast(
    BuildContext context,
    WeatherForecastGrouped? weatherForecast,
  ) {
    final scheme = Theme.of(context).colorScheme;

    if (weatherForecast != null) {
      final firstDay = weatherForecast.dailyWeather.first;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JourneyPosition(pos: destination, isLarge: false),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${firstDay.maxTemperature}°',
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 22,
                          fontVariations: const [FontVariation.weight(750)],
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: ' / ${firstDay.minTemperature}°',
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.55),
                          fontSize: 13,
                          fontVariations: const [FontVariation.weight(600)],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getWeatherConditionLabel(firstDay.weatherCondition),
                  style: TextStyle(
                    color: scheme.onPrimary.withValues(alpha: 0.50),
                    fontSize: 10,
                    fontVariations: const [FontVariation.weight(600)],
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (firstDay.hourlyWeather.isNotEmpty)
            SizedBox(
              width: 80,
              child: Lottie.asset(
                getWeatherConditionLottiePath(
                  firstDay.weatherCondition,
                  firstDay.hourlyWeather.first.isDay,
                ),
              ),
            ),
        ],
      );
    }

    return const WeatherForecastEmptyCard(
      message: 'Données météo non disponibles.',
    );
  }
}
