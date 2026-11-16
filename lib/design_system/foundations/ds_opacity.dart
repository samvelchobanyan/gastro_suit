/// Opacities of states. Source: handoff `tokens/semantic.css`
/// (`--state-disabled-opacity`).
abstract final class DSOpacity {
  /// A control that cannot be used now.
  static const double disabled = 0.35;

  // Over a dark fill, drawn with the inverse text colour.
  /// The quieter text.
  static const double quietOnDark = 0.8;

  /// A raised surface: a pill, a panel.
  static const double surfaceOnDark = 0.08;

  /// A dark sheet that lets what is behind it show through.
  static const double darkGlass = 0.78;
}
