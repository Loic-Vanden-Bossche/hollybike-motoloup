import 'package:flutter/material.dart';

class EmptyStatePlaceholder extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData actionIcon;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  const EmptyStatePlaceholder({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.actionIcon = Icons.add_a_photo_outlined,
    this.icon = Icons.photo_library_outlined,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasAction = onAction != null && actionLabel != null;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primaryContainer.withValues(alpha: 0.50),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmptyStateIcon(icon: icon),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.75),
              fontSize: 14,
              fontVariations: const [FontVariation.weight(550)],
            ),
          ),
          if (hasAction) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: scheme.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.40),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      actionIcon,
                      size: 15,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      actionLabel!,
                      style: TextStyle(
                        color: scheme.secondary,
                        fontSize: 13,
                        fontVariations: const [FontVariation.weight(650)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (subtitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onPrimary.withValues(alpha: 0.45),
                  fontSize: 13,
                  fontVariations: const [FontVariation.weight(450)],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyStateIcon extends StatefulWidget {
  final IconData icon;

  const _EmptyStateIcon({required this.icon});

  @override
  State<_EmptyStateIcon> createState() => _EmptyStateIconState();
}

class _EmptyStateIconState extends State<_EmptyStateIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primaryContainer.withValues(alpha: 0.60),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.30),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.secondary.withValues(alpha: 0.15),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 30,
            color: scheme.secondary,
          ),
        ),
      ),
    );
  }
}
