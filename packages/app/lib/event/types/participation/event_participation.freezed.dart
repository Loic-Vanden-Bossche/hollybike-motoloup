// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventParticipation {

 MinimalUser get user; bool get isImagesPublic; EventRole get role; DateTime get joinedDateTime; UserJourney? get journey;
/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventParticipationCopyWith<EventParticipation> get copyWith => _$EventParticipationCopyWithImpl<EventParticipation>(this as EventParticipation, _$identity);

  /// Serializes this EventParticipation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventParticipation&&(identical(other.user, user) || other.user == user)&&(identical(other.isImagesPublic, isImagesPublic) || other.isImagesPublic == isImagesPublic)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedDateTime, joinedDateTime) || other.joinedDateTime == joinedDateTime)&&(identical(other.journey, journey) || other.journey == journey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,isImagesPublic,role,joinedDateTime,journey);

@override
String toString() {
  return 'EventParticipation(user: $user, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime, journey: $journey)';
}


}

/// @nodoc
abstract mixin class $EventParticipationCopyWith<$Res>  {
  factory $EventParticipationCopyWith(EventParticipation value, $Res Function(EventParticipation) _then) = _$EventParticipationCopyWithImpl;
@useResult
$Res call({
 MinimalUser user, bool isImagesPublic, EventRole role, DateTime joinedDateTime, UserJourney? journey
});


$MinimalUserCopyWith<$Res> get user;$UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class _$EventParticipationCopyWithImpl<$Res>
    implements $EventParticipationCopyWith<$Res> {
  _$EventParticipationCopyWithImpl(this._self, this._then);

  final EventParticipation _self;
  final $Res Function(EventParticipation) _then;

/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? isImagesPublic = null,Object? role = null,Object? joinedDateTime = null,Object? journey = freezed,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MinimalUser,isImagesPublic: null == isImagesPublic ? _self.isImagesPublic : isImagesPublic // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EventRole,joinedDateTime: null == joinedDateTime ? _self.joinedDateTime : joinedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,
  ));
}
/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get user {
  
  return $MinimalUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserJourneyCopyWith<$Res>? get journey {
    if (_self.journey == null) {
    return null;
  }

  return $UserJourneyCopyWith<$Res>(_self.journey!, (value) {
    return _then(_self.copyWith(journey: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventParticipation].
extension EventParticipationPatterns on EventParticipation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventParticipation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventParticipation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventParticipation value)  $default,){
final _that = this;
switch (_that) {
case _EventParticipation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventParticipation value)?  $default,){
final _that = this;
switch (_that) {
case _EventParticipation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MinimalUser user,  bool isImagesPublic,  EventRole role,  DateTime joinedDateTime,  UserJourney? journey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventParticipation() when $default != null:
return $default(_that.user,_that.isImagesPublic,_that.role,_that.joinedDateTime,_that.journey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MinimalUser user,  bool isImagesPublic,  EventRole role,  DateTime joinedDateTime,  UserJourney? journey)  $default,) {final _that = this;
switch (_that) {
case _EventParticipation():
return $default(_that.user,_that.isImagesPublic,_that.role,_that.joinedDateTime,_that.journey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MinimalUser user,  bool isImagesPublic,  EventRole role,  DateTime joinedDateTime,  UserJourney? journey)?  $default,) {final _that = this;
switch (_that) {
case _EventParticipation() when $default != null:
return $default(_that.user,_that.isImagesPublic,_that.role,_that.joinedDateTime,_that.journey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventParticipation extends EventParticipation {
  const _EventParticipation({required this.user, required this.isImagesPublic, required this.role, required this.joinedDateTime, required this.journey}): super._();
  factory _EventParticipation.fromJson(Map<String, dynamic> json) => _$EventParticipationFromJson(json);

@override final  MinimalUser user;
@override final  bool isImagesPublic;
@override final  EventRole role;
@override final  DateTime joinedDateTime;
@override final  UserJourney? journey;

/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventParticipationCopyWith<_EventParticipation> get copyWith => __$EventParticipationCopyWithImpl<_EventParticipation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventParticipationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventParticipation&&(identical(other.user, user) || other.user == user)&&(identical(other.isImagesPublic, isImagesPublic) || other.isImagesPublic == isImagesPublic)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedDateTime, joinedDateTime) || other.joinedDateTime == joinedDateTime)&&(identical(other.journey, journey) || other.journey == journey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,isImagesPublic,role,joinedDateTime,journey);

@override
String toString() {
  return 'EventParticipation(user: $user, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime, journey: $journey)';
}


}

/// @nodoc
abstract mixin class _$EventParticipationCopyWith<$Res> implements $EventParticipationCopyWith<$Res> {
  factory _$EventParticipationCopyWith(_EventParticipation value, $Res Function(_EventParticipation) _then) = __$EventParticipationCopyWithImpl;
@override @useResult
$Res call({
 MinimalUser user, bool isImagesPublic, EventRole role, DateTime joinedDateTime, UserJourney? journey
});


@override $MinimalUserCopyWith<$Res> get user;@override $UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class __$EventParticipationCopyWithImpl<$Res>
    implements _$EventParticipationCopyWith<$Res> {
  __$EventParticipationCopyWithImpl(this._self, this._then);

  final _EventParticipation _self;
  final $Res Function(_EventParticipation) _then;

/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? isImagesPublic = null,Object? role = null,Object? joinedDateTime = null,Object? journey = freezed,}) {
  return _then(_EventParticipation(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MinimalUser,isImagesPublic: null == isImagesPublic ? _self.isImagesPublic : isImagesPublic // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EventRole,joinedDateTime: null == joinedDateTime ? _self.joinedDateTime : joinedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,
  ));
}

/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get user {
  
  return $MinimalUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of EventParticipation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserJourneyCopyWith<$Res>? get journey {
    if (_self.journey == null) {
    return null;
  }

  return $UserJourneyCopyWith<$Res>(_self.journey!, (value) {
    return _then(_self.copyWith(journey: value));
  });
}
}

// dart format on
