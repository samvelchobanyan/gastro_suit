import 'package:flutter/material.dart';

import 'theme/ds_colors.dart';

export 'foundations/ds_elevation.dart';
export 'foundations/ds_motion.dart';
export 'foundations/ds_radius.dart';
export 'foundations/ds_sizes.dart';
export 'foundations/ds_spacing.dart';
export 'foundations/ds_typography.dart';
export 'theme/ds_colors.dart' show DSColors;

/// Import this one file to get every token plus `context.colors`.
///
/// The palette (`DSPalette`) is deliberately not exported: widgets read colour
/// roles, not raw colours.
extension DSContext on BuildContext {
  /// The current colour role set. Colours are read only through this.
  DSColors get colors => Theme.of(this).extension<DSColors>()!;
}
