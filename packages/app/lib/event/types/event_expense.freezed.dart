// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventExpense {

 int get id; String get name; String? get description; DateTime get date; int get amount; String? get proof;@JsonKey(name: 'proof_key') String? get proofKey;
/// Create a copy of EventExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventExpenseCopyWith<EventExpense> get copyWith => _$EventExpenseCopyWithImpl<EventExpense>(this as EventExpense, _$identity);

  /// Serializes this EventExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.proof, proof) || other.proof == proof)&&(identical(other.proofKey, proofKey) || other.proofKey == proofKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,date,amount,proof,proofKey);

@override
String toString() {
  return 'EventExpense(id: $id, name: $name, description: $description, date: $date, amount: $amount, proof: $proof, proofKey: $proofKey)';
}


}

/// @nodoc
abstract mixin class $EventExpenseCopyWith<$Res>  {
  factory $EventExpenseCopyWith(EventExpense value, $Res Function(EventExpense) _then) = _$EventExpenseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, DateTime date, int amount, String? proof,@JsonKey(name: 'proof_key') String? proofKey
});




}
/// @nodoc
class _$EventExpenseCopyWithImpl<$Res>
    implements $EventExpenseCopyWith<$Res> {
  _$EventExpenseCopyWithImpl(this._self, this._then);

  final EventExpense _self;
  final $Res Function(EventExpense) _then;

/// Create a copy of EventExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? date = null,Object? amount = null,Object? proof = freezed,Object? proofKey = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,proof: freezed == proof ? _self.proof : proof // ignore: cast_nullable_to_non_nullable
as String?,proofKey: freezed == proofKey ? _self.proofKey : proofKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _EventExpense implements EventExpense {
  const _EventExpense({required this.id, required this.name, this.description, required this.date, required this.amount, this.proof, @JsonKey(name: 'proof_key') this.proofKey});
  factory _EventExpense.fromJson(Map<String, dynamic> json) => _$EventExpenseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  DateTime date;
@override final  int amount;
@override final  String? proof;
@override@JsonKey(name: 'proof_key') final  String? proofKey;

/// Create a copy of EventExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventExpenseCopyWith<_EventExpense> get copyWith => __$EventExpenseCopyWithImpl<_EventExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.proof, proof) || other.proof == proof)&&(identical(other.proofKey, proofKey) || other.proofKey == proofKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,date,amount,proof,proofKey);

@override
String toString() {
  return 'EventExpense(id: $id, name: $name, description: $description, date: $date, amount: $amount, proof: $proof, proofKey: $proofKey)';
}


}

/// @nodoc
abstract mixin class _$EventExpenseCopyWith<$Res> implements $EventExpenseCopyWith<$Res> {
  factory _$EventExpenseCopyWith(_EventExpense value, $Res Function(_EventExpense) _then) = __$EventExpenseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, DateTime date, int amount, String? proof,@JsonKey(name: 'proof_key') String? proofKey
});




}
/// @nodoc
class __$EventExpenseCopyWithImpl<$Res>
    implements _$EventExpenseCopyWith<$Res> {
  __$EventExpenseCopyWithImpl(this._self, this._then);

  final _EventExpense _self;
  final $Res Function(_EventExpense) _then;

/// Create a copy of EventExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? date = null,Object? amount = null,Object? proof = freezed,Object? proofKey = freezed,}) {
  return _then(_EventExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,proof: freezed == proof ? _self.proof : proof // ignore: cast_nullable_to_non_nullable
as String?,proofKey: freezed == proofKey ? _self.proofKey : proofKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
