/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class GlassPopupMenuButton<T> extends StatelessWidget {
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final String? tooltip;
  final Widget? icon;
  final Offset offset;
  final PopupMenuPosition position;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;

  const GlassPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.tooltip,
    this.icon,
    this.offset = Offset.zero,
    this.position = PopupMenuPosition.under,
    this.enabled = true,
    this.padding = const EdgeInsets.all(8),
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final trigger = Padding(
      padding: padding,
      child: icon ?? const GlassPopupMenuTriggerIcon(),
    );

    final wrappedTrigger =
        tooltip == null || tooltip!.isEmpty
            ? trigger
            : Tooltip(message: tooltip!, child: trigger);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown:
          !enabled
              ? null
              : (details) async {
                final selected = await showGlassPopupMenu<T>(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx + offset.dx,
                    details.globalPosition.dy + offset.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  items: itemBuilder(context),
                  constraints: constraints,
                  positionMode: position,
                );

                if (selected != null) {
                  onSelected?.call(selected);
                }
              },
      child: wrappedTrigger,
    );
  }
}

Future<T?> showGlassPopupMenu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<PopupMenuEntry<T>> items,
  BoxConstraints? constraints,
  PopupMenuPosition positionMode = PopupMenuPosition.under,
}) {
  return showGeneralDialog<T?>(
    context: context,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _GlassPopupOverlay<T>(
        anchor: position,
        items: items,
        constraints: constraints,
        positionMode: positionMode,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final scale = Tween<double>(
        begin: 0.94,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
      final slide = Tween<Offset>(
        begin: const Offset(0, -0.02),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: slide,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.topLeft,
            child: child,
          ),
        ),
      );
    },
  );
}

PopupMenuItem<T> glassPopupMenuItem<T>({
  Key? key,
  required T value,
  String? label,
  IconData? icon,
  Color? color,
  Widget? child,
  VoidCallback? onTap,
}) {
  assert(label != null || child != null, 'label or child must be provided');

  return PopupMenuItem<T>(
    key: key,
    value: value,
    onTap: onTap,
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: _GlassPopupMenuItemBody(
      label: label,
      icon: icon,
      color: color,
      child: child,
    ),
  );
}

class GlassPopupMenuTriggerIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final EdgeInsets padding;

  const GlassPopupMenuTriggerIcon({
    super.key,
    this.icon = Icons.more_horiz_rounded,
    this.iconSize = 16,
    this.padding = const EdgeInsets.all(7),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.55),
        shape: BoxShape.circle,
        border: Border.all(
          color: scheme.onPrimary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: scheme.onPrimary.withValues(alpha: 0.68),
      ),
    );
  }
}

class _GlassPopupMenuItemBody extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final Color? color;
  final Widget? child;

  const _GlassPopupMenuItemBody({
    this.label,
    this.icon,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final itemColor = color ?? scheme.onPrimary;
    final style = TextStyle(
      color: itemColor,
      fontSize: 14,
      fontVariations: const [FontVariation.weight(560)],
    );

    return IconTheme(
      data: IconThemeData(color: itemColor, size: 18),
      child: DefaultTextStyle(
        style: style,
        child:
            child ??
            Row(
              children: [
                if (icon != null) ...[Icon(icon), const SizedBox(width: 10)],
                Text(label!),
              ],
            ),
      ),
    );
  }
}

class _GlassPopupOverlay<T> extends StatefulWidget {
  final RelativeRect anchor;
  final List<PopupMenuEntry<T>> items;
  final BoxConstraints? constraints;
  final PopupMenuPosition positionMode;

  const _GlassPopupOverlay({
    required this.anchor,
    required this.items,
    this.constraints,
    required this.positionMode,
  });

  @override
  State<_GlassPopupOverlay<T>> createState() => _GlassPopupOverlayState<T>();
}

class _GlassPopupOverlayState<T> extends State<_GlassPopupOverlay<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _itemsController;
  static const _kItemStaggerDuration = Duration(milliseconds: 420);
  static const _kItemStaggerStartDelay = Duration(milliseconds: 90);

  @override
  void initState() {
    super.initState();
    _itemsController = AnimationController(
      vsync: this,
      duration: _kItemStaggerDuration,
    );
    Future<void>.delayed(_kItemStaggerStartDelay, () {
      if (mounted) {
        _itemsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scheme = Theme.of(context).colorScheme;
    final maxWidth = widget.constraints?.maxWidth ?? 280.0;
    final popupHeight = _estimatedHeight();
    final safeTop = media.padding.top + 8;
    final safeBottom = media.size.height - media.padding.bottom - 8;
    final anchorTop = widget.anchor.top;
    final top =
        widget.positionMode == PopupMenuPosition.over
            ? anchorTop.clamp(safeTop, safeBottom - popupHeight)
            : (anchorTop + 8).clamp(safeTop, safeBottom - popupHeight);
    final left = widget.anchor.left.clamp(8.0, media.size.width - maxWidth - 8);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          left: left,
          top: top,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  constraints:
                      widget.constraints ??
                      const BoxConstraints(minWidth: 180, maxWidth: 280),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.onPrimary.withValues(alpha: 0.14),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildEntries(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    final widgets = <Widget>[];
    final total = widget.items.length;
    var index = 0;

    for (final entry in widget.items) {
      if (entry is PopupMenuDivider) {
        widgets.add(
          Divider(
            height: entry.height,
            thickness: 1,
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.10),
          ),
        );
        continue;
      }

      if (entry is PopupMenuItem<T>) {
        final scheme = Theme.of(context).colorScheme;

        widgets.add(
          _buildAnimatedEntry(
            index: index++,
            total: total,
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: const BoxDecoration(),
                child: InkWell(
                  onTap:
                      entry.enabled
                          ? () => Navigator.of(context).pop(entry.value)
                          : null,
                  splashColor: scheme.onPrimary.withValues(alpha: 0.14),
                  highlightColor: scheme.onPrimary.withValues(alpha: 0.08),
                  hoverColor: scheme.onPrimary.withValues(alpha: 0.06),
                  child: Padding(
                    padding:
                        entry.padding ??
                        const EdgeInsets.symmetric(horizontal: 14),
                    child: SizedBox(
                      height: entry.height,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: entry.child,
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

    return widgets;
  }

  Widget _buildAnimatedEntry({
    required int index,
    required int total,
    required Widget child,
  }) {
    final start =
        total <= 1 ? 0.0 : (index * (0.55 / (total - 1))).clamp(0.0, 0.75);
    final end = (start + 0.38).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: _itemsController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      ),
    );
  }

  double _estimatedHeight() {
    var value = 0.0;
    for (final entry in widget.items) {
      if (entry is PopupMenuItem<T>) {
        value += entry.height;
      } else if (entry is PopupMenuDivider) {
        value += entry.height;
      }
    }
    return value;
  }
}
