import 'package:flutter/painting.dart';

/// Raw palette: colours by their place in a ramp, with no meaning attached.
///
/// Source: handoff `tokens/primitives.css` and `tokens/brand.css`. Widgets do
/// not use the palette; they read colour roles through `context.colors`. The
/// palette is used only to fill the role sets in `design_system/theme/`.
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

  // Accent ramp — the client's brand colour. Source: handoff `tokens/brand.css`
  // (Coffee House).
  static const Color accent50 = Color(0xFFFDECEC);
  static const Color accent100 = Color(0xFFFBD5D6);
  static const Color accent200 = Color(0xFFF6A9AC);
  static const Color accent300 = Color(0xFFF27E82);
  static const Color accent400 = Color(0xFFF04C54);
  static const Color accent500 = Color(0xFFED1D25);
  static const Color accent600 = Color(0xFFC9161D);
  static const Color accent700 = Color(0xFF9F1116);
  static const Color accent800 = Color(0xFF760C10);
  static const Color accent900 = Color(0xFF4D080A);

  /// Foreground on an accent fill (500 and darker).
  static const Color accentContrast = Color(0xFFFFFFFF);

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
