import 'package:flutter/painting.dart';

/// Raw palette: brand-independent colours by their place in a ramp.
///
/// Source: handoff `tokens/primitives.css`. Prefer the roles in [DSColors];
/// use a primitive only where no role fits. The accent ramp is not here — it
/// is brand-dependent and lives in `DSBrand`.
abstract final class DSPalette {
  // Neutral ramp
  static const Color gray0 = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF7F7F7);
  static const Color gray100 = Color(0xFFF1F1F1);
  static const Color gray200 = Color(0xFFEAEAEA);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFD1D1D1);
  static const Color gray500 = Color(0xFFB3B3B3);
  static const Color gray600 = Color(0xFF8C8C8C);
  static const Color gray700 = Color(0xFF4F4F4F);
  static const Color gray800 = Color(0xFF383838);
  static const Color gray900 = Color(0xFF232323);
  static const Color gray950 = Color(0xFF171717);
  static const Color gray1000 = Color(0xFF000000);

  // Success (green)
  static const Color green50 = Color(0xFFEBFBEE);
  static const Color green100 = Color(0xFFD3F9D8);
  static const Color green500 = Color(0xFF2F9E44);
  static const Color green600 = Color(0xFF2B8A3E);
  static const Color green700 = Color(0xFF237032);

  // Warning (amber)
  static const Color amber50 = Color(0xFFFFF9DB);
  static const Color amber100 = Color(0xFFFFF3BF);
  static const Color amber500 = Color(0xFFF08C00);
  static const Color amber600 = Color(0xFFE67700);
  static const Color amber700 = Color(0xFFB35A00);

  // Error (red)
  static const Color red50 = Color(0xFFFFF5F5);
  static const Color red100 = Color(0xFFFFE3E3);
  static const Color red500 = Color(0xFFE03131);
  static const Color red600 = Color(0xFFC92A2A);
  static const Color red700 = Color(0xFFA51F1F);

  // Info (blue)
  static const Color blue50 = Color(0xFFE7F5FF);
  static const Color blue100 = Color(0xFFD0EBFF);
  static const Color blue500 = Color(0xFF1971C2);
  static const Color blue600 = Color(0xFF1864AB);
  static const Color blue700 = Color(0xFF145591);

  // Alpha overlays
  static const Color alphaBlack4 = Color(0x0A000000);
  static const Color alphaBlack8 = Color(0x14000000);
  static const Color alphaBlack12 = Color(0x1F000000);
  static const Color alphaBlack40 = Color(0x66000000);
  static const Color alphaBlack45 = Color(0x73000000);
  static const Color alphaBlack60 = Color(0x99000000);
  static const Color alphaBlack78 = Color(0xC7000000);
  static const Color alphaWhite8 = Color(0x14FFFFFF);
  static const Color alphaWhite12 = Color(0x1FFFFFFF);
  static const Color alphaWhite24 = Color(0x3DFFFFFF);
  // Used by the handoff (ProductOverlay grabber) but missing from its tokens.
  static const Color alphaWhite40 = Color(0x66FFFFFF);
  static const Color alphaWhite64 = Color(0xA3FFFFFF);
  static const Color alphaWhite80 = Color(0xCCFFFFFF);
}

/// Colour roles that do not depend on the brand.
///
/// Source: handoff `tokens/semantic.css`. Brand roles (primary, interactive,
/// accent text, focus) live in `DSBrand`.
abstract final class DSColors {
  // Backgrounds
  static const Color bgCanvas = DSPalette.gray50;
  static const Color bgMain = DSPalette.gray0;
  static const Color bgSurface = DSPalette.gray0;
  static const Color bgSurfaceSunken = DSPalette.gray100;
  static const Color bgInverse = DSPalette.gray900;
  static const Color bgScrim = DSPalette.alphaBlack40;

  /// Bottom-up scrim over hero photos.
  static const LinearGradient scrimHero = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [DSPalette.alphaBlack78, DSPalette.alphaBlack45, Color(0x00000000)],
    stops: [0, 0.32, 0.62],
  );

  // Text
  static const Color textPrimary = DSPalette.gray900;
  static const Color textSecondary = DSPalette.gray700;
  static const Color textTertiary = DSPalette.gray600;
  static const Color textDisabled = DSPalette.gray500;
  static const Color textInverse = DSPalette.gray0;

  // Borders and dividers
  static const Color borderMuted = DSPalette.gray200;
  static const Color borderDefault = DSPalette.gray300;
  static const Color borderStrong = DSPalette.gray400;

  // Status: success
  static const Color statusSuccess = DSPalette.green500;
  static const Color bgSuccess = DSPalette.green50;
  static const Color borderSuccess = DSPalette.green100;
  static const Color textSuccess = DSPalette.green700;

  // Status: warning
  static const Color statusWarning = DSPalette.amber500;
  static const Color bgWarning = DSPalette.amber50;
  static const Color borderWarning = DSPalette.amber100;
  static const Color textWarning = DSPalette.amber700;

  // Status: error
  static const Color statusError = DSPalette.red500;
  static const Color bgError = DSPalette.red50;
  static const Color borderError = DSPalette.red100;
  static const Color textError = DSPalette.red700;

  // Status: info
  static const Color statusInfo = DSPalette.blue500;
  static const Color bgInfo = DSPalette.blue50;
  static const Color borderInfo = DSPalette.blue100;
  static const Color textInfo = DSPalette.blue700;

  // State overlays
  static const Color overlayPressDark = DSPalette.alphaBlack12;
  static const Color overlayPressLight = DSPalette.alphaWhite12;
  static const Color overlayHoverDark = DSPalette.alphaBlack4;

  /// Opacity of a disabled element.
  static const double disabledOpacity = 0.35;
}
