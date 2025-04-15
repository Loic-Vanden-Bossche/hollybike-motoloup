// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Journey {

 int get id; String get name; String? get file;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'preview_image') String? get previewImage;@JsonKey(name: 'preview_image_key') String? get previewImageKey; MinimalUser get creator; Position? get start; Position? get end; Position? get destination; int? get totalDistance; int? get minElevation; int? get maxElevation; int? get totalElevationGain; int? get totalElevationLoss;
/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyCopyWith<Journey> get copyWith => _$JourneyCopyWithImpl<Journey>(this as Journey, _$identity);

  /// Serializes this Journey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previewImage, previewImage) || other.previewImage == previewImage)&&(identical(other.previewImageKey, previewImageKey) || other.previewImageKey == previewImageKey)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,file,createdAt,previewImage,previewImageKey,creator,start,end,destination,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss);

@override
String toString() {
  return 'Journey(id: $id, name: $name, file: $file, createdAt: $createdAt, previewImage: $previewImage, previewImageKey: $previewImageKey, creator: $creator, start: $start, end: $end, destination: $destination, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss)';
}


}

/// @nodoc
abstract mixin class $JourneyCopyWith<$Res>  {
  factory $JourneyCopyWith(Journey value, $Res Function(Journey) _then) = _$JourneyCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? file,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'preview_image') String? previewImage,@JsonKey(name: 'preview_image_key') String? previewImageKey, MinimalUser creator, Position? start, Position? end, Position? destination, int? totalDistance, int? minElevation, int? maxElevation, int? totalElevationGain, int? totalElevationLoss
});


$MinimalUserCopyWith<$Res> get creator;$PositionCopyWith<$Res>? get start;$PositionCopyWith<$Res>? get end;$PositionCopyWith<$Res>? get destination;

}
/// @nodoc
class _$JourneyCopyWithImpl<$Res>
    implements $JourneyCopyWith<$Res> {
  _$JourneyCopyWithImpl(this._self, this._then);

  final Journey _self;
  final $Res Function(Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? file = freezed,Object? createdAt = null,Object? previewImage = freezed,Object? previewImageKey = freezed,Object? creator = null,Object? start = freezed,Object? end = freezed,Object? destination = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,previewImage: freezed == previewImage ? _self.previewImage : previewImage // ignore: cast_nullable_to_non_nullable
as String?,previewImageKey: freezed == previewImageKey ? _self.previewImageKey : previewImageKey // ignore: cast_nullable_to_non_nullable
as String?,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as MinimalUser,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Position?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as Position?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Position?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as int?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as int?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as int?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get creator {
  
  return $MinimalUserCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}/// Create a copy of Journey
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
}/// Create a copy of Journey
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
}/// Create a copy of Journey
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

class _Journey extends Journey {
  const _Journey({required this.id, required this.name, required this.file, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'preview_image') this.previewImage, @JsonKey(name: 'preview_image_key') this.previewImageKey, required this.creator, required this.start, required this.end, required this.destination, required this.totalDistance, required this.minElevation, required this.maxElevation, required this.totalElevationGain, required this.totalElevationLoss}): super._();
  factory _Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? file;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'preview_image') final  String? previewImage;
@override@JsonKey(name: 'preview_image_key') final  String? previewImageKey;
@override final  MinimalUser creator;
@override final  Position? start;
@override final  Position? end;
@override final  Position? destination;
@override final  int? totalDistance;
@override final  int? minElevation;
@override final  int? maxElevation;
@override final  int? totalElevationGain;
@override final  int? totalElevationLoss;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyCopyWith<_Journey> get copyWith => __$JourneyCopyWithImpl<_Journey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.file, file) || other.file == file)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.previewImage, previewImage) || other.previewImage == previewImage)&&(identical(other.previewImageKey, previewImageKey) || other.previewImageKey == previewImageKey)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.minElevation, minElevation) || other.minElevation == minElevation)&&(identical(other.maxElevation, maxElevation) || other.maxElevation == maxElevation)&&(identical(other.totalElevationGain, totalElevationGain) || other.totalElevationGain == totalElevationGain)&&(identical(other.totalElevationLoss, totalElevationLoss) || other.totalElevationLoss == totalElevationLoss));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,file,createdAt,previewImage,previewImageKey,creator,start,end,destination,totalDistance,minElevation,maxElevation,totalElevationGain,totalElevationLoss);

@override
String toString() {
  return 'Journey(id: $id, name: $name, file: $file, createdAt: $createdAt, previewImage: $previewImage, previewImageKey: $previewImageKey, creator: $creator, start: $start, end: $end, destination: $destination, totalDistance: $totalDistance, minElevation: $minElevation, maxElevation: $maxElevation, totalElevationGain: $totalElevationGain, totalElevationLoss: $totalElevationLoss)';
}


}

/// @nodoc
abstract mixin class _$JourneyCopyWith<$Res> implements $JourneyCopyWith<$Res> {
  factory _$JourneyCopyWith(_Journey value, $Res Function(_Journey) _then) = __$JourneyCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? file,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'preview_image') String? previewImage,@JsonKey(name: 'preview_image_key') String? previewImageKey, MinimalUser creator, Position? start, Position? end, Position? destination, int? totalDistance, int? minElevation, int? maxElevation, int? totalElevationGain, int? totalElevationLoss
});


@override $MinimalUserCopyWith<$Res> get creator;@override $PositionCopyWith<$Res>? get start;@override $PositionCopyWith<$Res>? get end;@override $PositionCopyWith<$Res>? get destination;

}
/// @nodoc
class __$JourneyCopyWithImpl<$Res>
    implements _$JourneyCopyWith<$Res> {
  __$JourneyCopyWithImpl(this._self, this._then);

  final _Journey _self;
  final $Res Function(_Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? file = freezed,Object? createdAt = null,Object? previewImage = freezed,Object? previewImageKey = freezed,Object? creator = null,Object? start = freezed,Object? end = freezed,Object? destination = freezed,Object? totalDistance = freezed,Object? minElevation = freezed,Object? maxElevation = freezed,Object? totalElevationGain = freezed,Object? totalElevationLoss = freezed,}) {
  return _then(_Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,previewImage: freezed == previewImage ? _self.previewImage : previewImage // ignore: cast_nullable_to_non_nullable
as String?,previewImageKey: freezed == previewImageKey ? _self.previewImageKey : previewImageKey // ignore: cast_nullable_to_non_nullable
as String?,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as MinimalUser,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Position?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as Position?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as Position?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as int?,minElevation: freezed == minElevation ? _self.minElevation : minElevation // ignore: cast_nullable_to_non_nullable
as int?,maxElevation: freezed == maxElevation ? _self.maxElevation : maxElevation // ignore: cast_nullable_to_non_nullable
as int?,totalElevationGain: freezed == totalElevationGain ? _self.totalElevationGain : totalElevationGain // ignore: cast_nullable_to_non_nullable
as int?,totalElevationLoss: freezed == totalElevationLoss ? _self.totalElevationLoss : totalElevationLoss // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get creator {
  
  return $MinimalUserCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}/// Create a copy of Journey
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
}/// Create a copy of Journey
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
}/// Create a copy of Journey
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
