// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_caller_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventCallerParticipation {

 int get userId; bool get isImagesPublic; EventRole get role; DateTime get joinedDateTime; UserJourney? get journey; bool get hasRecordedPositions;
/// Create a copy of EventCallerParticipation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCallerParticipationCopyWith<EventCallerParticipation> get copyWith => _$EventCallerParticipationCopyWithImpl<EventCallerParticipation>(this as EventCallerParticipation, _$identity);

  /// Serializes this EventCallerParticipation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventCallerParticipation&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isImagesPublic, isImagesPublic) || other.isImagesPublic == isImagesPublic)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedDateTime, joinedDateTime) || other.joinedDateTime == joinedDateTime)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.hasRecordedPositions, hasRecordedPositions) || other.hasRecordedPositions == hasRecordedPositions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isImagesPublic,role,joinedDateTime,journey,hasRecordedPositions);

@override
String toString() {
  return 'EventCallerParticipation(userId: $userId, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime, journey: $journey, hasRecordedPositions: $hasRecordedPositions)';
}


}

/// @nodoc
abstract mixin class $EventCallerParticipationCopyWith<$Res>  {
  factory $EventCallerParticipationCopyWith(EventCallerParticipation value, $Res Function(EventCallerParticipation) _then) = _$EventCallerParticipationCopyWithImpl;
@useResult
$Res call({
 int userId, bool isImagesPublic, EventRole role, DateTime joinedDateTime, UserJourney? journey, bool hasRecordedPositions
});


$UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class _$EventCallerParticipationCopyWithImpl<$Res>
    implements $EventCallerParticipationCopyWith<$Res> {
  _$EventCallerParticipationCopyWithImpl(this._self, this._then);

  final EventCallerParticipation _self;
  final $Res Function(EventCallerParticipation) _then;

/// Create a copy of EventCallerParticipation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? isImagesPublic = null,Object? role = null,Object? joinedDateTime = null,Object? journey = freezed,Object? hasRecordedPositions = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,isImagesPublic: null == isImagesPublic ? _self.isImagesPublic : isImagesPublic // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EventRole,joinedDateTime: null == joinedDateTime ? _self.joinedDateTime : joinedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,hasRecordedPositions: null == hasRecordedPositions ? _self.hasRecordedPositions : hasRecordedPositions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EventCallerParticipation
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


/// @nodoc
@JsonSerializable()

class _EventCallerParticipation implements EventCallerParticipation {
  const _EventCallerParticipation({required this.userId, required this.isImagesPublic, required this.role, required this.joinedDateTime, required this.journey, required this.hasRecordedPositions});
  factory _EventCallerParticipation.fromJson(Map<String, dynamic> json) => _$EventCallerParticipationFromJson(json);

@override final  int userId;
@override final  bool isImagesPublic;
@override final  EventRole role;
@override final  DateTime joinedDateTime;
@override final  UserJourney? journey;
@override final  bool hasRecordedPositions;

/// Create a copy of EventCallerParticipation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCallerParticipationCopyWith<_EventCallerParticipation> get copyWith => __$EventCallerParticipationCopyWithImpl<_EventCallerParticipation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventCallerParticipationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventCallerParticipation&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isImagesPublic, isImagesPublic) || other.isImagesPublic == isImagesPublic)&&(identical(other.role, role) || other.role == role)&&(identical(other.joinedDateTime, joinedDateTime) || other.joinedDateTime == joinedDateTime)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.hasRecordedPositions, hasRecordedPositions) || other.hasRecordedPositions == hasRecordedPositions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isImagesPublic,role,joinedDateTime,journey,hasRecordedPositions);

@override
String toString() {
  return 'EventCallerParticipation(userId: $userId, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime, journey: $journey, hasRecordedPositions: $hasRecordedPositions)';
}


}

/// @nodoc
abstract mixin class _$EventCallerParticipationCopyWith<$Res> implements $EventCallerParticipationCopyWith<$Res> {
  factory _$EventCallerParticipationCopyWith(_EventCallerParticipation value, $Res Function(_EventCallerParticipation) _then) = __$EventCallerParticipationCopyWithImpl;
@override @useResult
$Res call({
 int userId, bool isImagesPublic, EventRole role, DateTime joinedDateTime, UserJourney? journey, bool hasRecordedPositions
});


@override $UserJourneyCopyWith<$Res>? get journey;

}
/// @nodoc
class __$EventCallerParticipationCopyWithImpl<$Res>
    implements _$EventCallerParticipationCopyWith<$Res> {
  __$EventCallerParticipationCopyWithImpl(this._self, this._then);

  final _EventCallerParticipation _self;
  final $Res Function(_EventCallerParticipation) _then;

/// Create a copy of EventCallerParticipation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? isImagesPublic = null,Object? role = null,Object? joinedDateTime = null,Object? journey = freezed,Object? hasRecordedPositions = null,}) {
  return _then(_EventCallerParticipation(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,isImagesPublic: null == isImagesPublic ? _self.isImagesPublic : isImagesPublic // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as EventRole,joinedDateTime: null == joinedDateTime ? _self.joinedDateTime : joinedDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as UserJourney?,hasRecordedPositions: null == hasRecordedPositions ? _self.hasRecordedPositions : hasRecordedPositions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EventCallerParticipation
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
