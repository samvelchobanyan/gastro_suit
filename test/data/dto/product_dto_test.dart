import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/product_dto.dart';
import 'package:gastro_suit/domain/entities/product.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  // As `GET /menu/items` answers it.
  Map<String, dynamic> json({
    List<Object>? modifiers,
    List<String> unavailable = const [],
    Map<String, Object>? optionNames,
    Object? portion,
  }) => {
    'id': 'p1',
    'internalName': 'Latte',
    'name': {'en': 'Latte', 'ru': 'Латте'},
    'description': {'en': 'Espresso with milk'},
    'imageUrl': 'http://x/latte.png',
    'isFeatured': true,
    'portion': portion,
    'modifiersJson': modifiers ?? <Object>[],
    'categoryId': 'c1',
    'price': 1500,
    'isAvailable': true,
    'unavailableModifiers': unavailable,
    'optionNames': optionNames ?? <String, Object>{},
  };

  Map<String, Object> sizes({bool markRegular = true}) => {
    'id': 'size:p1',
    'kind': 'size',
    'name': 'Size',
    'items': [
      {'id': 'small', 'name': 'Small', 'price': 0},
      {
        'id': 'regular',
        'name': 'Regular',
        'price': 200,
        if (markRegular) 'restrictions': {'defaultQuantity': 1},
      },
      {'id': 'large', 'name': 'Large', 'price': 400},
    ],
    'restrictions': {'minQuantity': 1, 'maxQuantity': 1},
  };

  const milk = {
    'id': 'milk',
    'name': 'Milk',
    'items': [
      {
        'id': 'cow',
        'name': 'Cow',
        'price': 0,
        'restrictions': {'defaultQuantity': 1},
      },
      {'id': 'oat', 'name': 'Oat', 'price': 300},
    ],
    'restrictions': {'minQuantity': 1, 'maxQuantity': 1},
  };

  const syrups = {
    'id': 'syrups',
    'name': 'Syrups',
    'items': [
      {'id': 'vanilla', 'name': 'Vanilla', 'price': 0},
    ],
  };

  Product product(Map<String, dynamic> json) =>
      ProductDto.fromJson(json).toDomain(ru);

  test('maps a product without modifiers', () {
    final p = product(json());
    expect(p.id, 'p1');
    expect(p.categoryId, 'c1');
    expect(p.name, 'Латте');
    // No Russian text: the instance's default language.
    expect(p.description, 'Espresso with milk');
    expect(p.imageUrl, 'http://x/latte.png');
    expect(p.price, 1500);
    expect(p.isAvailable, isTrue);
    expect(p.isFeatured, isTrue);
    expect(p.portion, isNull);
    expect(p.sizes, isEmpty);
    expect(p.optionGroups, isEmpty);
    expect(p.defaultSize, isNull);
  });

  group('sizes', () {
    test('are the size group, priced over the base price', () {
      final p = product(json(modifiers: [sizes(), milk]));
      expect([for (final s in p.sizes) s.id], ['small', 'regular', 'large']);
      expect([for (final s in p.sizes) s.price], [1500, 1700, 1900]);
      // The size group is not an add-on group as well.
      expect([for (final g in p.optionGroups) g.id], ['milk']);
    });

    test('the marked size is the default', () {
      final p = product(json(modifiers: [sizes()]));
      expect([for (final s in p.sizes) s.isDefault], [false, true, false]);
      expect(p.defaultSize?.id, 'regular');
    });

    test('a size the branch ran out of is unavailable', () {
      final p = product(json(modifiers: [sizes()], unavailable: ['large']));
      expect([for (final s in p.sizes) s.isAvailable], [true, true, false]);
    });

    test('without a mark the first size is the default', () {
      final p = product(json(modifiers: [sizes(markRegular: false)]));
      expect([for (final s in p.sizes) s.isDefault], [true, false, false]);
    });
  });

  group('add-on groups', () {
    test('a required single-choice paid group', () {
      final group = product(json(modifiers: [milk])).optionGroups.single;
      expect(group.minSelected, 1);
      expect(group.maxSelected, 1);
      expect(group.isRequired, isTrue);
      expect(group.isSingleChoice, isTrue);
      expect(group.isPaid, isTrue);
      expect([for (final o in group.options) o.isDefault], [true, false]);
      expect([for (final o in group.options) o.price], [0, 300]);
    });

    test('a group without restrictions is optional, unlimited and free', () {
      final group = product(json(modifiers: [syrups])).optionGroups.single;
      expect(group.minSelected, 0);
      expect(group.maxSelected, isNull);
      expect(group.isRequired, isFalse);
      expect(group.isSingleChoice, isFalse);
      expect(group.isPaid, isFalse);
    });

    test('an option the branch ran out of is unavailable', () {
      final group = product(
        json(modifiers: [milk], unavailable: ['oat']),
      ).optionGroups.single;
      expect([for (final o in group.options) o.isAvailable], [true, false]);
    });
  });

  test('group and option names are translated through optionNames', () {
    final group = product(
      json(
        modifiers: [milk],
        optionNames: {
          'milk': {'en': 'Milk', 'ru': 'Молоко'},
          'oat': {'en': 'Oat milk'},
        },
      ),
    ).optionGroups.single;
    expect(group.name, 'Молоко');
    // No translation at all: the POS's own name.
    expect(group.options[0].name, 'Cow');
    // No Russian translation: the instance's default language.
    expect(group.options[1].name, 'Oat milk');
  });

  group('portion', () {
    test('is mapped with its unit', () {
      final p = product(json(portion: {'amount': 300, 'unit': 'MILLILITER'}));
      expect(
        p.portion,
        const Portion(amount: 300, unit: PortionUnit.milliliter),
      );
    });

    test('with an unknown unit is dropped', () {
      final p = product(json(portion: {'amount': 1, 'unit': 'PIECE'}));
      expect(p.portion, isNull);
    });
  });
}
