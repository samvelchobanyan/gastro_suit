import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/data/dto/server_config_dto.dart';

void main() {
  test('reads the default language', () {
    final config = ServerConfigDto.fromJson({
      'siteName': 'GuestPilot',
      'languages': {
        'default': 'hy',
        'supported': ['en', 'ru', 'hy'],
      },
    }).toDomain();

    expect(config.defaultLanguage, 'hy');
  });

  test('falls back to English when the instance names none', () {
    expect(ServerConfigDto.fromJson({}).toDomain().defaultLanguage, 'en');
  });
}
