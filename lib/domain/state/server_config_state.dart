import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/repositories.dart';
import '../../core/locale/app_language.dart';
import '../../core/locale/content_language.dart';
import '../entities/server_config.dart';

/// The API instance's configuration, loaded once on first use and kept for
/// the app's lifetime. Content mapping waits for it through
/// [contentLanguageProvider].
class ServerConfigController extends AsyncNotifier<ServerConfig> {
  @override
  Future<ServerConfig> build() =>
      ref.read(serverConfigRepositoryProvider).getConfig();
}

final serverConfigProvider =
    AsyncNotifierProvider<ServerConfigController, ServerConfig>(
      ServerConfigController.new,
    );

/// The languages content is mapped with: the app's, then the instance's
/// default. Controllers await it and pass it to repositories.
final contentLanguageProvider = FutureProvider<ContentLanguage>((ref) async {
  final config = await ref.watch(serverConfigProvider.future);
  return ContentLanguage(
    current: ref.watch(appLanguageProvider),
    fallback: config.defaultLanguage,
  );
});
