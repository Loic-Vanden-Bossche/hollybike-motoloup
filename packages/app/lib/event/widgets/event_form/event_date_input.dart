/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/dates.dart';
import '../../../ui/widgets/inputs/glass_picker_field.dart';

class EventDateInput extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onDateChanged;

  const EventDateInput({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  String formatDate(DateTime date) {
    final today = DateTime.now();
    final fullDateFormatter = DateFormat.yMMMd();

    if (checkSameDate(date, today)) {
      return "Aujourd'hui";
    }
    return fullDateFormatter.format(date);
  }

  void _onDateChanged(DateTime? date) {
    if (date != null) {
      onDateChanged(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassPickerField(
      text: formatDate(date),
      labelText: 'Date',
      icon: Icons.today,
      onTap: () {
        Timer(const Duration(milliseconds: 200), () {
          showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          ).then(_onDateChanged);
        });
      },
    );
  }
}
