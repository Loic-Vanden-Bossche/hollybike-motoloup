// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventFormData {

 String get name; String? get description;@JsonKey(toJson: dateToJson, name: "start_date") DateTime get startDate;@JsonKey(toJson: dateToJson, name: "end_date") DateTime? get endDate; int? get budget;
/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFormDataCopyWith<EventFormData> get copyWith => _$EventFormDataCopyWithImpl<EventFormData>(this as EventFormData, _$identity);

  /// Serializes this EventFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFormData&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,startDate,endDate,budget);

@override
String toString() {
  return 'EventFormData(name: $name, description: $description, startDate: $startDate, endDate: $endDate, budget: $budget)';
}


}

/// @nodoc
abstract mixin class $EventFormDataCopyWith<$Res>  {
  factory $EventFormDataCopyWith(EventFormData value, $Res Function(EventFormData) _then) = _$EventFormDataCopyWithImpl;
@useResult
$Res call({
 String name, String? description,@JsonKey(toJson: dateToJson, name: "start_date") DateTime startDate,@JsonKey(toJson: dateToJson, name: "end_date") DateTime? endDate, int? budget
});




}
/// @nodoc
class _$EventFormDataCopyWithImpl<$Res>
    implements $EventFormDataCopyWith<$Res> {
  _$EventFormDataCopyWithImpl(this._self, this._then);

  final EventFormData _self;
  final $Res Function(EventFormData) _then;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? startDate = null,Object? endDate = freezed,Object? budget = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _EventFormData extends EventFormData {
  const _EventFormData({required this.name, required this.description, @JsonKey(toJson: dateToJson, name: "start_date") required this.startDate, @JsonKey(toJson: dateToJson, name: "end_date") required this.endDate, this.budget}): super._();
  factory _EventFormData.fromJson(Map<String, dynamic> json) => _$EventFormDataFromJson(json);

@override final  String name;
@override final  String? description;
@override@JsonKey(toJson: dateToJson, name: "start_date") final  DateTime startDate;
@override@JsonKey(toJson: dateToJson, name: "end_date") final  DateTime? endDate;
@override final  int? budget;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventFormDataCopyWith<_EventFormData> get copyWith => __$EventFormDataCopyWithImpl<_EventFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventFormData&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.budget, budget) || other.budget == budget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,startDate,endDate,budget);

@override
String toString() {
  return 'EventFormData(name: $name, description: $description, startDate: $startDate, endDate: $endDate, budget: $budget)';
}


}

/// @nodoc
abstract mixin class _$EventFormDataCopyWith<$Res> implements $EventFormDataCopyWith<$Res> {
  factory _$EventFormDataCopyWith(_EventFormData value, $Res Function(_EventFormData) _then) = __$EventFormDataCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description,@JsonKey(toJson: dateToJson, name: "start_date") DateTime startDate,@JsonKey(toJson: dateToJson, name: "end_date") DateTime? endDate, int? budget
});




}
/// @nodoc
class __$EventFormDataCopyWithImpl<$Res>
    implements _$EventFormDataCopyWith<$Res> {
  __$EventFormDataCopyWithImpl(this._self, this._then);

  final _EventFormData _self;
  final $Res Function(_EventFormData) _then;

/// Create a copy of EventFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? startDate = null,Object? endDate = freezed,Object? budget = freezed,}) {
  return _then(_EventFormData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
