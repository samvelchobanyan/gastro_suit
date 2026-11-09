import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Build-time configuration.
///
/// Values come from a JSON file passed at build time:
/// `flutter run --dart-define-from-file=config/dev.json`. Each environment (and
/// later each client) is its own file; this class holds no addresses.
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.restaurantId});

  /// Reads the values the build was started with. Fails at startup, not on the
  /// first request, when a value is missing.
  factory AppConfig.fromEnvironment() {
    return AppConfig(
      apiBaseUrl: _require(
        'API_BASE_URL',
        const String.fromEnvironment('API_BASE_URL'),
      ),
      restaurantId: _require(
        'RESTAURANT_ID',
        const String.fromEnvironment('RESTAURANT_ID'),
      ),
    );
  }

  static String _require(String name, String value) {
    if (value.isEmpty) {
      throw StateError(
        '$name is not set. Run with '
        '--dart-define-from-file=config/dev.json (VS Code: "GastroSuit (dev)").',
      );
    }
    return value;
  }

  /// Base address of the API, e.g. `http://host:3000/api/v1`.
  final String apiBaseUrl;

  /// The organisation this build serves. One per build: its branches, menu,
  /// loyalty and wallet.
  final String restaurantId;
}

/// Built in `main` and injected through `ProviderScope.overrides`.
final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError(
    'appConfigProvider must be overridden in ProviderScope',
  ),
);
