// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geolocated_event_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeolocatedEventImage {

 int get id; String get key; String get url; int get width; int get height;@JsonKey(name: "taken_date_time") DateTime? get takenDateTime; Position get position;
/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeolocatedEventImageCopyWith<GeolocatedEventImage> get copyWith => _$GeolocatedEventImageCopyWithImpl<GeolocatedEventImage>(this as GeolocatedEventImage, _$identity);

  /// Serializes this GeolocatedEventImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeolocatedEventImage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.takenDateTime, takenDateTime) || other.takenDateTime == takenDateTime)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,url,width,height,takenDateTime,position);

@override
String toString() {
  return 'GeolocatedEventImage(id: $id, key: $key, url: $url, width: $width, height: $height, takenDateTime: $takenDateTime, position: $position)';
}


}

/// @nodoc
abstract mixin class $GeolocatedEventImageCopyWith<$Res>  {
  factory $GeolocatedEventImageCopyWith(GeolocatedEventImage value, $Res Function(GeolocatedEventImage) _then) = _$GeolocatedEventImageCopyWithImpl;
@useResult
$Res call({
 int id, String key, String url, int width, int height,@JsonKey(name: "taken_date_time") DateTime? takenDateTime, Position position
});


$PositionCopyWith<$Res> get position;

}
/// @nodoc
class _$GeolocatedEventImageCopyWithImpl<$Res>
    implements $GeolocatedEventImageCopyWith<$Res> {
  _$GeolocatedEventImageCopyWithImpl(this._self, this._then);

  final GeolocatedEventImage _self;
  final $Res Function(GeolocatedEventImage) _then;

/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? url = null,Object? width = null,Object? height = null,Object? takenDateTime = freezed,Object? position = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,takenDateTime: freezed == takenDateTime ? _self.takenDateTime : takenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,
  ));
}
/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeolocatedEventImage].
extension GeolocatedEventImagePatterns on GeolocatedEventImage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeolocatedEventImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeolocatedEventImage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeolocatedEventImage value)  $default,){
final _that = this;
switch (_that) {
case _GeolocatedEventImage():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeolocatedEventImage value)?  $default,){
final _that = this;
switch (_that) {
case _GeolocatedEventImage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String key,  String url,  int width,  int height, @JsonKey(name: "taken_date_time")  DateTime? takenDateTime,  Position position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeolocatedEventImage() when $default != null:
return $default(_that.id,_that.key,_that.url,_that.width,_that.height,_that.takenDateTime,_that.position);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String key,  String url,  int width,  int height, @JsonKey(name: "taken_date_time")  DateTime? takenDateTime,  Position position)  $default,) {final _that = this;
switch (_that) {
case _GeolocatedEventImage():
return $default(_that.id,_that.key,_that.url,_that.width,_that.height,_that.takenDateTime,_that.position);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String key,  String url,  int width,  int height, @JsonKey(name: "taken_date_time")  DateTime? takenDateTime,  Position position)?  $default,) {final _that = this;
switch (_that) {
case _GeolocatedEventImage() when $default != null:
return $default(_that.id,_that.key,_that.url,_that.width,_that.height,_that.takenDateTime,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeolocatedEventImage implements GeolocatedEventImage {
  const _GeolocatedEventImage({required this.id, required this.key, required this.url, required this.width, required this.height, @JsonKey(name: "taken_date_time") required this.takenDateTime, required this.position});
  factory _GeolocatedEventImage.fromJson(Map<String, dynamic> json) => _$GeolocatedEventImageFromJson(json);

@override final  int id;
@override final  String key;
@override final  String url;
@override final  int width;
@override final  int height;
@override@JsonKey(name: "taken_date_time") final  DateTime? takenDateTime;
@override final  Position position;

/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeolocatedEventImageCopyWith<_GeolocatedEventImage> get copyWith => __$GeolocatedEventImageCopyWithImpl<_GeolocatedEventImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeolocatedEventImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeolocatedEventImage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.takenDateTime, takenDateTime) || other.takenDateTime == takenDateTime)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,url,width,height,takenDateTime,position);

@override
String toString() {
  return 'GeolocatedEventImage(id: $id, key: $key, url: $url, width: $width, height: $height, takenDateTime: $takenDateTime, position: $position)';
}


}

/// @nodoc
abstract mixin class _$GeolocatedEventImageCopyWith<$Res> implements $GeolocatedEventImageCopyWith<$Res> {
  factory _$GeolocatedEventImageCopyWith(_GeolocatedEventImage value, $Res Function(_GeolocatedEventImage) _then) = __$GeolocatedEventImageCopyWithImpl;
@override @useResult
$Res call({
 int id, String key, String url, int width, int height,@JsonKey(name: "taken_date_time") DateTime? takenDateTime, Position position
});


@override $PositionCopyWith<$Res> get position;

}
/// @nodoc
class __$GeolocatedEventImageCopyWithImpl<$Res>
    implements _$GeolocatedEventImageCopyWith<$Res> {
  __$GeolocatedEventImageCopyWithImpl(this._self, this._then);

  final _GeolocatedEventImage _self;
  final $Res Function(_GeolocatedEventImage) _then;

/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? url = null,Object? width = null,Object? height = null,Object? takenDateTime = freezed,Object? position = null,}) {
  return _then(_GeolocatedEventImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,takenDateTime: freezed == takenDateTime ? _self.takenDateTime : takenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position,
  ));
}

/// Create a copy of GeolocatedEventImage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res> get position {
  
  return $PositionCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
