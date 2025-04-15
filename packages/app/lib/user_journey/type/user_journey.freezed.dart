// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserJourney {

 int get id; String get file;@JsonKey(name: 'avg_speed') double? get avgSpeed;@JsonKey(name: 'total_distance') int? get totalDistance;@JsonKey(name: 'min_elevation') double? get minElevation;@JsonKey(name: 'max_elevation') double? get maxElevation;@JsonKey(name: 'total_elevation_gain') double? get totalElevationGain;@JsonKey(name: 'total_elevation_loss') double? get totalElevationLoss;@JsonKey(name: 'total_time') int? get totalTime;@JsonKey(name: 'max_speed') double? get maxSpeed;@JsonKey(name: 'avg_g_force') double? get avgGForce;@JsonKey(name: 'max_g_force') double? get maxGForce;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'is_better_than') Map<String, double>? get isBetterThan;
/// Create a copy of UserJourney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserJourneyCopyWith<UserJourney> get copyWith => _$UserJourneyCopyWithImpl<UserJourney>(this as UserJourney, _$identity);

  /// Serializes this UserJourney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserJourney&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.avgGForce, avgGForce) || other.avgGForce == avgGForce)&&(identical(other.maxGForce, maxGForce) || other.maxGForce == maxGForce)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.isBetterThan, isBetterThan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,avgSpeed,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss,totalTime,maxSpeed,avgGForce,maxGForce,createdAt,const DeepCollectionEquality().hash(isBetterThan));

@override
String toString() {
  return 'UserJourney(id: $id, file: $file, avgSpeed: $avgSpeed, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss, totalTime: $totalTime, maxSpeed: $maxSpeed, avgGForce: $avgGForce, maxGForce: $maxGForce, createdAt: $createdAt, isBetterThan: $isBetterThan)';
}


}

/// @nodoc
abstract mixin class $UserJourneyCopyWith<$Res>  {
  factory $UserJourneyCopyWith(UserJourney value, $Res Function(UserJourney) _then) = _$UserJourneyCopyWithImpl;
@useResult
$Res call({
 int id, String file,@JsonKey(name: 'avg_speed') double? avgSpeed,@JsonKey(name: 'total_distance') int? totalDistance,@JsonKey(name: 'min_elevation') double? minElevation,@JsonKey(name: 'max_elevation') double? maxElevation,@JsonKey(name: 'total_elevation_gain') double? totalElevationGain,@JsonKey(name: 'total_elevation_loss') double? totalElevationLoss,@JsonKey(name: 'total_time') int? totalTime,@JsonKey(name: 'max_speed') double? maxSpeed,@JsonKey(name: 'avg_g_force') double? avgGForce,@JsonKey(name: 'max_g_force') double? maxGForce,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'is_better_than') Map<String, double>? isBetterThan
});




}
/// @nodoc
class _$UserJourneyCopyWithImpl<$Res>
    implements $UserJourneyCopyWith<$Res> {
  _$UserJourneyCopyWithImpl(this._self, this._then);

  final UserJourney _self;
  final $Res Function(UserJourney) _then;

/// Create a copy of UserJourney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? file = null,Object? avgSpeed = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,Object? totalTime = freezed,Object? maxSpeed = freezed,Object? avgGForce = freezed,Object? maxGForce = freezed,Object? createdAt = null,Object? isBetterThan = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as double?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as double?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as double?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as double?,totalTime: freezed == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as int?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgGForce: freezed == avgGForce ? _self.avgGForce : avgGForce // ignore: cast_nullable_to_non_nullable
as double?,maxGForce: freezed == maxGForce ? _self.maxGForce : maxGForce // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isBetterThan: freezed == isBetterThan ? _self.isBetterThan : isBetterThan // ignore: cast_nullable_to_non_nullable
as Map<String, double>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UserJourney extends UserJourney {
  const _UserJourney({required this.id, required this.file, @JsonKey(name: 'avg_speed') required this.avgSpeed, @JsonKey(name: 'total_distance') required this.totalDistance, @JsonKey(name: 'min_elevation') required this.minElevation, @JsonKey(name: 'max_elevation') required this.maxElevation, @JsonKey(name: 'total_elevation_gain') required this.totalElevationGain, @JsonKey(name: 'total_elevation_loss') required this.totalElevationLoss, @JsonKey(name: 'total_time') required this.totalTime, @JsonKey(name: 'max_speed') required this.maxSpeed, @JsonKey(name: 'avg_g_force') required this.avgGForce, @JsonKey(name: 'max_g_force') required this.maxGForce, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'is_better_than') required final  Map<String, double>? isBetterThan}): _isBetterThan = isBetterThan,super._();
  factory _UserJourney.fromJson(Map<String, dynamic> json) => _$UserJourneyFromJson(json);

@override final  int id;
@override final  String file;
@override@JsonKey(name: 'avg_speed') final  double? avgSpeed;
@override@JsonKey(name: 'total_distance') final  int? totalDistance;
@override@JsonKey(name: 'min_elevation') final  double? minElevation;
@override@JsonKey(name: 'max_elevation') final  double? maxElevation;
@override@JsonKey(name: 'total_elevation_gain') final  double? totalElevationGain;
@override@JsonKey(name: 'total_elevation_loss') final  double? totalElevationLoss;
@override@JsonKey(name: 'total_time') final  int? totalTime;
@override@JsonKey(name: 'max_speed') final  double? maxSpeed;
@override@JsonKey(name: 'avg_g_force') final  double? avgGForce;
@override@JsonKey(name: 'max_g_force') final  double? maxGForce;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
 final  Map<String, double>? _isBetterThan;
@override@JsonKey(name: 'is_better_than') Map<String, double>? get isBetterThan {
  final value = _isBetterThan;
  if (value == null) return null;
  if (_isBetterThan is EqualUnmodifiableMapView) return _isBetterThan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of UserJourney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserJourneyCopyWith<_UserJourney> get copyWith => __$UserJourneyCopyWithImpl<_UserJourney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserJourneyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserJourney&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.avgSpeed, avgSpeed) || other.avgSpeed == avgSpeed)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss)&&(identical(other.totalTime, totalTime) || other.totalTime == totalTime)&&(identical(other.maxSpeed, maxSpeed) || other.maxSpeed == maxSpeed)&&(identical(other.avgGForce, avgGForce) || other.avgGForce == avgGForce)&&(identical(other.maxGForce, maxGForce) || other.maxGForce == maxGForce)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._isBetterThan, _isBetterThan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,avgSpeed,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss,totalTime,maxSpeed,avgGForce,maxGForce,createdAt,const DeepCollectionEquality().hash(_isBetterThan));

