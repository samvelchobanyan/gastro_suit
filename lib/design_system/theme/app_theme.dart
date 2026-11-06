import 'package:flutter/material.dart';

import '../foundations/ds_colors.dart';
import '../foundations/ds_typography.dart';
import 'ds_brand.dart';

/// Builds the app theme for one brand.
///
/// Material's colour scheme is filled from the tokens so that stock Material
/// widgets (text selection, progress indicators, ripples) match the design;
/// the brand itself travels as the [DSBrand] extension.
ThemeData buildAppTheme(DSBrand brand) {
  final colorScheme = ColorScheme.light(
    primary: brand.brandPrimary,
    onPrimary: brand.textOnBrand,
    secondary: brand.brandPrimary,
    onSecondary: brand.textOnBrand,
    surface: DSColors.bgSurface,
    onSurface: DSColors.textPrimary,
    error: DSColors.statusError,
    onError: DSColors.textInverse,
    outline: DSColors.borderDefault,
    outlineVariant: DSColors.borderMuted,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: DSTypography.fontFamily,
    scaffoldBackgroundColor: DSColors.bgMain,
    extensions: [brand],
  );
}
