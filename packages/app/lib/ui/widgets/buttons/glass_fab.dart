/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class GlassFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const GlassFab({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<GlassFab> createState() => _GlassFabState();
}

class _GlassFabState extends State<GlassFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(999);
    final baseShadow = [
      BoxShadow(
        color: scheme.secondary.withValues(alpha: _isPressed ? 0.12 : 0.18),
        blurRadius: _isPressed ? 14 : 26,
        spreadRadius: _isPressed ? 0 : 1,
        offset: Offset(0, _isPressed ? 4 : 8),
      ),
      const BoxShadow(
        color: Color(0x26000000),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ];

    return Semantics(
      button: true,
      label: widget.label,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(begin: 1, end: _isPressed ? 0.975 : 1),
        builder:
            (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.onPrimary.withValues(alpha: 0.20),
                scheme.secondary.withValues(alpha: 0.16),
                scheme.onPrimary.withValues(alpha: 0.06),
              ],
            ),
            boxShadow: baseShadow,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  onHighlightChanged:
                      (pressed) => setState(() => _isPressed = pressed),
                  splashFactory: InkRipple.splashFactory,
                  splashColor: scheme.onPrimary.withValues(alpha: 0.09),
                  highlightColor: Colors.transparent,
                  customBorder: const StadiumBorder(),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  scheme.primary.withValues(
                                    alpha: _isPressed ? 0.34 : 0.42,
                                  ),
                                  scheme.primaryContainer.withValues(
                                    alpha: _isPressed ? 0.24 : 0.32,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              border: Border.all(
                                color: scheme.onPrimary.withValues(
                                  alpha: _isPressed ? 0.12 : 0.18,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Container(
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    scheme.onPrimary.withValues(
                                      alpha: _isPressed ? 0.12 : 0.18,
                                    ),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -22,
                          right: -10,
                          child: IgnorePointer(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 26,
                                sigmaY: 26,
                              ),
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.secondary.withValues(alpha: 0.22),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -12,
                          child: IgnorePointer(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 24,
                                sigmaY: 24,
                              ),
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.tertiary.withValues(alpha: 0.18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(minHeight: 54),
                          padding: const EdgeInsets.fromLTRB(14, 10, 18, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.secondary.withValues(alpha: 0.16),
                                  border: Border.all(
                                    color: scheme.onPrimary.withValues(alpha: 0.22),
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  size: 18,
                                  color: scheme.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.label,
                                style: TextStyle(
                                  color: scheme.onPrimary,
                                  fontSize: 14,
                                  letterSpacing: 0.18,
                                  fontVariations: const [
                                    FontVariation.weight(700),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
