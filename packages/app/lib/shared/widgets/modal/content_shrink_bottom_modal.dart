/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class ContentShrinkBottomModal extends StatefulWidget {
  final Widget modalContent;
  final Widget child;
  final bool enableDrag;
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
    this.backgroundColor = Colors.black,
    this.showAppBar = true,
    this.appBarOpacity = 1,
  });

  @override
  State<ContentShrinkBottomModal> createState() =>
      _ContentShrinkBottomModalState();
}

class _ContentShrinkBottomModalState extends State<ContentShrinkBottomModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final CurvedAnimation _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  // Key to measure content's natural height for drag calculations.
  final GlobalKey _contentKey = GlobalKey();

  // Tracks the fully-open state (animation completed), used to hide the
  // "more" button in the AppBar and to notify the parent.
  bool _modalOpened = false;

  bool get _isOpen => _controller.value >= 1.0;

  // Returns the content's natural (unclipped) height for drag-to-fraction maths.
  // SizeTransition lays out the child at full natural size even when sizeFactor < 1,
  // so this is always accurate after the first frame.
  double get _contentNaturalHeight {
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    final h = box?.size.height ?? 0.0;
    return h > 0.0 ? h : 400.0;
  }

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ContentShrinkBottomModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Respond to programmatic open/close from the parent (e.g. image deleted).
    if (_isOpen != widget.modalOpened) {
      if (widget.modalOpened) {
        _openModal();
      } else {
        _closeModal();
      }
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    final isNowOpen = status == AnimationStatus.completed;
    final isNowClosed = status == AnimationStatus.dismissed;
    if (!isNowOpen && !isNowClosed) return;
    if (_modalOpened == isNowOpen) return;
    setState(() => _modalOpened = isNowOpen);
    widget.onStatusChanged?.call(isNowOpen);
  }

  void _openModal() => _controller.forward();
  void _closeModal() => _controller.reverse();

  // ── Drag handlers ───────────────────────────────────────────────────────────

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    // Convert pixel delta to a 0–1 fraction of natural content height.
    final contentH = _contentNaturalHeight;
    _controller.value =
        (_controller.value - details.delta.dy / contentH).clamp(0.0, 1.0);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity > 10) {
      _closeModal();
    } else if (velocity < -10) {
      _openModal();
    } else if (_controller.value > 0.5) {
      _openModal();
    } else {
      _closeModal();
    }
  }

  void _onTapImage() => _closeModal();

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (!didPop) _closeModal();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

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
                leading: _buildLeading(widget.appBarOpacity.clamp(0.0, 1.0)),
                actions: _buildActions(widget.appBarOpacity.clamp(0.0, 1.0)),
              )
              : null,
      body: GestureDetector(
        onVerticalDragUpdate: widget.enableDrag ? _onVerticalDragUpdate : null,
        onVerticalDragEnd: widget.enableDrag ? _onVerticalDragEnd : null,
        child: Container(
          color: widget.backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: _isOpen ? _onTapImage : null,
                  child: widget.child,
                ),
              ),
              // SizeTransition internally wraps the child in
              // ClipRect > Align(heightFactor: sizeFactor.value).
              // The child is always laid out at its full natural height, so
              // _contentKey measurement is always accurate regardless of the
              // current animation fraction.
              SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: PopScope(
                  canPop: !_isOpen,
                  onPopInvokedWithResult: _onPopInvokedWithResult,
                  child: KeyedSubtree(
                    key: _contentKey,
                    child: widget.modalContent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar helpers ───────────────────────────────────────────────────────────

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
          onPressed: () => Navigator.of(context).maybePop(),
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
            onPressed: _openModal,
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ),
      ),
    ];
  }
}
