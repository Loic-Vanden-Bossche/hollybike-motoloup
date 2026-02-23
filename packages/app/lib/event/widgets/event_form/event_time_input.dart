/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../ui/widgets/inputs/glass_picker_field.dart';

class EventTimeInput extends StatelessWidget {
  final TimeOfDay time;
  final String label;
  final void Function(TimeOfDay) onTimeChanged;
  final DateTime? date;

  const EventTimeInput({
    super.key,
    required this.time,
    required this.onTimeChanged,
    required this.label,
    this.date,
  });

  void _onTimeChanged(TimeOfDay? time) {
    if (time != null) {
      onTimeChanged(time);
    }
  }

  String formatDate(DateTime date) {
    final fullDateFormatter = DateFormat.yMMMEd();
    return 'Le ${fullDateFormatter.format(date)}';
  }

  Widget getText(BuildContext context) {
    if (date == null) {
      return const SizedBox();
    }

    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          '${formatDate(date!)} à',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: scheme.onPrimary.withValues(alpha: 0.78),
            fontSize: 12,
            fontVariations: const [FontVariation.weight(600)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getText(context),
        GlassPickerField(
          text: time.format(context),
          labelText: label,
          icon: Icons.access_time,
          width: 130,
          onTap: () {
            Timer(const Duration(milliseconds: 200), () {
              showTimePicker(
                context: context,
                initialTime: time,
              ).then(_onTimeChanged);
            });
          },
        ),
      ],
    );
  }
}
