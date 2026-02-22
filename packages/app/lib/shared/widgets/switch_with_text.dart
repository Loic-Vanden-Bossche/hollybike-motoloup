/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loic Vanden Bossche
*/
import 'package:flutter/material.dart';

enum SwitchAlignment { left, right }

class SwitchWithText extends StatelessWidget {
  final void Function()? onChange;
  final String text;
  final bool value;
  final SwitchAlignment alignment;

  const SwitchWithText({
    super.key,
    required this.onChange,
    required this.text,
    required this.value,
    this.alignment = SwitchAlignment.left,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final switchWidget = Switch(
      value: value,
      onChanged: onChange != null ? (_) => onChange?.call() : null,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.secondary;
        }
        return scheme.onPrimary.withValues(alpha: 0.7);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.secondary.withValues(alpha: 0.35);
        }
        return scheme.onPrimary.withValues(alpha: 0.16);
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.secondary.withValues(alpha: 0.45);
        }
        return scheme.onPrimary.withValues(alpha: 0.22);
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    final label = Expanded(
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(
          color: scheme.onPrimary.withValues(alpha: 0.88),
          fontSize: 13,
          fontVariations: const [FontVariation.weight(600)],
        ),
      ),
    );

    final rowChildren =
        alignment == SwitchAlignment.left
            ? [switchWidget, const SizedBox(width: 10), label]
            : [label, const SizedBox(width: 10), switchWidget];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color:
              value
                  ? scheme.onPrimary.withValues(alpha: 0.12)
                  : scheme.onPrimary.withValues(alpha: 0.06),
          border: Border.all(
            color:
                value
                    ? scheme.secondary.withValues(alpha: 0.35)
                    : scheme.onPrimary.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: rowChildren),
      ),
    );
  }
}
