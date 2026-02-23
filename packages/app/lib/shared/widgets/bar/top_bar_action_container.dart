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

  const TopBarActionContainer({
    super.key,
    this.onPressed,
    required this.child,
    this.colorInverted = false,
  });

  @override
  State<TopBarActionContainer> createState() => _TopBarActionContainerState();
}

class _TopBarActionContainerState extends State<TopBarActionContainer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: _animation,
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
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
