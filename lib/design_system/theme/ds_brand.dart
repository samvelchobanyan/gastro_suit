import 'package:flutter/material.dart';

/// The brand layer: the only visual values that differ between clients.
///
/// Source: handoff `tokens/brand.css` (accent ramp) and the brand roles of
/// `tokens/semantic.css`. Read only through `Theme.of(context)` (see
/// `context.brand`), never by importing a concrete brand — otherwise the
/// element drops out of the re-skin.
@immutable
class DSBrand extends ThemeExtension<DSBrand> {
  const DSBrand({
    required this.accent50,
    required this.accent100,
    required this.accent200,
    required this.accent300,
    required this.accent400,
    required this.accent500,
    required this.accent600,
    required this.accent700,
    required this.accent800,
    required this.accent900,
    required this.accentContrast,
  });

  final Color accent50;
  final Color accent100;
  final Color accent200;
  final Color accent300;
  final Color accent400;
  final Color accent500;
  final Color accent600;
  final Color accent700;
  final Color accent800;
  final Color accent900;

  /// Foreground on an accent fill (500 and darker).
  final Color accentContrast;

  // Brand roles
  Color get brandPrimary => accent500;
  Color get brandInteractive => accent600;
  Color get brandSubtle => accent50;
  Color get textAccent => accent600;
  Color get textOnBrand => accentContrast;
  Color get borderInteractive => accent500;
  Color get focusRing => accent500;

  @override
  DSBrand copyWith({
    Color? accent50,
    Color? accent100,
    Color? accent200,
    Color? accent300,
    Color? accent400,
    Color? accent500,
    Color? accent600,
    Color? accent700,
    Color? accent800,
    Color? accent900,
    Color? accentContrast,
  }) {
    return DSBrand(
      accent50: accent50 ?? this.accent50,
      accent100: accent100 ?? this.accent100,
      accent200: accent200 ?? this.accent200,
      accent300: accent300 ?? this.accent300,
      accent400: accent400 ?? this.accent400,
      accent500: accent500 ?? this.accent500,
      accent600: accent600 ?? this.accent600,
      accent700: accent700 ?? this.accent700,
      accent800: accent800 ?? this.accent800,
      accent900: accent900 ?? this.accent900,
      accentContrast: accentContrast ?? this.accentContrast,
    );
  }

  @override
  DSBrand lerp(DSBrand? other, double t) {
    if (other == null) return this;
    return DSBrand(
      accent50: Color.lerp(accent50, other.accent50, t)!,
      accent100: Color.lerp(accent100, other.accent100, t)!,
      accent200: Color.lerp(accent200, other.accent200, t)!,
      accent300: Color.lerp(accent300, other.accent300, t)!,
      accent400: Color.lerp(accent400, other.accent400, t)!,
      accent500: Color.lerp(accent500, other.accent500, t)!,
      accent600: Color.lerp(accent600, other.accent600, t)!,
      accent700: Color.lerp(accent700, other.accent700, t)!,
      accent800: Color.lerp(accent800, other.accent800, t)!,
      accent900: Color.lerp(accent900, other.accent900, t)!,
      accentContrast: Color.lerp(accentContrast, other.accentContrast, t)!,
    );
  }
}
