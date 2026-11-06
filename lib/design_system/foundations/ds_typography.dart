import 'package:flutter/painting.dart';

/// Text styles. Source: handoff `tokens/typography.css` (composite `--text-*`).
///
/// Styles carry no colour: the colour is a role from `context.colors`, applied
/// on use. CSS line heights are pixels; Flutter takes a multiplier, so
/// `height` is lineHeight / fontSize, and the extra space is split evenly
/// above and below as in CSS.
abstract final class DSTypography {
  static const String fontFamily = 'PlusJakartaSans';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: bold,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: bold,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: bold,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: bold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: regular,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle bodyLgMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: medium,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle bodyLgSemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: semibold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: regular,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: medium,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle bodySemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: semibold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: regular,
    leadingDistribution: TextLeadingDistribution.even,
  );
  static const TextStyle bodySmSemibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: semibold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle bodyXs = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 14 / 10,
    fontWeight: regular,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: regular,
    leadingDistribution: TextLeadingDistribution.even,
  );

  /// Shown in upper case: apply `toUpperCase()` to the text.
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: semibold,
    letterSpacing: 10 * 0.08,
    leadingDistribution: TextLeadingDistribution.even,
  );
}
