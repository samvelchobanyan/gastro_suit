import 'package:flutter/material.dart';

import '../foundations/ds_palette.dart';

/// Colour roles: what each colour is for.
///
/// Source: handoff `tokens/semantic.css`. A set of roles travels in the theme
/// and is read through `context.colors`, so that a second set (e.g. a dark
/// theme) can replace it without touching widgets. The values live in role
/// sets such as [lightColors], filled from `DSPalette`.
@immutable
class DSColors extends ThemeExtension<DSColors> {
  const DSColors({
    required this.bgCanvas,
    required this.bgMain,
    required this.bgSurface,
    required this.bgSurfaceSunken,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.bgInverse,
    required this.bgScrim,
    required this.brandPrimary,
    required this.brandInteractive,
    required this.brandSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textInverse,
    required this.textAccent,
    required this.textOnBrand,
    required this.borderMuted,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderInteractive,
    required this.focusRing,
    required this.statusSuccess,
    required this.bgSuccess,
    required this.borderSuccess,
    required this.textSuccess,
    required this.statusWarning,
    required this.bgWarning,
    required this.borderWarning,
    required this.textWarning,
    required this.statusError,
    required this.bgError,
    required this.borderError,
    required this.textError,
    required this.statusInfo,
    required this.bgInfo,
    required this.borderInfo,
    required this.textInfo,
    required this.overlayPressDark,
    required this.overlayPressLight,
    required this.overlayHoverDark,
    required this.handleOnDark,
    required this.glassBg,
    required this.glassBorder,
    required this.scrimHero,
  });

  // Backgrounds
  /// App canvas behind surfaces.
  final Color bgCanvas;
  final Color bgMain;

  /// Cards, sheets.
  final Color bgSurface;

  /// Recessed areas, placeholders.
  final Color bgSurfaceSunken;

  /// Loading placeholders (handoff `Skeleton`): the shape's fill and the
  /// lighter band that sweeps across it.
  final Color skeletonBase;
  final Color skeletonHighlight;

  /// Dark surfaces.
  final Color bgInverse;

  /// Dim behind modals.
  final Color bgScrim;

  // Brand
  /// Main brand fill.
  final Color brandPrimary;

  /// Brand fill, pressed.
  final Color brandInteractive;

  /// Brand-tinted surfaces.
  final Color brandSubtle;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  /// Text on dark surfaces.
  final Color textInverse;

  /// Brand-coloured text.
  final Color textAccent;

  /// Text on a brand fill.
  final Color textOnBrand;

  // Borders and focus
  final Color borderMuted;
  final Color borderDefault;
  final Color borderStrong;
  final Color borderInteractive;
  final Color focusRing;

  // Status: success
  final Color statusSuccess;
  final Color bgSuccess;
  final Color borderSuccess;
  final Color textSuccess;

  // Status: warning
  final Color statusWarning;
  final Color bgWarning;
  final Color borderWarning;
  final Color textWarning;

  // Status: error
  final Color statusError;
  final Color bgError;
  final Color borderError;
  final Color textError;

  // Status: info
  final Color statusInfo;
  final Color bgInfo;
  final Color borderInfo;
  final Color textInfo;

  // State overlays
  /// Press overlay on light fills.
  final Color overlayPressDark;

  /// Press overlay on dark fills.
  final Color overlayPressLight;
  final Color overlayHoverDark;

  /// A sheet's drag handle where it lies over a photo or a dark fill.
  final Color handleOnDark;

  /// A frosted-glass surface floating over content, and its edge.
  final Color glassBg;
  final Color glassBorder;

  /// Bottom-up scrim over hero photos.
  final LinearGradient scrimHero;

