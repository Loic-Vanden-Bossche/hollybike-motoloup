/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class TabDropdownEntry {
  final String title;
  final IconData icon;

  const TabDropdownEntry({required this.title, required this.icon});
}

class TopBarTabDropdown extends StatefulWidget {
  final List<TabDropdownEntry> entries;
  final TabController controller;

  const TopBarTabDropdown({
    super.key,
    required this.entries,
    required this.controller,
  });

  @override
  State<TopBarTabDropdown> createState() => _TopBarTabDropdownState();
}

class _TopBarTabDropdownState extends State<TopBarTabDropdown> {
  late final TextEditingController controller;
  late final GlobalKey _menuKey;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: scheme.onPrimary.withValues(alpha: 0.08),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu(
                  key: _menuKey,
                  controller: controller,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.86),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.only(left: 16),
                    border: InputBorder.none,
                  ),
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: scheme.onPrimary.withValues(alpha: 0.58),
                  ),
                  menuStyle: MenuStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(scheme.primary),
                  ),
                  onSelected: _handleSelectedValueChange,
                  dropdownMenuEntries: _renderMenuEntries(),
                );
              },
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: openDropdown,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDropdown() {
    TextField? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget is TextField) {
          detector = element.widget as TextField;
          return;
        } else {
          searchForGestureDetector(element);
        }

        return;
      });
    }

    final context = _menuKey.currentContext;

    if (context == null) {
      return;
    }

    searchForGestureDetector(context);

    if (detector == null) {
      return;
    }

    detector?.onTap?.call();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.entries[widget.controller.index].title,
    );

    _menuKey = GlobalKey();

    _currentTab = widget.controller.index;

    widget.controller.animation?.addListener(_updateTitle);
  }

  @override
  void dispose() {
    controller.dispose();
    widget.controller.animation?.removeListener(_updateTitle);
    super.dispose();
  }

  void _updateTitle() {
    final newTab = widget.controller.animation!.value.round();

    if (_currentTab != newTab) {
      controller.value = controller.value.copyWith(
        text: widget.entries[newTab].title,
      );

      setState(() {
        _currentTab = newTab;
      });
    }
  }

  List<DropdownMenuEntry<int>> _renderMenuEntries() {
    final entries = <DropdownMenuEntry<int>>[];
    for (int i = 0; i < widget.entries.length; i++) {
      entries.add(
        DropdownMenuEntry(
          value: i,
          labelWidget: Text(widget.entries[i].title),
          trailingIcon: Icon(widget.entries[i].icon),
          label: widget.entries[i].title,
        ),
      );
    }
    return entries;
  }

  void _handleSelectedValueChange(int? value) {
    widget.controller.animateTo(value as int);
  }
}
