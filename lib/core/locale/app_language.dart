import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';

/// The app's language: the device's if the app supports it, otherwise the
/// first supported one (English), as the UI does.
///
/// Read per call, so a change of the device language applies to the next
/// request. Becomes the user's choice, stored locally, when the language
/// switch in the profile is built.
String appLanguageCode() {
  final device = PlatformDispatcher.instance.locale.languageCode;
  const supported = AppLocalizations.supportedLocales;
  return supported.any((l) => l.languageCode == device)
      ? device
      : supported.first.languageCode;
}

/// The app's language for code that reads providers (content mapping).
final appLanguageProvider = Provider<String>((_) => appLanguageCode());
