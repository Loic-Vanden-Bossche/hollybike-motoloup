/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

/// A generic glass-effect dialog consistent with [GlassBottomModal].
///
/// - [title] + [onClose] render an optional header row with a close button.
/// - [body] is always required and rendered in a scrollable area.
/// - [actions] are optional; when provided they appear in a row at the bottom.
class GlassDialog extends StatelessWidget {
  final String? title;
  final Widget body;
  final VoidCallback? onClose;
  final List<Widget>? actions;

  const GlassDialog({
    super.key,
    this.title,
    required this.body,
    this.onClose,
    this.actions,
  });

  static const _kRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_kRadius),
        child: Stack(
          children: [
            // Base gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      scheme.primary.withValues(alpha: 0.62),
                      scheme.primary.withValues(alpha: 0.48),
                    ],
                  ),
                ),
              ),
            ),

            // Top-left teal blob
            Positioned(
              top: -55,
              left: -45,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 55, sigmaY: 55),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.secondary.withValues(alpha: 0.20),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom-right tertiary blob
            Positioned(
              bottom: -45,
              right: -35,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                  child: Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.tertiary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
            ),

            // Blur + border + content
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_kRadius),
                  border: Border.all(
                    color: scheme.onPrimary.withValues(alpha: 0.14),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 32,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null || onClose != null) ...[
                      _Header(title: title, onClose: onClose),
                      Divider(
                        color: scheme.onPrimary.withValues(alpha: 0.10),
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: body,
                      ),
                    ),
                    if (actions != null && actions!.isNotEmpty) ...[
                      Divider(
                        color: scheme.onPrimary.withValues(alpha: 0.10),
                        height: 1,
                        thickness: 1,
                      ),
                      _ActionsBar(actions: actions!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String? title;
  final VoidCallback? onClose;

  const _Header({this.title, this.onClose});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontVariations: const [FontVariation.weight(700)],
                ),
              ),
            ),
          if (title != null && onClose != null) const SizedBox(width: 12),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scheme.onPrimary.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: scheme.onPrimary.withValues(alpha: 0.65),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionsBar extends StatelessWidget {
  final List<Widget> actions;

  const _ActionsBar({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            actions[i],
          ],
        ],
      ),
    );
  }
}
