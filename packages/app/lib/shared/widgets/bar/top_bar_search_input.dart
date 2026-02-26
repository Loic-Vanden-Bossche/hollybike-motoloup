/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';
import 'dart:ui';

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
    final hasValue = _controller.text.trim().isNotEmpty;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: scheme.primary.withValues(alpha: 0.60),
                border: Border.all(
                  color: scheme.onPrimary.withValues(alpha: 0.10),
                  width: 1,
                ),
              ),
              child: TextFormField(
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
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
                    color: scheme.onPrimary.withValues(alpha: 0.55),
                  ),
                  contentPadding: const EdgeInsets.only(right: 10),
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: scheme.secondary,
                    size: 17,
                  ),
                  suffixIcon:
                      hasValue
                          ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: scheme.onPrimary.withValues(alpha: 0.55),
                              size: 16,
                            ),
                            splashRadius: 16,
                            onPressed: _handleClear,
                          )
                          : null,
                  border: InputBorder.none,
                ),
                controller: _controller,
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
    _controller = TextEditingController(text: widget.defaultValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_handleControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant TopBarSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultValue == widget.defaultValue) return;
    final nextValue = widget.defaultValue ?? '';
    if (_controller.text == nextValue) return;
    _controller.value = TextEditingValue(
      text: nextValue,
      selection: TextSelection.collapsed(offset: nextValue.length),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerUpdate);
    _changeDebounce?.cancel();
    _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _requestSearch() {
    final text = _controller.text.trim();
    widget.onSearchRequested(text);
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
    _changeDebounce = Timer(const Duration(milliseconds: 350), _requestSearch);
  }

  void _handleClear() {
    _stopActiveDebounce();
    _controller.clear();
    widget.onSearchRequested('');
    _focusNode.requestFocus();
  }

  void _handleControllerUpdate() {
    if (!mounted) return;
    setState(() {});
  }
}
