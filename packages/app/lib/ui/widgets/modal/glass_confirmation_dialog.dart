/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

import 'glass_dialog.dart';

Future<bool?> showGlassConfirmationDialog({
  required BuildContext context,
  required String title,
  String? message,
  Widget? content,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  bool destructiveConfirm = false,
  bool barrierDismissible = true,
  bool showCancel = true,
}) {
  assert(
    message != null || content != null,
    'Either message or content must be provided.',
  );

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return GlassDialog(
        title: title,
        onClose: () => Navigator.of(dialogContext).pop(false),
        body: content ?? _buildMessage(dialogContext, message!),
        actions: [
          if (showCancel)
            _DialogActionButton(
              label: cancelLabel,
              style: _DialogActionStyle.neutral,
              onTap: () => Navigator.of(dialogContext).pop(false),
            ),
          _DialogActionButton(
            label: confirmLabel,
            style:
                destructiveConfirm
                    ? _DialogActionStyle.destructive
                    : _DialogActionStyle.primary,
            onTap: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      );
    },
  );
}

Widget _buildMessage(BuildContext context, String message) {
  final scheme = Theme.of(context).colorScheme;
  return Text(
    message,
    style: TextStyle(
      color: scheme.onPrimary.withValues(alpha: 0.72),
      fontSize: 14,
      fontVariations: const [FontVariation.weight(500)],
    ),
  );
}

enum _DialogActionStyle { neutral, primary, destructive }

class _DialogActionButton extends StatelessWidget {
  final String label;
  final _DialogActionStyle style;
  final VoidCallback onTap;

  const _DialogActionButton({
    required this.label,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color textColor() {
      switch (style) {
        case _DialogActionStyle.neutral:
          return scheme.onPrimary.withValues(alpha: 0.72);
        case _DialogActionStyle.primary:
          return scheme.secondary;
        case _DialogActionStyle.destructive:
          return scheme.error;
      }
    }

    Color backgroundColor() {
      switch (style) {
        case _DialogActionStyle.neutral:
          return scheme.primaryContainer.withValues(alpha: 0.45);
        case _DialogActionStyle.primary:
          return scheme.secondary.withValues(alpha: 0.15);
        case _DialogActionStyle.destructive:
          return scheme.error.withValues(alpha: 0.15);
      }
    }

    Color borderColor() {
      switch (style) {
        case _DialogActionStyle.neutral:
          return scheme.onPrimary.withValues(alpha: 0.12);
        case _DialogActionStyle.primary:
          return scheme.secondary.withValues(alpha: 0.42);
        case _DialogActionStyle.destructive:
          return scheme.error.withValues(alpha: 0.42);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: backgroundColor(),
          border: Border.all(color: borderColor(), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor(),
            fontSize: 13,
            fontVariations: const [FontVariation.weight(650)],
          ),
        ),
      ),
    );
  }
}
