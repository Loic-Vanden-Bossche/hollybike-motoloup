// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MinimalEvent {

 int get id; String get name; MinimalUser get owner; EventStatusState get status;@JsonKey(name: "start_date_time") DateTime get startDate;@JsonKey(name: "end_date_time") DateTime? get endDate;@JsonKey(name: "create_date_time") DateTime get createdAt;@JsonKey(name: "update_date_time") DateTime get updatedAt; String? get description; String? get image;@JsonKey(name: "image_key") String? get imageKey;
/// Create a copy of MinimalEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MinimalEventCopyWith<MinimalEvent> get copyWith => _$MinimalEventCopyWithImpl<MinimalEvent>(this as MinimalEvent, _$identity);

  /// Serializes this MinimalEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MinimalEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,owner,status,startDate,endDate,createdAt,updatedAt,description,image,imageKey);

@override
String toString() {
  return 'MinimalEvent(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class $MinimalEventCopyWith<$Res>  {
  factory $MinimalEventCopyWith(MinimalEvent value, $Res Function(MinimalEvent) _then) = _$MinimalEventCopyWithImpl;
@useResult
$Res call({
 int id, String name, MinimalUser owner, EventStatusState status,@JsonKey(name: "start_date_time") DateTime startDate,@JsonKey(name: "end_date_time") DateTime? endDate,@JsonKey(name: "create_date_time") DateTime createdAt,@JsonKey(name: "update_date_time") DateTime updatedAt, String? description, String? image,@JsonKey(name: "image_key") String? imageKey
});


$MinimalUserCopyWith<$Res> get owner;

}
/// @nodoc
class _$MinimalEventCopyWithImpl<$Res>
    implements $MinimalEventCopyWith<$Res> {
  _$MinimalEventCopyWithImpl(this._self, this._then);

  final MinimalEvent _self;
  final $Res Function(MinimalEvent) _then;

/// Create a copy of MinimalEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? owner = null,Object? status = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? image = freezed,Object? imageKey = freezed,}) {
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
as String?,
  ));
}
/// Create a copy of MinimalEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MinimalUserCopyWith<$Res> get owner {
  
  return $MinimalUserCopyWith<$Res>(_self.owner, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _MinimalEvent extends MinimalEvent {
  const _MinimalEvent({required this.id, required this.name, required this.owner, required this.status, @JsonKey(name: "start_date_time") required this.startDate, @JsonKey(name: "end_date_time") this.endDate, @JsonKey(name: "create_date_time") required this.createdAt, @JsonKey(name: "update_date_time") required this.updatedAt, this.description, this.image, @JsonKey(name: "image_key") this.imageKey}): super._();
  factory _MinimalEvent.fromJson(Map<String, dynamic> json) => _$MinimalEventFromJson(json);

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

/// Create a copy of MinimalEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MinimalEventCopyWith<_MinimalEvent> get copyWith => __$MinimalEventCopyWithImpl<_MinimalEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MinimalEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MinimalEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.status, status) || other.status == status)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageKey, imageKey) || other.imageKey == imageKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,owner,status,startDate,endDate,createdAt,updatedAt,description,image,imageKey);

@override
String toString() {
  return 'MinimalEvent(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, imageKey: $imageKey)';
}


}

/// @nodoc
abstract mixin class _$MinimalEventCopyWith<$Res> implements $MinimalEventCopyWith<$Res> {
  factory _$MinimalEventCopyWith(_MinimalEvent value, $Res Function(_MinimalEvent) _then) = __$MinimalEventCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, MinimalUser owner, EventStatusState status,@JsonKey(name: "start_date_time") DateTime startDate,@JsonKey(name: "end_date_time") DateTime? endDate,@JsonKey(name: "create_date_time") DateTime createdAt,@JsonKey(name: "update_date_time") DateTime updatedAt, String? description, String? image,@JsonKey(name: "image_key") String? imageKey
});


@override $MinimalUserCopyWith<$Res> get owner;

}
/// @nodoc
class __$MinimalEventCopyWithImpl<$Res>
    implements _$MinimalEventCopyWith<$Res> {
  __$MinimalEventCopyWithImpl(this._self, this._then);

  final _MinimalEvent _self;
  final $Res Function(_MinimalEvent) _then;

/// Create a copy of MinimalEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? owner = null,Object? status = null,Object? startDate = null,Object? endDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? image = freezed,Object? imageKey = freezed,}) {
  return _then(_MinimalEvent(
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
as String?,
  ));
}

/// Create a copy of MinimalEvent
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
