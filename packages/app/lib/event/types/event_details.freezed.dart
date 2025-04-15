// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventDetails {

 Event get event; MinimalJourney? get journey; EventCallerParticipation? get callerParticipation; List<EventParticipation> get previewParticipants; int get previewParticipantsCount; List<EventExpense>? get expenses; int? get totalExpense;
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailsCopyWith<EventDetails> get copyWith => _$EventDetailsCopyWithImpl<EventDetails>(this as EventDetails, _$identity);

  /// Serializes this EventDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetails&&(identical(other.event, event) || other.event == event)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.callerParticipation, callerParticipation) || other.callerParticipation == callerParticipation)&&const DeepCollectionEquality().equals(other.previewParticipants, previewParticipants)&&(identical(other.previewParticipantsCount, previewParticipantsCount) || other.previewParticipantsCount == previewParticipantsCount)&&const DeepCollectionEquality().equals(other.expenses, expenses)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,journey,callerParticipation,const DeepCollectionEquality().hash(previewParticipants),previewParticipantsCount,const DeepCollectionEquality().hash(expenses),totalExpense);

@override
String toString() {
  return 'EventDetails(event: $event, journey: $journey, callerParticipation: $callerParticipation, previewParticipants: $previewParticipants, previewParticipantsCount: $previewParticipantsCount, expenses: $expenses, totalExpense: $totalExpense)';
}


}

