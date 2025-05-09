/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../shared/types/json_map.dart';
import '../../journey/type/minimal_journey.dart';

part 'user_journey.freezed.dart';
part 'user_journey.g.dart';

@freezed
sealed class UserJourney with _$UserJourney {
  const UserJourney._();

  const factory UserJourney({
    required int id,
    required String file,
    @JsonKey(name: 'avg_speed') required double? avgSpeed,
    @JsonKey(name: 'total_distance') required int? totalDistance,
    @JsonKey(name: 'min_elevation') required double? minElevation,
    @JsonKey(name: 'max_elevation') required double? maxElevation,
    @JsonKey(name: 'total_elevation_gain') required double? totalElevationGain,
    @JsonKey(name: 'total_elevation_loss') required double? totalElevationLoss,
    @JsonKey(name: 'total_time') required int? totalTime,
    @JsonKey(name: 'max_speed') required double? maxSpeed,
    @JsonKey(name: 'avg_g_force') required double? avgGForce,
    @JsonKey(name: 'max_g_force') required double? maxGForce,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'is_better_than') required Map<String, double>? isBetterThan,
  }) = _UserJourney;

  get distanceLabel {
    return MinimalJourney.getDistanceLabel(totalDistance);
  }

  get avgSpeedLabel => _speedLabel(avgSpeed);
  get maxSpeedLabel => _speedLabel(maxSpeed);

  get avgGForceLabel => _gForceLabel(avgGForce);
  get maxGForceLabel => _gForceLabel(maxGForce);

  get dateLabel {
    DateFormat dateFormat = DateFormat('d MMMM yyyy', 'fr_FR');
    DateFormat timeFormat = DateFormat('HH\'h\'mm', 'fr_FR');

    String formattedDate = dateFormat.format(createdAt.toLocal());
    String formattedTime = timeFormat.format(createdAt.toLocal());

    return '$formattedDate à $formattedTime';
  }

  get totalTimeLabel {
    if (totalTime == null) {
      return '';
    }
    final hours = totalTime! ~/ 3600;
    final minutes = (totalTime! % 3600) ~/ 60;

    if (hours == 0) {
      return '$minutes min';
    }

    return '$hours h $minutes min';
  }

  String _speedLabel(double? speed) {
    if (speed == null) {
      return '';
    }
    return '${(speed * 3.6).round()} km/h';
  }

  String _gForceLabel(double? gForce) {
    if (gForce == null) {
      return '';
    }
    return '${gForce.toStringAsFixed(2)} G';
  }

  factory UserJourney.fromJson(JsonMap json) => _$UserJourneyFromJson(json);
}