  @override
  DSColors copyWith({
    Color? bgCanvas,
    Color? bgMain,
    Color? bgSurface,
    Color? bgSurfaceSunken,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? bgInverse,
    Color? bgScrim,
    Color? brandPrimary,
    Color? brandInteractive,
    Color? brandSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textInverse,
    Color? textAccent,
    Color? textOnBrand,
    Color? borderMuted,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderInteractive,
    Color? focusRing,
    Color? statusSuccess,
    Color? bgSuccess,
    Color? borderSuccess,
    Color? textSuccess,
    Color? statusWarning,
    Color? bgWarning,
    Color? borderWarning,
    Color? textWarning,
    Color? statusError,
    Color? bgError,
    Color? borderError,
    Color? textError,
    Color? statusInfo,
    Color? bgInfo,
    Color? borderInfo,
    Color? textInfo,
    Color? overlayPressDark,
    Color? overlayPressLight,
    Color? overlayHoverDark,
    Color? handleOnDark,
    Color? glassBg,
    Color? glassBorder,
    LinearGradient? scrimHero,
  }) {
    return DSColors(
      bgCanvas: bgCanvas ?? this.bgCanvas,
      bgMain: bgMain ?? this.bgMain,
      bgSurface: bgSurface ?? this.bgSurface,
      bgSurfaceSunken: bgSurfaceSunken ?? this.bgSurfaceSunken,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      bgInverse: bgInverse ?? this.bgInverse,
      bgScrim: bgScrim ?? this.bgScrim,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandInteractive: brandInteractive ?? this.brandInteractive,
      brandSubtle: brandSubtle ?? this.brandSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverse: textInverse ?? this.textInverse,
      textAccent: textAccent ?? this.textAccent,
      textOnBrand: textOnBrand ?? this.textOnBrand,
      borderMuted: borderMuted ?? this.borderMuted,
      borderDefault: borderDefault ?? this.borderDefault,
      borderStrong: borderStrong ?? this.borderStrong,
      borderInteractive: borderInteractive ?? this.borderInteractive,
      focusRing: focusRing ?? this.focusRing,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      bgSuccess: bgSuccess ?? this.bgSuccess,
      borderSuccess: borderSuccess ?? this.borderSuccess,
      textSuccess: textSuccess ?? this.textSuccess,
      statusWarning: statusWarning ?? this.statusWarning,
      bgWarning: bgWarning ?? this.bgWarning,
      borderWarning: borderWarning ?? this.borderWarning,
      textWarning: textWarning ?? this.textWarning,
      statusError: statusError ?? this.statusError,
      bgError: bgError ?? this.bgError,
      borderError: borderError ?? this.borderError,
      textError: textError ?? this.textError,
      statusInfo: statusInfo ?? this.statusInfo,
      bgInfo: bgInfo ?? this.bgInfo,
      borderInfo: borderInfo ?? this.borderInfo,
      textInfo: textInfo ?? this.textInfo,
      overlayPressDark: overlayPressDark ?? this.overlayPressDark,
      overlayPressLight: overlayPressLight ?? this.overlayPressLight,
      overlayHoverDark: overlayHoverDark ?? this.overlayHoverDark,
      handleOnDark: handleOnDark ?? this.handleOnDark,
      glassBg: glassBg ?? this.glassBg,
      glassBorder: glassBorder ?? this.glassBorder,
      scrimHero: scrimHero ?? this.scrimHero,
    );
  }

