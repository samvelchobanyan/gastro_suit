import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/app_language.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('until the user chooses, the language is the device\'s', () async {
    final storage = AppLanguageStorage();
    await storage.init();

    // The test device speaks English.
    expect(storage.code, 'en');
  });

  test('a chosen language is read back after a restart', () async {
    await AppLanguageStorage().choose('hy');

    final restarted = AppLanguageStorage();
    await restarted.init();

    expect(restarted.code, 'hy');
  });

  test(
    'a saved language the app is not translated into counts as none',
    () async {
      await AppLanguageStorage().choose('fr');

      final restarted = AppLanguageStorage();
      await restarted.init();

      expect(restarted.code, 'en');
    },
  );

  test('the provider follows the choice', () async {
    final storage = AppLanguageStorage();
    final container = ProviderContainer(
      overrides: [appLanguageStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    expect(container.read(appLanguageProvider), 'en');

    await storage.choose('ru');

    expect(container.read(appLanguageProvider), 'ru');
  });
}
