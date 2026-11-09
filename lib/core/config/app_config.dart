/// Build-time configuration.
///
/// Values come from a JSON file passed at build time:
/// `flutter run --dart-define-from-file=config/dev.json`. Each environment (and
/// later each client) is its own file; this class holds no addresses.
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  /// Reads the values the build was started with. Fails at startup, not on the
  /// first request, when a value is missing.
  factory AppConfig.fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is not set. Run with '
        '--dart-define-from-file=config/dev.json (VS Code: "GastroSuit (dev)").',
      );
    }
    return const AppConfig(apiBaseUrl: apiBaseUrl);
  }

  /// Base address of the API, e.g. `http://host:3000/api/v1`.
  final String apiBaseUrl;
}
