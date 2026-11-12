import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ds_colors.dart';

/// The colour of the status bar's icons. Only the status bar is styled; the
/// system navigation bar is left as it is.
abstract final class DSStatusBar {
  /// Light icons, for a dark background or a photo under a scrim.
  static const lightIcons = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// Dark icons, for a light background.
  static const darkIcons = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// The icons that read on [background].
  static SystemUiOverlayStyle on(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.light
      ? darkIcons
      : lightIcons;
}

/// The app's status bar style: icons that read on the theme's surface.
/// Wraps the whole app (`MaterialApp.builder`).
///
/// The system keeps the last style it was given, so a screen that sets its
/// own (a photo under the status bar) would leave it behind for the screens
/// that set none. With this under every screen there is always one to
/// return to.
class DSDefaultStatusBar extends StatelessWidget {
  const DSDefaultStatusBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DSColors>()!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: DSStatusBar.on(colors.bgSurface),
      child: child,
    );
  }
}
