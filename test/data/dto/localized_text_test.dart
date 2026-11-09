import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/localized_text.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  group('localized', () {
    test('takes the current language', () {
      expect(localized({'en': 'Davtashen', 'ru': 'Давташен'}, ru), 'Давташен');
    });

    test('falls back to the default language', () {
      expect(localized({'en': 'Davtashen', 'hy': 'Դավթաշեն'}, ru), 'Davtashen');
    });

    test('treats an empty translation as missing', () {
      expect(localized({'en': 'Davtashen', 'ru': '  '}, ru), 'Davtashen');
    });

    test('falls back to the internal name, then to an empty string', () {
      expect(
        localized({'hy': 'Դավթաշեն'}, ru, internalName: 'CH Davtashen'),
        'CH Davtashen',
      );
      expect(localized(null, ru), '');
    });
  });

  test('localizedOrNull is null when there is no text', () {
    expect(localizedOrNull(null, ru), isNull);
    expect(localizedOrNull({'ru': 'Матча'}, ru), 'Матча');
  });

  test('translationsFromJson keeps string entries only', () {
    expect(translationsFromJson({'en': 'A', 'ru': 1}), {'en': 'A'});
    expect(translationsFromJson('not a map'), isNull);
  });
}
