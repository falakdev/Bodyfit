import 'dart:async';

// Minimal stub for web where native pedometer plugin isn't available.
class StepCount {
  final int steps;
  StepCount(this.steps);
}

class Pedometer {
  // No native support on web; return null stream.
  static Stream<StepCount>? get stepCountStream => null;
}
