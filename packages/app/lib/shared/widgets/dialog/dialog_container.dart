/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollybike/ui/widgets/modal/glass_dialog.dart';

/// Legacy adapter for callers that supply an arbitrary [head] widget.
/// Prefer using [GlassDialog] directly for new code.
class DialogContainer extends StatelessWidget {
  final Widget? head;
  final Widget? body;

  const DialogContainer({super.key, this.head, this.body});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (head == null) {
      return GlassDialog(body: body ?? const SizedBox.shrink());
    }

    // When an arbitrary head widget is supplied, render it inside a custom
    // glass shell so the header area stays visually consistent.
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
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
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
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
                    head!,
                    Divider(
                      color: scheme.onPrimary.withValues(alpha: 0.10),
                      height: 1,
                      thickness: 1,
                    ),
                    if (body != null)
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: body,
                        ),
                      ),
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
