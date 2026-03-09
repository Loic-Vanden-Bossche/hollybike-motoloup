// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_caller_participation_step_journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventCallerParticipationStepJourney {

 int get stepId; UserJourney? get journey; bool get hasRecordedPositions;
/// Create a copy of EventCallerParticipationStepJourney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCallerParticipationStepJourneyCopyWith<EventCallerParticipationStepJourney> get copyWith => _$EventCallerParticipationStepJourneyCopyWithImpl<EventCallerParticipationStepJourney>(this as EventCallerParticipationStepJourney, _$identity);

  /// Serializes this EventCallerParticipationStepJourney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventCallerParticipationStepJourney&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.hasRecordedPositions, hasRecordedPositions) || other.hasRecordedPositions == hasRecordedPositions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,journey,hasRecordedPositions);

@override
String toString() {
  return 'EventCallerParticipationStepJourney(stepId: $stepId, journey: $journey, hasRecordedPositions: $hasRecordedPositions)';
}


}

/// @nodoc
abstract mixin class $EventCallerParticipationStepJourneyCopyWith<$Res>  {
  factory $EventCallerParticipationStepJourneyCopyWith(EventCallerParticipationStepJourney value, $Res Function(EventCallerParticipationStepJourney) _then) = _$EventCallerParticipationStepJourneyCopyWithImpl;
@useResult
$Res call({
 int stepId, UserJourney? journey, bool hasRecordedPositions
});


$UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class _$EventCallerParticipationStepJourneyCopyWithImpl<$Res>
    implements $EventCallerParticipationStepJourneyCopyWith<$Res> {
  _$EventCallerParticipationStepJourneyCopyWithImpl(this._self, this._then);

  final EventCallerParticipationStepJourney _self;
  final $Res Function(EventCallerParticipationStepJourney) _then;

/// Create a copy of EventCallerParticipationStepJourney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepId = null,Object? journey = freezed,Object? hasRecordedPositions = null,}) {
  return _then(_self.copyWith(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,hasRecordedPositions: null == hasRecordedPositions ? _self.hasRecordedPositions : hasRecordedPositions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EventCallerParticipationStepJourney
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


/// Adds pattern-matching-related methods to [EventCallerParticipationStepJourney].
extension EventCallerParticipationStepJourneyPatterns on EventCallerParticipationStepJourney {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventCallerParticipationStepJourney value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventCallerParticipationStepJourney value)  $default,){
final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventCallerParticipationStepJourney value)?  $default,){
final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepId,  UserJourney? journey,  bool hasRecordedPositions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney() when $default != null:
return $default(_that.stepId,_that.journey,_that.hasRecordedPositions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepId,  UserJourney? journey,  bool hasRecordedPositions)  $default,) {final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney():
return $default(_that.stepId,_that.journey,_that.hasRecordedPositions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepId,  UserJourney? journey,  bool hasRecordedPositions)?  $default,) {final _that = this;
switch (_that) {
case _EventCallerParticipationStepJourney() when $default != null:
return $default(_that.stepId,_that.journey,_that.hasRecordedPositions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventCallerParticipationStepJourney implements EventCallerParticipationStepJourney {
  const _EventCallerParticipationStepJourney({required this.stepId, required this.journey, required this.hasRecordedPositions});
  factory _EventCallerParticipationStepJourney.fromJson(Map<String, dynamic> json) => _$EventCallerParticipationStepJourneyFromJson(json);

@override final  int stepId;
@override final  UserJourney? journey;
@override final  bool hasRecordedPositions;

/// Create a copy of EventCallerParticipationStepJourney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCallerParticipationStepJourneyCopyWith<_EventCallerParticipationStepJourney> get copyWith => __$EventCallerParticipationStepJourneyCopyWithImpl<_EventCallerParticipationStepJourney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventCallerParticipationStepJourneyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventCallerParticipationStepJourney&&(identical(other.stepId, stepId) || other.stepId == stepId)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.hasRecordedPositions, hasRecordedPositions) || other.hasRecordedPositions == hasRecordedPositions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepId,journey,hasRecordedPositions);

@override
String toString() {
  return 'EventCallerParticipationStepJourney(stepId: $stepId, journey: $journey, hasRecordedPositions: $hasRecordedPositions)';
}


}

/// @nodoc
abstract mixin class _$EventCallerParticipationStepJourneyCopyWith<$Res> implements $EventCallerParticipationStepJourneyCopyWith<$Res> {
  factory _$EventCallerParticipationStepJourneyCopyWith(_EventCallerParticipationStepJourney value, $Res Function(_EventCallerParticipationStepJourney) _then) = __$EventCallerParticipationStepJourneyCopyWithImpl;
@override @useResult
$Res call({
 int stepId, UserJourney? journey, bool hasRecordedPositions
});


@override $UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class __$EventCallerParticipationStepJourneyCopyWithImpl<$Res>
    implements _$EventCallerParticipationStepJourneyCopyWith<$Res> {
  __$EventCallerParticipationStepJourneyCopyWithImpl(this._self, this._then);

  final _EventCallerParticipationStepJourney _self;
  final $Res Function(_EventCallerParticipationStepJourney) _then;

/// Create a copy of EventCallerParticipationStepJourney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepId = null,Object? journey = freezed,Object? hasRecordedPositions = null,}) {
  return _then(_EventCallerParticipationStepJourney(
stepId: null == stepId ? _self.stepId : stepId // ignore: cast_nullable_to_non_nullable
as int,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,hasRecordedPositions: null == hasRecordedPositions ? _self.hasRecordedPositions : hasRecordedPositions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EventCallerParticipationStepJourney
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
