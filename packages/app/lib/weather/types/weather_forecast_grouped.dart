/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/weather/types/weather_condition.dart';
import 'package:hollybike/weather/types/weather_forecast_response.dart';
import 'package:intl/intl.dart';

part 'weather_forecast_grouped.freezed.dart';

@freezed
sealed class WeatherForecastGrouped with _$WeatherForecastGrouped {
  const factory WeatherForecastGrouped({
    required List<DailyWeatherGrouped> dailyWeather,
  }) = _WeatherForecastGrouped;

  factory WeatherForecastGrouped.fromResponse(
      WeatherForecastResponse response) {
    final Map<String, List<HourlyWeather>> groupedHourly = {};
    for (int i = 0; i < response.hourly.time.length; i++) {
      final weatherCondition =
          getWeatherCondition(response.hourly.weatherCode[i] ?? -1);

      if (response.hourly.temperature2m[i] == null ||
          weatherCondition == null) {
        continue;
      }

      final dateTime = DateTime.parse(response.hourly.time[i]);

      if (dateTime.isBefore(DateTime.now())) {
        continue;
      }

      final date = DateFormat('yyyy-MM-dd').format(dateTime);
      final hour = DateFormat('HH:mm').format(dateTime);

      final hourlyWeather = HourlyWeather(
        isDay: false,
        time: hour,
        rawTime: dateTime,
        temperature:
            '${response.hourly.temperature2m[i]?.round()}${response.hourlyUnits.temperature2m}',
        weatherCondition: weatherCondition,
      );

      groupedHourly.putIfAbsent(date, () => []).add(hourlyWeather);
    }

    final List<DailyWeatherGrouped> groupedDaily = [];
    for (int i = 0; i < response.daily.time.length; i++) {
      final weatherCondition =
          getWeatherCondition(response.daily.weatherCode[i] ?? -1);

      if (response.daily.temperature2mMax[i] == null ||
          response.daily.temperature2mMin[i] == null ||
          weatherCondition == null ||
          response.daily.sunrise[i] == null ||
          response.daily.sunset[i] == null) {
        continue;
      }

      final hourly = groupedHourly[response.daily.time[i]] ?? [];

      final dailyWeatherGrouped = DailyWeatherGrouped(
        date: response.daily.time[i],
        maxTemperature:
            '${response.daily.temperature2mMax[i]?.round()}${response.dailyUnits.temperature2mMax}',
        minTemperature:
            '${response.daily.temperature2mMin[i]?.round()}${response.dailyUnits.temperature2mMin}',
        weatherCondition: weatherCondition,
        hourlyWeather: hourly.map((e) {
          final sunrise = DateTime.parse(response.daily.sunrise[i]!);
          final sunset = DateTime.parse(response.daily.sunset[i]!);

          final isDayTime =
              e.rawTime.isAfter(sunrise) && e.rawTime.isBefore(sunset);

          return e.copyWith(isDay: isDayTime);
        }).toList(),
      );
      groupedDaily.add(dailyWeatherGrouped);
    }

    return WeatherForecastGrouped(dailyWeather: groupedDaily);
  }
}

@freezed
sealed class DailyWeatherGrouped with _$DailyWeatherGrouped {
  const factory DailyWeatherGrouped({
    required String date,
    required String maxTemperature,
    required String minTemperature,
    required WeatherCondition weatherCondition,
    required List<HourlyWeather> hourlyWeather,
  }) = _DailyWeatherGrouped;
}

@freezed
sealed class HourlyWeather with _$HourlyWeather {
  const factory HourlyWeather({
    required String time,
    required DateTime rawTime,
    required String temperature,
    required WeatherCondition weatherCondition,
    required bool isDay,
  }) = _HourlyWeather;
}
