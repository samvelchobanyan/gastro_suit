/// Corner radii. Source: handoff `tokens/radius.css`.
///
/// Use with `BorderRadius.circular(DSRadius.card)`.
abstract final class DSRadius {
  // Scale
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// `--radius-2xl` in the handoff.
  static const double xxl = 32;
  static const double full = 9999;

  // By element
  static const double badge = xs;
  static const double checkbox = xs;
  static const double tag = sm;
  static const double buttonSm = sm;
  static const double tooltip = sm;
  static const double input = md;
  static const double dialog = md;
  static const double card = lg;
  static const double sheet = xl;
  static const double modal = xxl;
  static const double pill = full;
  static const double avatar = full;
}
