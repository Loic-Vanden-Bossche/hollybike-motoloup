// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventImage {

 int get id; String get key; String get url; int get size; int get width; int get height;
/// Create a copy of EventImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventImageCopyWith<EventImage> get copyWith => _$EventImageCopyWithImpl<EventImage>(this as EventImage, _$identity);

  /// Serializes this EventImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventImage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.size, size) || other.size == size)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,url,size,width,height);

@override
String toString() {
  return 'EventImage(id: $id, key: $key, url: $url, size: $size, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $EventImageCopyWith<$Res>  {
  factory $EventImageCopyWith(EventImage value, $Res Function(EventImage) _then) = _$EventImageCopyWithImpl;
@useResult
$Res call({
 int id, String key, String url, int size, int width, int height
});




}
/// @nodoc
class _$EventImageCopyWithImpl<$Res>
    implements $EventImageCopyWith<$Res> {
  _$EventImageCopyWithImpl(this._self, this._then);

  final EventImage _self;
  final $Res Function(EventImage) _then;

/// Create a copy of EventImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? url = null,Object? size = null,Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EventImage].
extension EventImagePatterns on EventImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventImage value)  $default,){
final _that = this;
switch (_that) {
case _EventImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventImage value)?  $default,){
final _that = this;
switch (_that) {
case _EventImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String key,  String url,  int size,  int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventImage() when $default != null:
return $default(_that.id,_that.key,_that.url,_that.size,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String key,  String url,  int size,  int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _EventImage():
return $default(_that.id,_that.key,_that.url,_that.size,_that.width,_that.height);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String key,  String url,  int size,  int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _EventImage() when $default != null:
return $default(_that.id,_that.key,_that.url,_that.size,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventImage implements EventImage {
  const _EventImage({required this.id, required this.key, required this.url, required this.size, required this.width, required this.height});
  factory _EventImage.fromJson(Map<String, dynamic> json) => _$EventImageFromJson(json);

@override final  int id;
@override final  String key;
@override final  String url;
@override final  int size;
@override final  int width;
@override final  int height;

/// Create a copy of EventImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventImageCopyWith<_EventImage> get copyWith => __$EventImageCopyWithImpl<_EventImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventImage&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.size, size) || other.size == size)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,url,size,width,height);

@override
String toString() {
  return 'EventImage(id: $id, key: $key, url: $url, size: $size, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$EventImageCopyWith<$Res> implements $EventImageCopyWith<$Res> {
  factory _$EventImageCopyWith(_EventImage value, $Res Function(_EventImage) _then) = __$EventImageCopyWithImpl;
@override @useResult
$Res call({
 int id, String key, String url, int size, int width, int height
});




}
/// @nodoc
class __$EventImageCopyWithImpl<$Res>
    implements _$EventImageCopyWith<$Res> {
  __$EventImageCopyWithImpl(this._self, this._then);

  final _EventImage _self;
  final $Res Function(_EventImage) _then;

/// Create a copy of EventImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? url = null,Object? size = null,Object? width = null,Object? height = null,}) {
  return _then(_EventImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
