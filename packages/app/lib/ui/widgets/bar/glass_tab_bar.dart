/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class GlassTabItem {
  final IconData icon;
  final String label;

  const GlassTabItem({required this.icon, required this.label});
}

class GlassTabBar extends StatelessWidget {
  final TabController? controller;
  final List<GlassTabItem> items;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry tabBarPadding;

  const GlassTabBar({
    super.key,
    this.controller,
    required this.items,
    this.isScrollable = false,
    this.tabAlignment,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.tabBarPadding = const EdgeInsets.symmetric(horizontal: 4),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: scheme.primary.withValues(alpha: 0.60),
              border: Border.all(
                color: scheme.onPrimary.withValues(alpha: 0.10),
                width: 1,
              ),
            ),
            child: TabBar(
              controller: controller,
              isScrollable: isScrollable,
              tabAlignment: isScrollable ? tabAlignment : null,
              dividerColor: Colors.transparent,
              padding: tabBarPadding,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: scheme.secondary.withValues(alpha: 0.20),
                border: Border.all(
                  color: scheme.secondary.withValues(alpha: 0.30),
                  width: 1,
                ),
              ),
              labelColor: scheme.secondary,
              unselectedLabelColor: scheme.onPrimary.withValues(alpha: 0.55),
              labelStyle: Theme.of(context).textTheme.titleSmall,
              unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              tabs:
                  items
                      .map(
                        (item) => Tab(
                          height: 36,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(item.icon, size: 14),
                                const SizedBox(width: 6),
                                Text(item.label),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
