/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ContentShrinkBottomModal extends StatefulWidget {
  final Widget modalContent;
  final Widget child;
  final bool enableDrag;
  final int maxModalHeight;
  final bool modalOpened;
  final Color backgroundColor;
  final bool showAppBar;
  final double appBarOpacity;
  final void Function(bool opened)? onStatusChanged;

  const ContentShrinkBottomModal({
    super.key,
    required this.modalContent,
    required this.child,
    required this.modalOpened,
    this.onStatusChanged,
    this.enableDrag = true,
    this.maxModalHeight = 300,
    this.backgroundColor = Colors.black,
    this.showAppBar = true,
    this.appBarOpacity = 1,
  });

  @override
  State<ContentShrinkBottomModal> createState() =>
      _ContentShrinkBottomModalState();
}

class _ContentShrinkBottomModalState extends State<ContentShrinkBottomModal> {
  late final double _bottomContainerMaxHeight =
      widget.maxModalHeight.toDouble();
  double _bottomContainerHeight = 0;

  bool _animate = false;
  bool _modalOpened = false;

  bool get modalOpened => _bottomContainerHeight == _bottomContainerMaxHeight;

  bool get modalOpening => _bottomContainerHeight > 0;

  @override
  void didUpdateWidget(covariant ContentShrinkBottomModal oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (modalOpened != widget.modalOpened) {
      if (widget.modalOpened) {
        _onOpened();
      } else {
        _onClosed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar:
          widget.showAppBar
              ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: _buildLeading(widget.appBarOpacity.clamp(0, 1)),
                actions: _buildActions(widget.appBarOpacity.clamp(0, 1)),
              )
              : null,
      body: GestureDetector(
        onVerticalDragUpdate: widget.enableDrag ? _onVerticalDragUpdate : null,
        onVerticalDragEnd: widget.enableDrag ? _onVerticalDragEnd : null,
        onVerticalDragStart: widget.enableDrag ? _onVerticalDragStart : null,
        child: Container(
          color: widget.backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: modalOpened ? _onTapImage : null,
                  child: widget.child,
                ),
              ),
              AnimatedContainer(
                duration:
                    _animate
                        ? const Duration(milliseconds: 250)
                        : Duration.zero,
                curve: Curves.fastOutSlowIn,
                height: _bottomContainerHeight,
                onEnd: _onAnimateEnd,
                width: double.infinity,
                child: PopScope(
                  canPop: !modalOpened,
                  onPopInvokedWithResult: _onPopInvokedWithResult,
                  child:
                      modalOpening
                          ? widget.modalContent
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(double opacity) {
    if (!Navigator.of(context).canPop()) {
      return null;
    }

    return IgnorePointer(
      ignoring: opacity <= 0.01,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        opacity: opacity,
        child: BackButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
    );
  }

  List<Widget>? _buildActions(double opacity) {
    if (_modalOpened || !widget.enableDrag) {
      return null;
    }

    return [
      IgnorePointer(
        ignoring: opacity <= 0.01,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          opacity: opacity,
          child: IconButton(
            onPressed: () {
              _onOpened();
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ),
      ),
    ];
  }

  void _onOpened() {
    _onChangeHeight(_bottomContainerMaxHeight);
  }

  void _onClosed() {
    _onChangeHeight(1);
  }

  void _onChangeHeight(double height) {
    setState(() {
      _bottomContainerHeight = height;
    });

    if (widget.onStatusChanged != null) {
      if (_modalOpened != modalOpened) {
        widget.onStatusChanged!(modalOpened);

        setState(() {
          _modalOpened = modalOpened;
        });
      }
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final delta = _bottomContainerHeight - details.delta.dy;
    _onChangeHeight(delta.clamp(0, _bottomContainerMaxHeight));
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 10) {
      _onClosed();
    } else if (details.primaryVelocity! < -10) {
      _onOpened();
    } else if (_bottomContainerHeight > _bottomContainerMaxHeight / 2) {
      _onOpened();
    } else {
      _onClosed();
    }

    setState(() {
      _animate = true;
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _animate = false;
    });
  }

  void _onTapImage() {
    _onClosed();
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (!didPop) {
      _onClosed();
    }
  }

  void _onAnimateEnd() {
    if (_bottomContainerHeight == 1.0) {
      _onChangeHeight(0);
    }
  }
}
