import 'dart:math' as math;

class ExponentialBackoff {
  ExponentialBackoff({
    required this.baseDelay,
    required this.maxDelay,
    this.maxJitterMilliseconds = 0,
    this.maxExponent = 10,
    math.Random? random,
  }) : _random = random ?? math.Random();

  final Duration baseDelay;
  final Duration maxDelay;
  final int maxJitterMilliseconds;
  final int maxExponent;
  final math.Random _random;

  int _attempt = 0;

  Duration nextDelay() {
    final exponent = _attempt.clamp(0, maxExponent);
    final exponentialFactor = 1 << exponent;
    final baseMs = baseDelay.inMilliseconds * exponentialFactor;
    final cappedMs = math.min(baseMs, maxDelay.inMilliseconds);
    final jitterMs =
        maxJitterMilliseconds > 0
            ? _random.nextInt(maxJitterMilliseconds + 1)
            : 0;

    _attempt += 1;
    return Duration(milliseconds: cappedMs + jitterMs);
  }

  void reset() {
    _attempt = 0;
  }
}
