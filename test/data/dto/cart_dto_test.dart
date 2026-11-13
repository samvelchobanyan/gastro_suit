import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/cart_dto.dart';

void main() {
  const language = ContentLanguage(current: 'ru', fallback: 'en');

  // As the dev server answers, shortened.
  final json = <String, dynamic>{
    'id': '2aa25f0f',
    'locationId': 'b1',
    'total': 5450,
    'items': [
      {
        'id': 'line-1',
        'itemId': 'raf',
        'quantity': 2,
        'unitPrice': 1650,
        'modifierPrice': 0,
        'total': 3300,
        'modifiersJson': [
          {
            'id': 'mod-oat-milk',
            'name': 'Oat milk',
            'price': 0,
            'groupId': 'mod-group-milk',
          },
        ],
        'item': {
          'id': 'raf',
          'internalName': 'Hot Raf Strawberry',
          'name': {'en': 'Hot Raf Strawberry', 'ru': 'Раф клубничный'},
          'imageUrl': 'http://img.test/raf.png',
        },
        'available': true,
        'unavailableReason': null,
      },
      {
        'id': 'line-2',
        'itemId': 'matcha',
        'quantity': 1,
        'unitPrice': 2150,
        'modifierPrice': 400,
        'total': 2150,
        'modifiersJson': [
          {
            'id': 'size-large',
            'name': 'Большой',
            'price': 400,
            'groupId': 'size:item-004',
          },
        ],
        'item': {
          'id': 'matcha',
          'internalName': 'Matcha Latte',
          'name': {'en': 'Matcha Latte'},
          'imageUrl': '',
        },
        'available': false,
        'unavailableReason': 'item_unavailable',
      },
      {
        'id': 'line-3',
        'itemId': 'smoothie',
        'quantity': 1,
        'unitPrice': 1500,
        'total': 1500,
        'modifiersJson': null,
        'item': {'id': 'smoothie', 'internalName': 'Smoothie'},
        'available': true,
      },
    ],
  };

  test('reads the cart, its branch and its total', () {
    final cart = CartDto.fromJson(json).toDomain(language);

    expect(cart.id, '2aa25f0f');
    expect(cart.branchId, 'b1');
    expect(cart.total, 5450);
    expect(cart.lines, hasLength(3));
    expect(cart.itemCount, 4);
    expect(cart.hasUnavailable, isTrue);
  });

  test('a chosen add-on is an option of the line', () {
    final line = CartDto.fromJson(json).toDomain(language).lines[0];

    expect(line.id, 'line-1');
    expect(line.choice.productId, 'raf');
    expect(line.choice.productName, 'Раф клубничный');
    expect(line.choice.size, isNull);
    expect(line.choice.options.single.id, 'mod-oat-milk');
    expect(line.choice.options.single.groupId, 'mod-group-milk');
    expect(line.imageUrl, 'http://img.test/raf.png');
    expect(line.quantity, 2);
    expect(line.unitPrice, 1650);
    expect(line.total, 3300);
    expect(line.isAvailable, isTrue);
  });

  test('the modifier of the size group is the size, not an option', () {
    final line = CartDto.fromJson(json).toDomain(language).lines[1];

    expect(line.choice.size?.id, 'size-large');
    expect(line.choice.size?.name, 'Большой');
    expect(line.choice.options, isEmpty);
    // No translation in the current language: the default one.
    expect(line.choice.productName, 'Matcha Latte');
    expect(line.imageUrl, isNull);
    expect(line.isAvailable, isFalse);
    expect(line.unavailableReason, 'item_unavailable');
  });

  test('a line with nothing chosen has no size and no options', () {
    final line = CartDto.fromJson(json).toDomain(language).lines[2];

    expect(line.choice.size, isNull);
    expect(line.choice.options, isEmpty);
    expect(line.choice.productName, 'Smoothie');
  });

  test('a cart the server does not hold yet is empty', () {
    final cart = CartDto.fromJson(const {
      'id': null,
      'locationId': 'b1',
      'total': 0,
      'items': <Object>[],
    }).toDomain(language);

    expect(cart.id, isNull);
    expect(cart.isEmpty, isTrue);
    expect(cart.itemCount, 0);
  });
}
