/// Spacing scale for gaps and padding. Source: handoff `tokens/spacing.css`.
///
/// Names match the handoff (`--space-md` → [md]).
abstract final class DSSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Screen layout metrics. Source: handoff `tokens/spacing.css`, `LAYOUT_RULES.md`.
abstract final class DSLayout {
  /// Left and right screen margin.
  static const double margin = 16;

  /// Space between columns.
  static const double gutter = 8;

  /// Gap between a headline and its description.
  static const double gapText = 8;

  /// Gap between independent content blocks.
  static const double gapBlock = 16;
}