  @override
  DSColors lerp(DSColors? other, double t) {
    if (other == null) return this;
    return DSColors(
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bgMain: Color.lerp(bgMain, other.bgMain, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgSurfaceSunken: Color.lerp(bgSurfaceSunken, other.bgSurfaceSunken, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
      bgInverse: Color.lerp(bgInverse, other.bgInverse, t)!,
      bgScrim: Color.lerp(bgScrim, other.bgScrim, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandInteractive: Color.lerp(
        brandInteractive,
        other.brandInteractive,
        t,
      )!,
      brandSubtle: Color.lerp(brandSubtle, other.brandSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderInteractive: Color.lerp(
        borderInteractive,
        other.borderInteractive,
        t,
      )!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      bgSuccess: Color.lerp(bgSuccess, other.bgSuccess, t)!,
      borderSuccess: Color.lerp(borderSuccess, other.borderSuccess, t)!,
      textSuccess: Color.lerp(textSuccess, other.textSuccess, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      bgWarning: Color.lerp(bgWarning, other.bgWarning, t)!,
      borderWarning: Color.lerp(borderWarning, other.borderWarning, t)!,
      textWarning: Color.lerp(textWarning, other.textWarning, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      bgError: Color.lerp(bgError, other.bgError, t)!,
      borderError: Color.lerp(borderError, other.borderError, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      bgInfo: Color.lerp(bgInfo, other.bgInfo, t)!,
      borderInfo: Color.lerp(borderInfo, other.borderInfo, t)!,
      textInfo: Color.lerp(textInfo, other.textInfo, t)!,
      overlayPressDark: Color.lerp(
        overlayPressDark,
        other.overlayPressDark,
        t,
      )!,
      overlayPressLight: Color.lerp(
        overlayPressLight,
        other.overlayPressLight,
        t,
      )!,
      overlayHoverDark: Color.lerp(
        overlayHoverDark,
        other.overlayHoverDark,
        t,
      )!,
      handleOnDark: Color.lerp(handleOnDark, other.handleOnDark, t)!,
      glassBg: Color.lerp(glassBg, other.glassBg, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      scrimHero: LinearGradient.lerp(scrimHero, other.scrimHero, t)!,
    );
  }
}

/// The light role set — the only one so far.
const lightColors = DSColors(
  bgCanvas: DSPalette.gray50,
  bgMain: DSPalette.gray0,
  bgSurface: DSPalette.gray0,
  bgSurfaceSunken: DSPalette.gray100,
  skeletonBase: DSPalette.gray100,
  skeletonHighlight: DSPalette.gray200,
  bgInverse: DSPalette.gray900,
  bgScrim: DSPalette.alphaBlack40,
  brandPrimary: DSPalette.accent500,
  brandInteractive: DSPalette.accent600,
  brandSubtle: DSPalette.accent50,
  textPrimary: DSPalette.gray900,
  textSecondary: DSPalette.gray700,
  textTertiary: DSPalette.gray600,
  textDisabled: DSPalette.gray500,
  textInverse: DSPalette.gray0,
  textAccent: DSPalette.accent600,
  textOnBrand: DSPalette.accentContrast,
  borderMuted: DSPalette.gray200,
  borderDefault: DSPalette.gray300,
  borderStrong: DSPalette.gray400,
  borderInteractive: DSPalette.accent500,
  focusRing: DSPalette.accent500,
  statusSuccess: DSPalette.green500,
  bgSuccess: DSPalette.green50,
  borderSuccess: DSPalette.green100,
  textSuccess: DSPalette.green700,
  statusWarning: DSPalette.amber500,
  bgWarning: DSPalette.amber50,
  borderWarning: DSPalette.amber100,
  textWarning: DSPalette.amber700,
  statusError: DSPalette.red500,
  bgError: DSPalette.red50,
  borderError: DSPalette.red100,
  textError: DSPalette.red700,
  statusInfo: DSPalette.blue500,
  bgInfo: DSPalette.blue50,
  borderInfo: DSPalette.blue100,
  textInfo: DSPalette.blue700,
  overlayPressDark: DSPalette.alphaBlack12,
  overlayPressLight: DSPalette.alphaWhite12,
  overlayHoverDark: DSPalette.alphaBlack4,
  handleOnDark: DSPalette.alphaWhite40,
  glassBg: DSPalette.alphaWhite64,
  glassBorder: DSPalette.alphaWhite24,
  scrimHero: LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [DSPalette.alphaBlack78, DSPalette.alphaBlack45, Color(0x00000000)],
    stops: [0, 0.32, 0.62],
  ),
);
