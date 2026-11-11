import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/city_dto.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  test('maps a city with its districts in the current language', () {
    final city = CityDto.fromJson({
      'id': 'c1',
      'name': {'en': 'Yerevan', 'ru': 'Ереван'},
      'districts': [
        {
          'id': 'd1',
          'name': {'en': 'Kentron'},
        },
      ],
    }).toDomain(ru);
    expect(city.name, 'Ереван');
    expect(city.districts.single.id, 'd1');
    expect(city.districts.single.name, 'Kentron');
  });

  test('a city without districts', () {
    final city = CityDto.fromJson({
      'id': 'c2',
      'name': {'en': 'Gyumri'},
      'districts': <Object>[],
    }).toDomain(ru);
    expect(city.districts, isEmpty);
  });
}
