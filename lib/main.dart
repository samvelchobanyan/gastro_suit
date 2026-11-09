import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/auth/token_storage.dart';
import 'core/config/app_config.dart';
import 'core/locale/app_language.dart';
import 'core/navigation/app_router.dart';
import 'core/network/api_client.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/locale_interceptor.dart';
import 'design_system/theme/app_theme.dart';
import 'design_system/theme/ds_colors.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();

  final tokenStorage = TokenStorage();
  await tokenStorage.init();
  await _dropSessionIfApiChanged(config, tokenStorage);

  final apiClient = ApiClient(
    baseUrl: config.apiBaseUrl,
    interceptors: [
      LocaleInterceptor(appLanguageCode),
      AuthInterceptor(
        tokenStorage: tokenStorage,
        sessionClient: Dio(
          BaseOptions(
            baseUrl: config.apiBaseUrl,
            connectTimeout: ApiClient.connectTimeout,
            receiveTimeout: ApiClient.receiveTimeout,
          ),
        ),
      ),
    ],
  );

  runApp(
    ProviderScope(
      // No automatic retries: a failed load shows its error state and is
      // retried by the user (pull to refresh, a retry button).
      retry: (_, _) => null,
      overrides: [
        appConfigProvider.overrideWithValue(config),
        tokenStorageProvider.overrideWithValue(tokenStorage),
        apiClientProvider.overrideWithValue(apiClient),
      ],
      child: const App(),
    ),
  );
}

/// Saved tokens outlive app updates, and on iOS the Keychain even survives a
/// reinstall. Drop the session once when the build talks to a different API
/// than the one it came from, or when the app was reinstalled. The marker
/// lives in SharedPreferences, which uninstall wipes.
Future<void> _dropSessionIfApiChanged(
  AppConfig config,
  TokenStorage tokenStorage,
) async {
  const sessionApiKey = 'session_api_base_url';
  final prefs = SharedPreferencesAsync();
  if (await prefs.getString(sessionApiKey) == config.apiBaseUrl) return;

  await tokenStorage.clear();
  await prefs.setString(sessionApiKey, config.apiBaseUrl);
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: buildAppTheme(lightColors),
      routerConfig: ref.watch(routerProvider),
      // The device language if supported, otherwise English (the first entry).
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
