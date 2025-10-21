// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedList<T> {

 int get page;@JsonKey(name: "total_page") int get totalPages;@JsonKey(name: "per_page") int get perPage;@JsonKey(name: "total_data") int get totalItems;@JsonKey(name: "data") List<T> get items;
/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedListCopyWith<T, PaginatedList<T>> get copyWith => _$PaginatedListCopyWithImpl<T, PaginatedList<T>>(this as PaginatedList<T>, _$identity);

  /// Serializes this PaginatedList to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedList<T>&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,totalPages,perPage,totalItems,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PaginatedList<$T>(page: $page, totalPages: $totalPages, perPage: $perPage, totalItems: $totalItems, items: $items)';
}


}

/// @nodoc
abstract mixin class $PaginatedListCopyWith<T,$Res>  {
  factory $PaginatedListCopyWith(PaginatedList<T> value, $Res Function(PaginatedList<T>) _then) = _$PaginatedListCopyWithImpl;
@useResult
$Res call({
 int page,@JsonKey(name: "total_page") int totalPages,@JsonKey(name: "per_page") int perPage,@JsonKey(name: "total_data") int totalItems,@JsonKey(name: "data") List<T> items
});




}
/// @nodoc
class _$PaginatedListCopyWithImpl<T,$Res>
    implements $PaginatedListCopyWith<T, $Res> {
  _$PaginatedListCopyWithImpl(this._self, this._then);

  final PaginatedList<T> _self;
  final $Res Function(PaginatedList<T>) _then;

/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? totalPages = null,Object? perPage = null,Object? totalItems = null,Object? items = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedList].
extension PaginatedListPatterns<T> on PaginatedList<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedList<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedList<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedList<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page, @JsonKey(name: "total_page")  int totalPages, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "total_data")  int totalItems, @JsonKey(name: "data")  List<T> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
return $default(_that.page,_that.totalPages,_that.perPage,_that.totalItems,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page, @JsonKey(name: "total_page")  int totalPages, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "total_data")  int totalItems, @JsonKey(name: "data")  List<T> items)  $default,) {final _that = this;
switch (_that) {
case _PaginatedList():
return $default(_that.page,_that.totalPages,_that.perPage,_that.totalItems,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page, @JsonKey(name: "total_page")  int totalPages, @JsonKey(name: "per_page")  int perPage, @JsonKey(name: "total_data")  int totalItems, @JsonKey(name: "data")  List<T> items)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedList() when $default != null:
return $default(_that.page,_that.totalPages,_that.perPage,_that.totalItems,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)

class _PaginatedList<T> extends PaginatedList<T> {
  const _PaginatedList({required this.page, @JsonKey(name: "total_page") required this.totalPages, @JsonKey(name: "per_page") required this.perPage, @JsonKey(name: "total_data") required this.totalItems, @JsonKey(name: "data") required final  List<T> items}): _items = items,super._();
  factory _PaginatedList.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$PaginatedListFromJson(json,fromJsonT);

@override final  int page;
@override@JsonKey(name: "total_page") final  int totalPages;
@override@JsonKey(name: "per_page") final  int perPage;
@override@JsonKey(name: "total_data") final  int totalItems;
 final  List<T> _items;
@override@JsonKey(name: "data") List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedListCopyWith<T, _PaginatedList<T>> get copyWith => __$PaginatedListCopyWithImpl<T, _PaginatedList<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$PaginatedListToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedList<T>&&(identical(other.page, page) || other.page == page)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,totalPages,perPage,totalItems,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PaginatedList<$T>(page: $page, totalPages: $totalPages, perPage: $perPage, totalItems: $totalItems, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PaginatedListCopyWith<T,$Res> implements $PaginatedListCopyWith<T, $Res> {
  factory _$PaginatedListCopyWith(_PaginatedList<T> value, $Res Function(_PaginatedList<T>) _then) = __$PaginatedListCopyWithImpl;
@override @useResult
$Res call({
 int page,@JsonKey(name: "total_page") int totalPages,@JsonKey(name: "per_page") int perPage,@JsonKey(name: "total_data") int totalItems,@JsonKey(name: "data") List<T> items
});




}
/// @nodoc
class __$PaginatedListCopyWithImpl<T,$Res>
    implements _$PaginatedListCopyWith<T, $Res> {
  __$PaginatedListCopyWithImpl(this._self, this._then);

  final _PaginatedList<T> _self;
  final $Res Function(_PaginatedList<T>) _then;

/// Create a copy of PaginatedList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? totalPages = null,Object? perPage = null,Object? totalItems = null,Object? items = null,}) {
  return _then(_PaginatedList<T>(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

// dart format on
