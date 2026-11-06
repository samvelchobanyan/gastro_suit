import 'package:flutter/material.dart';

import '../foundations/ds_typography.dart';
import 'ds_colors.dart';

/// Builds the app theme from one colour role set.
///
/// Both Material's colour scheme (for stock widgets: text selection, progress
/// indicators, ripples, inputs) and the [DSColors] extension (for our widgets)
/// are filled from the same [colors], so they cannot drift apart. A dark theme
/// is the same call with a dark role set.
ThemeData buildAppTheme(DSColors colors) {
  final colorScheme = ColorScheme.light(
    primary: colors.brandPrimary,
    onPrimary: colors.textOnBrand,
    secondary: colors.brandPrimary,
    onSecondary: colors.textOnBrand,
    surface: colors.bgSurface,
    onSurface: colors.textPrimary,
    error: colors.statusError,
    onError: colors.textInverse,
    outline: colors.borderDefault,
    outlineVariant: colors.borderMuted,
  );

  // For stock widgets and `Text` without an explicit style. Our own widgets
  // use `DSTypography` directly.
  final textTheme = const TextTheme(
    displaySmall: DSTypography.display,
    headlineSmall: DSTypography.h1,
    titleLarge: DSTypography.h2,
    titleMedium: DSTypography.h3,
    titleSmall: DSTypography.bodySemibold,
    bodyLarge: DSTypography.bodyLg,
    bodyMedium: DSTypography.body,
    bodySmall: DSTypography.bodySm,
    labelLarge: DSTypography.bodySemibold,
    labelMedium: DSTypography.bodySmSemibold,
    labelSmall: DSTypography.bodyXs,
  ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: DSTypography.fontFamily,
    textTheme: textTheme,
    scaffoldBackgroundColor: colors.bgMain,
    extensions: [colors],
  );
}
