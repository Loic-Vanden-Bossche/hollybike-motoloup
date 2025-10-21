// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geojson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoJSON {

 List<double> get bbox;
/// Create a copy of GeoJSON
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoJSONCopyWith<GeoJSON> get copyWith => _$GeoJSONCopyWithImpl<GeoJSON>(this as GeoJSON, _$identity);

  /// Serializes this GeoJSON to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoJSON&&const DeepCollectionEquality().equals(other.bbox, bbox));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bbox));

@override
String toString() {
  return 'GeoJSON(bbox: $bbox)';
}


}

/// @nodoc
abstract mixin class $GeoJSONCopyWith<$Res>  {
  factory $GeoJSONCopyWith(GeoJSON value, $Res Function(GeoJSON) _then) = _$GeoJSONCopyWithImpl;
@useResult
$Res call({
 List<double> bbox
});




}
/// @nodoc
class _$GeoJSONCopyWithImpl<$Res>
    implements $GeoJSONCopyWith<$Res> {
  _$GeoJSONCopyWithImpl(this._self, this._then);

  final GeoJSON _self;
  final $Res Function(GeoJSON) _then;

/// Create a copy of GeoJSON
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bbox = null,}) {
  return _then(_self.copyWith(
bbox: null == bbox ? _self.bbox : bbox // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoJSON].
extension GeoJSONPatterns on GeoJSON {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoJSON value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoJSON() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoJSON value)  $default,){
final _that = this;
switch (_that) {
case _GeoJSON():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoJSON value)?  $default,){
final _that = this;
switch (_that) {
case _GeoJSON() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<double> bbox)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoJSON() when $default != null:
return $default(_that.bbox);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<double> bbox)  $default,) {final _that = this;
switch (_that) {
case _GeoJSON():
return $default(_that.bbox);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<double> bbox)?  $default,) {final _that = this;
switch (_that) {
case _GeoJSON() when $default != null:
return $default(_that.bbox);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoJSON extends GeoJSON {
  const _GeoJSON({required final  List<double> bbox}): _bbox = bbox,super._();
  factory _GeoJSON.fromJson(Map<String, dynamic> json) => _$GeoJSONFromJson(json);

 final  List<double> _bbox;
@override List<double> get bbox {
  if (_bbox is EqualUnmodifiableListView) return _bbox;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bbox);
}


/// Create a copy of GeoJSON
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoJSONCopyWith<_GeoJSON> get copyWith => __$GeoJSONCopyWithImpl<_GeoJSON>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoJSONToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoJSON&&const DeepCollectionEquality().equals(other._bbox, _bbox));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bbox));

@override
String toString() {
  return 'GeoJSON(bbox: $bbox)';
}


}

/// @nodoc
abstract mixin class _$GeoJSONCopyWith<$Res> implements $GeoJSONCopyWith<$Res> {
  factory _$GeoJSONCopyWith(_GeoJSON value, $Res Function(_GeoJSON) _then) = __$GeoJSONCopyWithImpl;
@override @useResult
$Res call({
 List<double> bbox
});




}
/// @nodoc
class __$GeoJSONCopyWithImpl<$Res>
    implements _$GeoJSONCopyWith<$Res> {
  __$GeoJSONCopyWithImpl(this._self, this._then);

  final _GeoJSON _self;
  final $Res Function(_GeoJSON) _then;

/// Create a copy of GeoJSON
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bbox = null,}) {
  return _then(_GeoJSON(
bbox: null == bbox ? _self._bbox : bbox // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
