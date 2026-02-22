import 'package:flutter/material.dart';

InputDecoration buildGlassInputDecoration(
  BuildContext context, {
  String? labelText,
  Widget? suffixIcon,
}) {
  final scheme = Theme.of(context).colorScheme;

  return InputDecoration(
    labelText: labelText,
    suffixIcon: suffixIcon,
    labelStyle: TextStyle(color: scheme.onPrimary.withValues(alpha: 0.75)),
    filled: true,
    fillColor: scheme.onPrimary.withValues(alpha: 0.06),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: scheme.onPrimary.withValues(alpha: 0.14),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: scheme.secondary.withValues(alpha: 0.55),
        width: 1.4,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: scheme.error.withValues(alpha: 0.55),
        width: 1.2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: scheme.error.withValues(alpha: 0.75),
        width: 1.4,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
