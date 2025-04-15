// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_path_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImagePathDto {

 String get path; String get key;
/// Create a copy of ImagePathDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImagePathDtoCopyWith<ImagePathDto> get copyWith => _$ImagePathDtoCopyWithImpl<ImagePathDto>(this as ImagePathDto, _$identity);

  /// Serializes this ImagePathDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImagePathDto&&(identical(other.path, path) || other.path == path)&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,key);

@override
String toString() {
  return 'ImagePathDto(path: $path, key: $key)';
}


}

/// @nodoc
abstract mixin class $ImagePathDtoCopyWith<$Res>  {
  factory $ImagePathDtoCopyWith(ImagePathDto value, $Res Function(ImagePathDto) _then) = _$ImagePathDtoCopyWithImpl;
@useResult
$Res call({
 String path, String key
});




}
/// @nodoc
class _$ImagePathDtoCopyWithImpl<$Res>
    implements $ImagePathDtoCopyWith<$Res> {
  _$ImagePathDtoCopyWithImpl(this._self, this._then);

  final ImagePathDto _self;
  final $Res Function(ImagePathDto) _then;

/// Create a copy of ImagePathDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? key = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ImagePathDto implements ImagePathDto {
  const _ImagePathDto({required this.path, required this.key});
  factory _ImagePathDto.fromJson(Map<String, dynamic> json) => _$ImagePathDtoFromJson(json);

@override final  String path;
@override final  String key;

/// Create a copy of ImagePathDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImagePathDtoCopyWith<_ImagePathDto> get copyWith => __$ImagePathDtoCopyWithImpl<_ImagePathDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImagePathDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagePathDto&&(identical(other.path, path) || other.path == path)&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,key);

@override
String toString() {
  return 'ImagePathDto(path: $path, key: $key)';
}


}

/// @nodoc
abstract mixin class _$ImagePathDtoCopyWith<$Res> implements $ImagePathDtoCopyWith<$Res> {
  factory _$ImagePathDtoCopyWith(_ImagePathDto value, $Res Function(_ImagePathDto) _then) = __$ImagePathDtoCopyWithImpl;
@override @useResult
$Res call({
 String path, String key
});




}
/// @nodoc
class __$ImagePathDtoCopyWithImpl<$Res>
    implements _$ImagePathDtoCopyWith<$Res> {
  __$ImagePathDtoCopyWithImpl(this._self, this._then);

  final _ImagePathDto _self;
  final $Res Function(_ImagePathDto) _then;

/// Create a copy of ImagePathDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? key = null,}) {
  return _then(_ImagePathDto(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
