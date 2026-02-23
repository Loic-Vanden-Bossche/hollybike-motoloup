/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/utils/dates.dart';
import '../../../ui/widgets/inputs/glass_picker_field.dart';

class EventDateRangeInput extends StatelessWidget {
  final DateTimeRange dateRange;
  final void Function(DateTimeRange) onDateRangeChanged;

  const EventDateRangeInput({
    super.key,
    required this.dateRange,
    required this.onDateRangeChanged,
  });

  String formatDateRange(DateTimeRange dateRange) {
    final start = dateRange.start;
    final end = dateRange.end;
    final today = DateTime.now();

    final fullDateFormatter = DateFormat.yMMMMd();
    final shortDateFormatter = DateFormat('dd/MM/yyyy');

    if (checkSameDate(start, end)) {
      if (checkSameDate(start, today)) {
        return "Aujourd'hui";
      }
      return 'Le ${fullDateFormatter.format(start)}';
    }

    return 'Du ${shortDateFormatter.format(start)} au ${shortDateFormatter.format(end)}';
  }

  void _onDateRangeChanged(DateTimeRange? dateRange) {
    if (dateRange != null) {
      onDateRangeChanged(dateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassPickerField(
      text: formatDateRange(dateRange),
      labelText: 'Plage de dates',
      icon: Icons.date_range,
      onTap: () {
        Timer(const Duration(milliseconds: 200), () {
          showDateRangePicker(
            context: context,
            initialDateRange: dateRange,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          ).then(_onDateRangeChanged);
        });
      },
    );
  }
}
