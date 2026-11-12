import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/menu_category_dto.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  test('maps a top-level category in the current language', () {
    final category = MenuCategoryDto.fromJson({
      'id': 'c1',
      'slug': 'iced-coffee',
      'internalName': 'Iced Coffee',
      'name': {'en': 'Iced Coffee', 'ru': 'Холодный кофе'},
      'description': null,
      'imageUrl': 'http://x/c.png',
      'sortOrder': 2,
      'parentCategoryId': null,
    }).toDomain(ru);
    expect(category.id, 'c1');
    expect(category.name, 'Холодный кофе');
    expect(category.imageUrl, 'http://x/c.png');
    expect(category.parentId, isNull);
  });

  test('a subcategory without a name or an image', () {
    final category = MenuCategoryDto.fromJson({
      'id': 'c2',
      'internalName': 'Iced Tea',
      'name': null,
      'imageUrl': '',
      'parentCategoryId': 'c1',
    }).toDomain(ru);
    expect(category.name, 'Iced Tea');
    expect(category.imageUrl, isNull);
    expect(category.parentId, 'c1');
  });
}
