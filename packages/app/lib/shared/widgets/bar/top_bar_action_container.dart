/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class TopBarActionContainer extends StatefulWidget {
  final void Function()? onPressed;
  final Widget? child;
  final bool colorInverted;
  final Duration delay;

  const TopBarActionContainer({
    super.key,
    this.onPressed,
    required this.child,
    this.colorInverted = false,
    this.delay = const Duration(milliseconds: 200)
  });

  @override
  State<TopBarActionContainer> createState() => _TopBarActionContainerState();
}

class _TopBarActionContainerState extends State<TopBarActionContainer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      widget.colorInverted
                          ? scheme.onPrimary.withValues(alpha: 0.86)
                          : scheme.primary.withValues(alpha: 0.72),
                  border: Border.all(
                    color:
                        widget.colorInverted
                            ? scheme.primary.withValues(alpha: 0.20)
                            : scheme.onPrimary.withValues(alpha: 0.16),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  shape: const CircleBorder(),
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: widget.onPressed,
                    child: Center(child: widget.child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
