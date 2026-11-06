import 'package:flutter/painting.dart';

/// Shadows. Source: handoff `tokens/elevation.css`.
///
/// Black-based, so they do not depend on the brand. Use as
/// `BoxDecoration(boxShadow: DSElevation.card)`.
abstract final class DSElevation {
  static const List<BoxShadow> none = [];

  /// Resting surfaces lifted off the canvas (cards, chips).
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x08000000), offset: Offset(0, 1), blurRadius: 1),
  ];

  /// Floating controls (cart bar, dropdown).
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x0D000000), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 12),
  ];

  /// Detached overlays (dialogs, popovers, toasts).
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 8),
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 12), blurRadius: 28),
  ];

  /// Light cast upward from a bottom sheet.
  static const List<BoxShadow> sheet = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, -2), blurRadius: 8),
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, -8), blurRadius: 24),
  ];

  static const List<BoxShadow> card = sm;
  static const List<BoxShadow> raised = md;
  static const List<BoxShadow> overlay = lg;
}
