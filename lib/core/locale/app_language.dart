import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/generated/app_localizations.dart';

/// Owns the app's language: the only place that reads or writes the user's
/// choice.
///
/// The choice lives on the phone only, mirrored in memory so the UI and
/// every request read it synchronously. Loaded once by [init] before
/// `runApp`. Until the user chooses, the language is the device's if the app
/// supports it, otherwise the first supported one (English).
///
/// Notifies listeners when the choice changes; [appLanguageProvider] follows.
class AppLanguageStorage extends ChangeNotifier {
  static const _key = 'app_language';

  /// Opened on first use: a storage that is never loaded or written to
  /// does not touch the phone.
  late final _prefs = SharedPreferencesAsync();
  String? _chosen;

  /// The language codes the app is translated into.
  static List<String> get supported => [
    for (final locale in AppLocalizations.supportedLocales) locale.languageCode,
  ];

  /// The app's language now.
  String get code {
    final supported = AppLanguageStorage.supported;
    final chosen = _chosen;
    if (chosen != null && supported.contains(chosen)) return chosen;
    // Read per call, so a change of the device language applies at once.
    final device = PlatformDispatcher.instance.locale.languageCode;
    return supported.contains(device) ? device : supported.first;
  }

  /// Loads the saved choice. A failed read means none.
  Future<void> init() async {
    try {
      _chosen = await _prefs.getString(_key);
    } catch (_) {
      _chosen = null;
    }
  }

  /// Makes [code] the app's language, for this run and the next ones.
  Future<void> choose(String code) async {
    if (code == _chosen) return;
    _chosen = code;
    notifyListeners();
    await _prefs.setString(_key, code);
  }
}

/// Built and initialized in `main`, injected through
/// `ProviderScope.overrides`. Left as it is, it stands for a phone with no
/// saved choice: the language is the device's.
final appLanguageStorageProvider = Provider<AppLanguageStorage>((ref) {
  final storage = AppLanguageStorage();
  ref.onDispose(storage.dispose);
  return storage;
});

/// The app's language as its code, derived from [AppLanguageStorage]: the UI
/// is shown in it and content is mapped with it.
final appLanguageProvider = Provider<String>((ref) {
  final storage = ref.watch(appLanguageStorageProvider);
  void onChanged() => ref.invalidateSelf();
  storage.addListener(onChanged);
  ref.onDispose(() => storage.removeListener(onChanged));
  return storage.code;
});
