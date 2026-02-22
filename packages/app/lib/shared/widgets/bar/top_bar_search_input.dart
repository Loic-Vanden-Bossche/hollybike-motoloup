/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:flutter/material.dart';

class TopBarSearchInput extends StatefulWidget {
  final String? defaultValue;
  final FocusNode? focusNode;
  final void Function(String) onSearchRequested;

  const TopBarSearchInput({
    super.key,
    required this.onSearchRequested,
    this.focusNode,
    this.defaultValue,
  });

  @override
  State<TopBarSearchInput> createState() => _TopBarSearchInputState();
}

class _TopBarSearchInputState extends State<TopBarSearchInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _changeDebounce;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: scheme.onPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: scheme.onPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TextFormField(
              focusNode: _focusNode,
              textAlignVertical: TextAlignVertical.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: scheme.onPrimary.withValues(alpha: 0.86),
              ),
              onEditingComplete: _handleEditingCompletion,
              onTapOutside: _handleOutsideTap,
              onChanged: _handleChange,
              decoration: InputDecoration(
                hintText: "Recherche",
                hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: scheme.onPrimary.withValues(alpha: 0.45),
                ),
                constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                isDense: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: scheme.onPrimary.withValues(alpha: 0.52),
                  size: constraints.maxHeight * 0.6,
                ),
                border: InputBorder.none,
              ),
              controller: _controller,
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _requestSearch() {
    final text = _controller.text;
    if (text.isNotEmpty) widget.onSearchRequested(text);
  }

  void _stopActiveDebounce() {
    if (_changeDebounce == null || !_changeDebounce!.isActive) return;
    _changeDebounce?.cancel();
  }

  void _handleEditingCompletion() {
    _stopActiveDebounce();
    _requestSearch();
    _focusNode.unfocus();
  }

  void _handleOutsideTap(PointerDownEvent _) {
    _stopActiveDebounce();
    _requestSearch();
    _focusNode.unfocus();
  }

  void _handleChange(String _) {
    _stopActiveDebounce();
    _changeDebounce = Timer(const Duration(milliseconds: 500), _requestSearch);
  }
}
