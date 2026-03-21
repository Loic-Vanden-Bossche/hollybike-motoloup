class OneShotGuard {
  bool _consumed = false;

  bool consume() {
    if (_consumed) {
      return false;
    }

    _consumed = true;
    return true;
  }

  bool get isConsumed => _consumed;
}
