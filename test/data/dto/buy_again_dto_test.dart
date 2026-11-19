import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/buy_again_dto.dart';

void main() {
  const language = ContentLanguage(current: 'ru', fallback: 'en');

  // As the dev server answers (2026-11-18), shortened.
  final json = <String, dynamic>{
    'againId': '5d0c7a52',
    'item': {
      'id': 'a27b11c7',
      'slug': 'hot-latte',
      'internalName': 'Hot Latte',
      'name': {'en': 'Hot Latte', 'ru': 'Горячий латте'},
      'imageUrl': 'http://server/uploads/latte.webp',
      'price': 1200,
      'isAvailable': true,
    },
    'branch': {
      'id': '208cb4ea',
      'slug': 'ler-kamsar',
      'internalName': 'Coffee House — Ler Kamsar',
      'name': {'en': 'Ler Kamsar', 'ru': 'Лер Камсара'},
    },
    'options': [
      {
        'id': 'size-regular',
        'groupId': 'size:item-020',
        'name': {'en': 'Regular', 'ru': 'Стандартный'},
        'price': 200,
        'quantity': 1,
      },
    ],
    'unitPrice': 1650,
    'available': true,
    'lastOrderedAt': '2026-11-16T16:20:50.163Z',
  };

  test('an entry is read with its product and its branch', () {
    final item = BuyAgainDto.fromJson(json).toDomain(language);

    expect(item.id, '5d0c7a52');
    expect(item.name, 'Горячий латте');
    expect(item.imageUrl, 'http://server/uploads/latte.webp');
    expect(item.branchId, '208cb4ea');
    expect(item.branchName, 'Лер Камсара');
    expect(item.isAvailable, isTrue);
  });

  test('no picture, no translation and one that cannot be made', () {
    final item = BuyAgainDto.fromJson({
      ...json,
      'item': {'id': 'a27b11c7', 'internalName': 'Hot Latte', 'imageUrl': ''},
      'branch': {'id': '208cb4ea', 'internalName': 'Ler Kamsar'},
      'available': false,
    }).toDomain(language);

    expect(item.name, 'Hot Latte');
    expect(item.imageUrl, isNull);
    expect(item.branchName, 'Ler Kamsar');
    expect(item.isAvailable, isFalse);
  });
}
