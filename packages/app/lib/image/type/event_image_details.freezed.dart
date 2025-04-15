// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_image_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventImageDetails {

 bool get isOwner; MinimalUser get owner; MinimalEvent get event; Position? get position;@JsonKey(name: "taken_date_time") DateTime? get takenDateTime;@JsonKey(name: "uploaded_date_time") DateTime get uploadDateTime;
/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventImageDetailsCopyWith<EventImageDetails> get copyWith => _$EventImageDetailsCopyWithImpl<EventImageDetails>(this as EventImageDetails, _$identity);

  /// Serializes this EventImageDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventImageDetails&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.event, event) || other.event == event)&&(identical(other.position, position) || other.position == position)&&(identical(other.takenDateTime, takenDateTime) || other.takenDateTime == takenDateTime)&&(identical(other.uploadDateTime, uploadDateTime) || other.uploadDateTime == uploadDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOwner,owner,event,position,takenDateTime,uploadDateTime);

@override
String toString() {
  return 'EventImageDetails(isOwner: $isOwner, owner: $owner, event: $event, position: $position, takenDateTime: $takenDateTime, uploadDateTime: $uploadDateTime)';
}


}

/// @nodoc
abstract mixin class $EventImageDetailsCopyWith<$Res>  {
  factory $EventImageDetailsCopyWith(EventImageDetails value, $Res Function(EventImageDetails) _then) = _$EventImageDetailsCopyWithImpl;
@useResult
$Res call({
 bool isOwner, MinimalUser owner, MinimalEvent event, Position? position,@JsonKey(name: "taken_date_time") DateTime? takenDateTime,@JsonKey(name: "uploaded_date_time") DateTime uploadDateTime
});


$MinimalUserCopyWith<$Res> get owner;$MinimalEventCopyWith<$Res> get event;$PositionCopyWith<$Res>? get position;

}
/// @nodoc
class _$EventImageDetailsCopyWithImpl<$Res>
    implements $EventImageDetailsCopyWith<$Res> {
  _$EventImageDetailsCopyWithImpl(this._self, this._then);

  final EventImageDetails _self;
  final $Res Function(EventImageDetails) _then;

/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOwner = null,Object? owner = null,Object? event = null,Object? position = freezed,Object? takenDateTime = freezed,Object? uploadDateTime = null,}) {
  return _then(_self.copyWith(
isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as MinimalUser,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as MinimalEvent,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position?,takenDateTime: freezed == takenDateTime ? _self.takenDateTime : takenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,uploadDateTime: null == uploadDateTime ? _self.uploadDateTime : uploadDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get owner {
  
  return $MinimalUserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalEventCopyWith<$Res> get event {
  
  return $MinimalEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _EventImageDetails implements EventImageDetails {
  const _EventImageDetails({required this.isOwner, required this.owner, required this.event, this.position, @JsonKey(name: "taken_date_time") required this.takenDateTime, @JsonKey(name: "uploaded_date_time") required this.uploadDateTime});
  factory _EventImageDetails.fromJson(Map<String, dynamic> json) => _$EventImageDetailsFromJson(json);

@override final  bool isOwner;
@override final  MinimalUser owner;
@override final  MinimalEvent event;
@override final  Position? position;
@override@JsonKey(name: "taken_date_time") final  DateTime? takenDateTime;
@override@JsonKey(name: "uploaded_date_time") final  DateTime uploadDateTime;

/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventImageDetailsCopyWith<_EventImageDetails> get copyWith => __$EventImageDetailsCopyWithImpl<_EventImageDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventImageDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventImageDetails&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.event, event) || other.event == event)&&(identical(other.position, position) || other.position == position)&&(identical(other.takenDateTime, takenDateTime) || other.takenDateTime == takenDateTime)&&(identical(other.uploadDateTime, uploadDateTime) || other.uploadDateTime == uploadDateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isOwner,owner,event,position,takenDateTime,uploadDateTime);

@override
String toString() {
  return 'EventImageDetails(isOwner: $isOwner, owner: $owner, event: $event, position: $position, takenDateTime: $takenDateTime, uploadDateTime: $uploadDateTime)';
}


}

/// @nodoc
abstract mixin class _$EventImageDetailsCopyWith<$Res> implements $EventImageDetailsCopyWith<$Res> {
  factory _$EventImageDetailsCopyWith(_EventImageDetails value, $Res Function(_EventImageDetails) _then) = __$EventImageDetailsCopyWithImpl;
@override @useResult
$Res call({
 bool isOwner, MinimalUser owner, MinimalEvent event, Position? position,@JsonKey(name: "taken_date_time") DateTime? takenDateTime,@JsonKey(name: "uploaded_date_time") DateTime uploadDateTime
});


@override $MinimalUserCopyWith<$Res> get owner;@override $MinimalEventCopyWith<$Res> get event;@override $PositionCopyWith<$Res>? get position;

}
/// @nodoc
class __$EventImageDetailsCopyWithImpl<$Res>
    implements _$EventImageDetailsCopyWith<$Res> {
  __$EventImageDetailsCopyWithImpl(this._self, this._then);

  final _EventImageDetails _self;
  final $Res Function(_EventImageDetails) _then;

/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOwner = null,Object? owner = null,Object? event = null,Object? position = freezed,Object? takenDateTime = freezed,Object? uploadDateTime = null,}) {
  return _then(_EventImageDetails(
isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as MinimalUser,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as MinimalEvent,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Position?,takenDateTime: freezed == takenDateTime ? _self.takenDateTime : takenDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,uploadDateTime: null == uploadDateTime ? _self.uploadDateTime : uploadDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get owner {
  
  return $MinimalUserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalEventCopyWith<$Res> get event {
  
  return $MinimalEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}/// Create a copy of EventImageDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PositionCopyWith<$Res>? get position {
    if (_self.position == null) {
    return null;
  }

  return $PositionCopyWith<$Res>(_self.position!, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