/// @nodoc
abstract mixin class $EventDetailsCopyWith<$Res>  {
  factory $EventDetailsCopyWith(EventDetails value, $Res Function(EventDetails) _then) = _$EventDetailsCopyWithImpl;
@useResult
$Res call({
 Event event, MinimalJourney? journey, EventCallerParticipation? callerParticipation, List<EventParticipation> previewParticipants, int previewParticipantsCount, List<EventExpense>? expenses, int? totalExpense
});


$EventCopyWith<$Res> get event;$MinimalJourneyCopyWith<$Res>? get journey;$EventCallerParticipationCopyWith<$Res>? get callerParticipation;

}
/// @nodoc
class _$EventDetailsCopyWithImpl<$Res>
    implements $EventDetailsCopyWith<$Res> {
  _$EventDetailsCopyWithImpl(this._self, this._then);

  final EventDetails _self;
  final $Res Function(EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? journey = freezed,Object? callerParticipation = freezed,Object? previewParticipants = null,Object? previewParticipantsCount = null,Object? expenses = freezed,Object? totalExpense = freezed,}) {
  return _then(_self.copyWith(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as MinimalJourney?,callerParticipation: freezed == callerParticipation ? _self.callerParticipation : callerParticipation // ignore: cast_nullable_to_non_nullable
as EventCallerParticipation?,previewParticipants: null == previewParticipants ? _self.previewParticipants : previewParticipants // ignore: cast_nullable_to_non_nullable
as List<EventParticipation>,previewParticipantsCount: null == previewParticipantsCount ? _self.previewParticipantsCount : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
as int,expenses: freezed == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<EventExpense>?,totalExpense: freezed == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalJourneyCopyWith<$Res>? get journey {
    if (_self.journey == null) {
    return null;
  }

  return $MinimalJourneyCopyWith<$Res>(_self.journey!, (value) {
    return _then(_self.copyWith(journey: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCallerParticipationCopyWith<$Res>? get callerParticipation {
    if (_self.callerParticipation == null) {
    return null;
  }

  return $EventCallerParticipationCopyWith<$Res>(_self.callerParticipation!, (value) {
    return _then(_self.copyWith(callerParticipation: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _EventDetails extends EventDetails {
  const _EventDetails({required this.event, required this.journey, required this.callerParticipation, required final  List<EventParticipation> previewParticipants, required this.previewParticipantsCount, required final  List<EventExpense>? expenses, required this.totalExpense}): _previewParticipants = previewParticipants,_expenses = expenses,super._();
  factory _EventDetails.fromJson(Map<String, dynamic> json) => _$EventDetailsFromJson(json);

@override final  Event event;
@override final  MinimalJourney? journey;
@override final  EventCallerParticipation? callerParticipation;
 final  List<EventParticipation> _previewParticipants;
@override List<EventParticipation> get previewParticipants {
  if (_previewParticipants is EqualUnmodifiableListView) return _previewParticipants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_previewParticipants);
}

@override final  int previewParticipantsCount;
 final  List<EventExpense>? _expenses;
@override List<EventExpense>? get expenses {
  final value = _expenses;
  if (value == null) return null;
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? totalExpense;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailsCopyWith<_EventDetails> get copyWith => __$EventDetailsCopyWithImpl<_EventDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetails&&(identical(other.event, event) || other.event == event)&&(identical(other.journey, journey) || other.journey == journey)&&(identical(other.callerParticipation, callerParticipation) || other.callerParticipation == callerParticipation)&&const DeepCollectionEquality().equals(other._previewParticipants, _previewParticipants)&&(identical(other.previewParticipantsCount, previewParticipantsCount) || other.previewParticipantsCount == previewParticipantsCount)&&const DeepCollectionEquality().equals(other._expenses, _expenses)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,journey,callerParticipation,const DeepCollectionEquality().hash(_previewParticipants),previewParticipantsCount,const DeepCollectionEquality().hash(_expenses),totalExpense);

@override
String toString() {
  return 'EventDetails(event: $event, journey: $journey, callerParticipation: $callerParticipation, previewParticipants: $previewParticipants, previewParticipantsCount: $previewParticipantsCount, expenses: $expenses, totalExpense: $totalExpense)';
}


}

/// @nodoc
abstract mixin class _$EventDetailsCopyWith<$Res> implements $EventDetailsCopyWith<$Res> {
  factory _$EventDetailsCopyWith(_EventDetails value, $Res Function(_EventDetails) _then) = __$EventDetailsCopyWithImpl;
@override @useResult
$Res call({
 Event event, MinimalJourney? journey, EventCallerParticipation? callerParticipation, List<EventParticipation> previewParticipants, int previewParticipantsCount, List<EventExpense>? expenses, int? totalExpense
});


@override $EventCopyWith<$Res> get event;@override $MinimalJourneyCopyWith<$Res>? get journey;@override $EventCallerParticipationCopyWith<$Res>? get callerParticipation;

}
/// @nodoc
class __$EventDetailsCopyWithImpl<$Res>
    implements _$EventDetailsCopyWith<$Res> {
  __$EventDetailsCopyWithImpl(this._self, this._then);

  final _EventDetails _self;
  final $Res Function(_EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? journey = freezed,Object? callerParticipation = freezed,Object? previewParticipants = null,Object? previewParticipantsCount = null,Object? expenses = freezed,Object? totalExpense = freezed,}) {
  return _then(_EventDetails(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as MinimalJourney?,callerParticipation: freezed == callerParticipation ? _self.callerParticipation : callerParticipation // ignore: cast_nullable_to_non_nullable
as EventCallerParticipation?,previewParticipants: null == previewParticipants ? _self._previewParticipants : previewParticipants // ignore: cast_nullable_to_non_nullable
as List<EventParticipation>,previewParticipantsCount: null == previewParticipantsCount ? _self.previewParticipantsCount : previewParticipantsCount // ignore: cast_nullable_to_non_nullable
as int,expenses: freezed == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<EventExpense>?,totalExpense: freezed == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalJourneyCopyWith<$Res>? get journey {
    if (_self.journey == null) {
    return null;
  }

  return $MinimalJourneyCopyWith<$Res>(_self.journey!, (value) {
    return _then(_self.copyWith(journey: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCallerParticipationCopyWith<$Res>? get callerParticipation {
    if (_self.callerParticipation == null) {
    return null;
  }

  return $EventCallerParticipationCopyWith<$Res>(_self.callerParticipation!, (value) {
    return _then(_self.copyWith(callerParticipation: value));
  });
}
}

// dart format on
