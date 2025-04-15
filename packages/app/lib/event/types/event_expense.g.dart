// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventExpense _$EventExpenseFromJson(Map<String, dynamic> json) =>
    _EventExpense(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toInt(),
      proof: json['proof'] as String?,
      proofKey: json['proof_key'] as String?,
    );

Map<String, dynamic> _$EventExpenseToJson(_EventExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'proof': instance.proof,
      'proof_key': instance.proofKey,
    };