@override
String toString() {
  return 'UserJourney(id: $id, file: $file, avgSpeed: $avgSpeed, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss, totalTime: $totalTime, maxSpeed: $maxSpeed, avgGForce: $avgGForce, maxGForce: $maxGForce, createdAt: $createdAt, isBetterThan: $isBetterThan)';
}


}

/// @nodoc
abstract mixin class _$UserJourneyCopyWith<$Res> implements $UserJourneyCopyWith<$Res> {
  factory _$UserJourneyCopyWith(_UserJourney value, $Res Function(_UserJourney) _then) = __$UserJourneyCopyWithImpl;
@override @useResult
$Res call({
 int id, String file,@JsonKey(name: 'avg_speed') double? avgSpeed,@JsonKey(name: 'total_distance') int? totalDistance,@JsonKey(name: 'min_elevation') double? minElevation,@JsonKey(name: 'max_elevation') double? maxElevation,@JsonKey(name: 'total_elevation_gain') double? totalElevationGain,@JsonKey(name: 'total_elevation_loss') double? totalElevationLoss,@JsonKey(name: 'total_time') int? totalTime,@JsonKey(name: 'max_speed') double? maxSpeed,@JsonKey(name: 'avg_g_force') double? avgGForce,@JsonKey(name: 'max_g_force') double? maxGForce,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'is_better_than') Map<String, double>? isBetterThan
});




}
/// @nodoc
class __$UserJourneyCopyWithImpl<$Res>
    implements _$UserJourneyCopyWith<$Res> {
  __$UserJourneyCopyWithImpl(this._self, this._then);

  final _UserJourney _self;
  final $Res Function(_UserJourney) _then;

/// Create a copy of UserJourney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? file = null,Object? avgSpeed = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,Object? totalTime = freezed,Object? maxSpeed = freezed,Object? avgGForce = freezed,Object? maxGForce = freezed,Object? createdAt = null,Object? isBetterThan = freezed,}) {
  return _then(_UserJourney(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,avgSpeed: freezed == avgSpeed ? _self.avgSpeed : avgSpeed // ignore: cast_nullable_to_non_nullable
as double?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as double?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as double?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as double?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as double?,totalTime: freezed == totalTime ? _self.totalTime : totalTime // ignore: cast_nullable_to_non_nullable
as int?,maxSpeed: freezed == maxSpeed ? _self.maxSpeed : maxSpeed // ignore: cast_nullable_to_non_nullable
as double?,avgGForce: freezed == avgGForce ? _self.avgGForce : avgGForce // ignore: cast_nullable_to_non_nullable
as double?,maxGForce: freezed == maxGForce ? _self.maxGForce : maxGForce // ignore: cast_nullable_to_non_nullable
as double?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isBetterThan: freezed == isBetterThan ? _self._isBetterThan : isBetterThan // ignore: cast_nullable_to_non_nullable
as Map<String, double>?,
  ));
}


}

// dart format on
