import 'package:flutter/animation.dart';

/// Durations and curves of transitions. Source: handoff `tokens/motion.css`;
/// only the ones a component uses are here.
abstract final class DSMotion {
  /// Toggles and checkboxes.
  static const Duration fast = Duration(milliseconds: 150);

  /// The default transition.
  static const Duration base = Duration(milliseconds: 200);

  /// A part of the screen that travels (`--duration-slower`).
  static const Duration slower = Duration(milliseconds: 400);

  /// Enters and settles; the default curve.
  static const Curve standard = Cubic(0.2, 0, 0, 1);

  /// Arrives a little past its place and settles back
  /// (`--ease-emphasized`).
  static const Curve emphasized = Cubic(0.2, 0.8, 0.2, 1.05);
}
