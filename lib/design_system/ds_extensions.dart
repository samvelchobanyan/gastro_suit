import 'package:flutter/material.dart';

import 'theme/ds_brand.dart';

export 'foundations/ds_colors.dart';
export 'foundations/ds_elevation.dart';
export 'foundations/ds_radius.dart';
export 'foundations/ds_sizes.dart';
export 'foundations/ds_spacing.dart';
export 'foundations/ds_typography.dart';
export 'theme/ds_brand.dart';

/// Context aliases for the design system.
///
/// Import this one file to get every token plus `context.brand`.
extension DSContext on BuildContext {
  /// The current brand. Brand values are read only through this.
  DSBrand get brand => Theme.of(this).extension<DSBrand>()!;
}
