import 'package:flutter/animation.dart';

/// Durations and curves of transitions. Source: handoff `tokens/motion.css`;
/// only the ones a component uses are here.
abstract final class DSMotion {
  /// The default transition.
  static const Duration base = Duration(milliseconds: 200);

  /// Enters and settles; the default curve.
  static const Curve standard = Cubic(0.2, 0, 0, 1);
}
