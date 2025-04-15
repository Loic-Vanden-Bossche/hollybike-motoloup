// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MinimalJourney {

 int get id; String? get file; Position? get start; Position? get end; Position? get destination; int? get totalDistance; int? get minElevation; int? get maxElevation; int? get totalElevationGain; int? get totalElevationLoss;@JsonKey(name: 'preview_image') String? get previewImage;@JsonKey(name: 'preview_image_key') String? get previewImageKey;
/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinimalJourneyCopyWith<MinimalJourney> get copyWith => _$MinimalJourneyCopyWithImpl<MinimalJourney>(this as MinimalJourney, _$identity);

  /// Serializes this MinimalJourney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinimalJourney&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss)&&(identical(other.previewImage, previewImage) || other.previewImage == previewImage)&&(identical(other.previewImageKey, previewImageKey) || other.previewImageKey == previewImageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,start,end,destination,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss,previewImage,previewImageKey);

@override
String toString() {
  return 'MinimalJourney(id: $id, file: $file, start: $start, end: $end, destination: $destination, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss, previewImage: $previewImage, previewImageKey: $previewImageKey)';
}


}

/// @nodoc
abstract mixin class $MinimalJourneyCopyWith<$Res>  {
  factory $MinimalJourneyCopyWith(MinimalJourney value, $Res Function(MinimalJourney) _then) = _$MinimalJourneyCopyWithImpl;
@useResult
$Res call({
 int id, String? file, Position? start, Position? end, Position? destination, int? totalDistance, int? minElevation, int? maxElevation, int? totalElevationGain, int? totalElevationLoss,@JsonKey(name: 'preview_image') String? previewImage,@JsonKey(name: 'preview_image_key') String? previewImageKey
});


$PositionCopyWith<$Res>? get start;$PositionCopyWith<$Res>? get end;$PositionCopyWith<$Res>? get destination;

}
/// @nodoc
class _$MinimalJourneyCopyWithImpl<$Res>
    implements $MinimalJourneyCopyWith<$Res> {
  _$MinimalJourneyCopyWithImpl(this._self, this._then);

  final MinimalJourney _self;
  final $Res Function(MinimalJourney) _then;

/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? file = freezed,Object? start = freezed,Object? end = freezed,Object? destination = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,Object? previewImage = freezed,Object? previewImageKey = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Position?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as Position?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Position?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as int?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as int?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as int?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as int?,previewImage: freezed == previewImage ? _self.previewImage : previewImage // ignore: cast_nullable_to_non_nullable
as String?,previewImageKey: freezed == previewImageKey ? _self.previewImageKey : previewImageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get start {
    if (_self.start == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.start!, (value) {
    return _then(_self.copyWith(start: value));
  });
}/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get end {
    if (_self.end == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.end!, (value) {
    return _then(_self.copyWith(end: value));
  });
}/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get destination {
    if (_self.destination == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.destination!, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _MinimalJourney extends MinimalJourney {
  const _MinimalJourney({required this.id, required this.file, required this.start, required this.end, required this.destination, required this.totalDistance, required this.minElevation, required this.maxElevation, required this.totalElevationGain, required this.totalElevationLoss, @JsonKey(name: 'preview_image') this.previewImage, @JsonKey(name: 'preview_image_key') this.previewImageKey}): super._();
  factory _MinimalJourney.fromJson(Map<String, dynamic> json) => _$MinimalJourneyFromJson(json);

@override final  int id;
@override final  String? file;
@override final  Position? start;
@override final  Position? end;
@override final  Position? destination;
@override final  int? totalDistance;
@override final  int? minElevation;
@override final  int? maxElevation;
@override final  int? totalElevationGain;
@override final  int? totalElevationLoss;
@override@JsonKey(name: 'preview_image') final  String? previewImage;
@override@JsonKey(name: 'preview_image_key') final  String? previewImageKey;

/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinimalJourneyCopyWith<_MinimalJourney> get copyWith => __$MinimalJourneyCopyWithImpl<_MinimalJourney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinimalJourneyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinimalJourney&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss)&&(identical(other.previewImage, previewImage) || other.previewImage == previewImage)&&(identical(other.previewImageKey, previewImageKey) || other.previewImageKey == previewImageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,start,end,destination,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss,previewImage,previewImageKey);

@override
String toString() {
  return 'MinimalJourney(id: $id, file: $file, start: $start, end: $end, destination: $destination, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss, previewImage: $previewImage, previewImageKey: $previewImageKey)';
}


}

/// @nodoc
abstract mixin class _$MinimalJourneyCopyWith<$Res> implements $MinimalJourneyCopyWith<$Res> {
  factory _$MinimalJourneyCopyWith(_MinimalJourney value, $Res Function(_MinimalJourney) _then) = __$MinimalJourneyCopyWithImpl;
@override @useResult
$Res call({
 int id, String? file, Position? start, Position? end, Position? destination, int? totalDistance, int? minElevation, int? maxElevation, int? totalElevationGain, int? totalElevationLoss,@JsonKey(name: 'preview_image') String? previewImage,@JsonKey(name: 'preview_image_key') String? previewImageKey
});


@override $PositionCopyWith<$Res>? get start;@override $PositionCopyWith<$Res>? get end;@override $PositionCopyWith<$Res>? get destination;

}
/// @nodoc
class __$MinimalJourneyCopyWithImpl<$Res>
    implements _$MinimalJourneyCopyWith<$Res> {
  __$MinimalJourneyCopyWithImpl(this._self, this._then);

  final _MinimalJourney _self;
  final $Res Function(_MinimalJourney) _then;

/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? file = freezed,Object? start = freezed,Object? end = freezed,Object? destination = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,Object? previewImage = freezed,Object? previewImageKey = freezed,}) {
  return _then(_MinimalJourney(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Position?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as Position?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Position?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as int?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as int?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as int?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as int?,previewImage: freezed == previewImage ? _self.previewImage : previewImage // ignore: cast_nullable_to_non_nullable
as String?,previewImageKey: freezed == previewImageKey ? _self.previewImageKey : previewImageKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get start {
    if (_self.start == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.start!, (value) {
    return _then(_self.copyWith(start: value));
  });
}/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get end {
    if (_self.end == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.end!, (value) {
    return _then(_self.copyWith(end: value));
  });
}/// Create a copy of MinimalJourney
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get destination {
    if (_self.destination == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.destination!, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}

// dart format on
