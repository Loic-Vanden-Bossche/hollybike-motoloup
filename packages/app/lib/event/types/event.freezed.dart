// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {

 int get id; String get name; MinimalUser get owner; EventStatusState get status;@JsonKey(name: "start_date_time") DateTime get startDate;@JsonKey(name: "end_date_time") DateTime? get endDate;@JsonKey(name: "create_date_time") DateTime get createdAt;@JsonKey(name: "update_date_time") DateTime get updatedAt; String? get description; String? get image;@JsonKey(name: "image_key") String? get imageKey; int? get budget;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,owner,status,startDate,endDate,createdAt,updatedAt,description,image,imageKey,budget);

@override
String toString() {
  return 'Event(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, imageKey: $imageKey, budget: $budget)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 int id, String name, MinimalUser owner, EventStatusState status,@JsonKey(name: "start_date_time") DateTime startDate,@JsonKey(name: "end_date_time") DateTime? endDate,@JsonKey(name: "create_date_time") DateTime createdAt,@JsonKey(name: "update_date_time") DateTime updatedAt, String? description, String? image,@JsonKey(name: "image_key") String? imageKey, int? budget
});


$MinimalUserCopyWith<$Res> get owner;

}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? owner = null,Object? status = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? image = freezed,Object? imageKey = freezed,Object? budget = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as MinimalUser,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatusState,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get owner {
  
  return $MinimalUserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  MinimalUser owner,  EventStatusState status, @JsonKey(name: "start_date_time")  DateTime startDate, @JsonKey(name: "end_date_time")  DateTime? endDate, @JsonKey(name: "create_date_time")  DateTime createdAt, @JsonKey(name: "update_date_time")  DateTime updatedAt,  String? description,  String? image, @JsonKey(name: "image_key")  String? imageKey,  int? budget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt,_that.description,_that.image,_that.imageKey,_that.budget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  MinimalUser owner,  EventStatusState status, @JsonKey(name: "start_date_time")  DateTime startDate, @JsonKey(name: "end_date_time")  DateTime? endDate, @JsonKey(name: "create_date_time")  DateTime createdAt, @JsonKey(name: "update_date_time")  DateTime updatedAt,  String? description,  String? image, @JsonKey(name: "image_key")  String? imageKey,  int? budget)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.name,_that.owner,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt,_that.description,_that.image,_that.imageKey,_that.budget);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  MinimalUser owner,  EventStatusState status, @JsonKey(name: "start_date_time")  DateTime startDate, @JsonKey(name: "end_date_time")  DateTime? endDate, @JsonKey(name: "create_date_time")  DateTime createdAt, @JsonKey(name: "update_date_time")  DateTime updatedAt,  String? description,  String? image, @JsonKey(name: "image_key")  String? imageKey,  int? budget)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.name,_that.owner,_that.status,_that.startDate,_that.endDate,_that.createdAt,_that.updatedAt,_that.description,_that.image,_that.imageKey,_that.budget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event extends Event {
  const _Event({required this.id, required this.name, required this.owner, required this.status, @JsonKey(name: "start_date_time") required this.startDate, @JsonKey(name: "end_date_time") this.endDate, @JsonKey(name: "create_date_time") required this.createdAt, @JsonKey(name: "update_date_time") required this.updatedAt, this.description, this.image, @JsonKey(name: "image_key") this.imageKey, this.budget}): super._();
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  int id;
@override final  String name;
@override final  MinimalUser owner;
@override final  EventStatusState status;
@override@JsonKey(name: "start_date_time") final  DateTime startDate;
@override@JsonKey(name: "end_date_time") final  DateTime? endDate;
@override@JsonKey(name: "create_date_time") final  DateTime createdAt;
@override@JsonKey(name: "update_date_time") final  DateTime updatedAt;
@override final  String? description;
@override final  String? image;
@override@JsonKey(name: "image_key") final  String? imageKey;
@override final  int? budget;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey)&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,owner,status,startDate,endDate,createdAt,updatedAt,description,image,imageKey,budget);

@override
String toString() {
  return 'Event(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, imageKey: $imageKey, budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, MinimalUser owner, EventStatusState status,@JsonKey(name: "start_date_time") DateTime startDate,@JsonKey(name: "end_date_time") DateTime? endDate,@JsonKey(name: "create_date_time") DateTime createdAt,@JsonKey(name: "update_date_time") DateTime updatedAt, String? description, String? image,@JsonKey(name: "image_key") String? imageKey, int? budget
});


@override $MinimalUserCopyWith<$Res> get owner;

}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? owner = null,Object? status = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? image = freezed,Object? imageKey = freezed,Object? budget = freezed,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as MinimalUser,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatusState,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,imageKey: freezed == imageKey ? _self.imageKey : imageKey // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get owner {
  
  return $MinimalUserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}

// dart format on
