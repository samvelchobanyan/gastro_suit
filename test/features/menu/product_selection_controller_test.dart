import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/cart.dart';
import 'package:gastro_suit/domain/entities/product.dart';
import 'package:gastro_suit/domain/entities/product_choice.dart';
import 'package:gastro_suit/features/menu/product_sheet/product_selection_controller.dart';

void main() {
  ProductSize size(
    String id,
    int price, {
    bool isDefault = false,
    bool available = true,
  }) => ProductSize(
    id: id,
    name: id,
    price: price,
    isAvailable: available,
    isDefault: isDefault,
  );

  ProductOption option(
    String id, {
    int price = 0,
    bool isDefault = false,
    bool available = true,
    int maxQuantity = 1,
  }) => ProductOption(
    id: id,
    name: id,
    price: price,
    isAvailable: available,
    isDefault: isDefault,
    maxQuantity: maxQuantity,
  );

  ProductOptionGroup optionGroup(
    String id,
    List<ProductOption> options, {
    int min = 0,
    int? max,
  }) => ProductOptionGroup(
    id: id,
    name: id,
    minSelected: min,
    maxSelected: max,
    options: options,
  );

  Product product({
    bool available = true,
    List<ProductSize> sizes = const [],
    List<ProductOptionGroup> groups = const [],
  }) => Product(
    id: 'p1',
    categoryId: 'c1',
    name: 'Latte',
    price: 1000,
    isAvailable: available,
    isFeatured: false,
    sizes: sizes,
    optionGroups: groups,
  );

  /// The selection of [p] as it is now, and the controller that changes it.
  (ProductSelection Function(), ProductSelectionController) open(
    Product p, {
    CartLine? editing,
  }) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final provider = productSelectionProvider((product: p, editing: editing));
    // Kept alive as an open sheet keeps it.
    container.listen(provider, (_, _) {});
    return (() => container.read(provider), container.read(provider.notifier));
  }

  group('the selection a product opens with', () {
    test('is one piece at the base price', () {
      final (selection, _) = open(product());
      expect(selection().quantity, 1);
      expect(selection().sizeId, isNull);
      expect(selection().optionQuantities, isEmpty);
      expect(selection().unitPrice, 1000);
      expect(selection().isComplete, isTrue);
    });

    test('has the default size and the pre-selected options', () {
      final (selection, _) = open(
        product(
          sizes: [size('small', 1000), size('large', 1400, isDefault: true)],
          groups: [
            optionGroup('milk', [
              option('whole', isDefault: true),
              option('oat', price: 250),
            ], max: 1),
          ],
        ),
      );
      expect(selection().sizeId, 'large');
      expect(selection().optionQuantities, {'whole': 1});
      expect(selection().unitPrice, 1400);
    });

    test('leaves out a pre-selected option that has run out', () {
      final (selection, _) = open(
        product(
          groups: [
            optionGroup(
              'milk',
              [option('whole', isDefault: true, available: false)],
              min: 1,
              max: 1,
            ),
          ],
        ),
      );
      expect(selection().optionQuantities, isEmpty);
      expect(selection().isComplete, isFalse);
    });

    test('cannot be added when the product is stopped', () {
      final (selection, _) = open(product(available: false));
      expect(selection().isComplete, isFalse);
    });

    test('cannot be added when every size has run out', () {
      final (selection, _) = open(
        product(sizes: [size('small', 1000, available: false)]),
      );
      expect(selection().sizeId, isNull);
      expect(selection().isComplete, isFalse);
    });
  });

  group('the price', () {
    test('is the size plus the chosen options, times the quantity', () {
      final (selection, controller) = open(
        product(
          sizes: [size('small', 1000, isDefault: true), size('large', 1400)],
          groups: [
            optionGroup('extras', [
              option('shot', price: 250),
              option('syrup', price: 150),
            ]),
          ],
        ),
      );
      controller.selectSize('large');
      controller.toggleOption('extras', 'shot');
      controller.toggleOption('extras', 'syrup');
      controller.setQuantity(3);
      expect(selection().unitPrice, 1800);
      expect(selection().total, 5400);
    });
  });

  group('choosing a size', () {
    test('a size that has run out is not taken', () {
      final (selection, controller) = open(
        product(
          sizes: [
            size('small', 1000, isDefault: true),
            size('large', 1400, available: false),
          ],
        ),
      );
      controller.selectSize('large');
      expect(selection().sizeId, 'small');
    });
  });

  group('choosing options', () {
    test('a required group must be filled before adding', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup(
              'milk',
              [option('whole'), option('oat')],
              min: 1,
              max: 1,
            ),
          ],
        ),
      );
      expect(selection().isComplete, isFalse);
      controller.toggleOption('milk', 'oat');
      expect(selection().isComplete, isTrue);
    });

    test('in a single-choice group the new option replaces the old', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup(
              'milk',
              [option('whole'), option('oat')],
              min: 1,
              max: 1,
            ),
          ],
        ),
      );
      controller.toggleOption('milk', 'whole');
      controller.toggleOption('milk', 'oat');
      expect(selection().optionQuantities, {'oat': 1});
    });

    test('the option of a required single-choice group stays chosen', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup(
              'milk',
              [option('whole'), option('oat')],
              min: 1,
              max: 1,
            ),
          ],
        ),
      );
      controller.toggleOption('milk', 'oat');
      controller.toggleOption('milk', 'oat');
      expect(selection().optionQuantities, {'oat': 1});
    });

    test('the option of an optional single-choice group is taken back', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup('extras', [option('shot', price: 250)], max: 1),
          ],
        ),
      );
      controller.toggleOption('extras', 'shot');
      expect(selection().unitPrice, 1250);
      controller.toggleOption('extras', 'shot');
      expect(selection().optionQuantities, isEmpty);
      expect(selection().unitPrice, 1000);
    });

    test('no more options are taken than the group allows', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup('extras', [
              option('a'),
              option('b'),
              option('c'),
            ], max: 2),
          ],
        ),
      );
      controller.toggleOption('extras', 'a');
      controller.toggleOption('extras', 'b');
      controller.toggleOption('extras', 'c');
      expect(selection().optionQuantities, {'a': 1, 'b': 1});
    });

    test('an option that has run out is not taken', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup('extras', [option('shot', available: false)]),
          ],
        ),
      );
      controller.toggleOption('extras', 'shot');
      expect(selection().optionQuantities, isEmpty);
    });

    test('options of one group do not count against another', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup('milk', [option('oat')], min: 1, max: 1),
            optionGroup('temperature', [option('hot'), option('iced')], max: 1),
          ],
        ),
      );
      controller.toggleOption('milk', 'oat');
      controller.toggleOption('temperature', 'iced');
      expect(selection().optionQuantities, {'oat': 1, 'iced': 1});
      expect(selection().isComplete, isTrue);
    });
  });

  group('an option with a quantity', () {
    Product tea() => product(
      groups: [
        optionGroup('sweetener', [
          option('sugar', maxQuantity: 5),
          option('honey', price: 150, maxQuantity: 2),
        ], max: 5),
      ],
    );

    test('is chosen once and goes up to what one product may carry', () {
      final (selection, controller) = open(tea());
      controller.toggleOption('sweetener', 'honey');
      expect(selection().optionQuantities, {'honey': 1});

      controller.setOptionQuantity('sweetener', 'honey', 2);
      expect(selection().optionQuantities, {'honey': 2});
      expect(selection().unitPrice, 1300);

      controller.setOptionQuantity('sweetener', 'honey', 3);
      expect(selection().optionQuantities, {'honey': 2});
    });

    test('does not go under one: taking it back is the toggle', () {
      final (selection, controller) = open(tea());
      controller.toggleOption('sweetener', 'sugar');
      controller.setOptionQuantity('sweetener', 'sugar', 0);
      expect(selection().optionQuantities, {'sugar': 1});

      controller.toggleOption('sweetener', 'sugar');
      expect(selection().optionQuantities, isEmpty);
    });

    test('shares the room of its group with the other options', () {
      final (selection, controller) = open(tea());
      controller.toggleOption('sweetener', 'sugar');
      controller.setOptionQuantity('sweetener', 'sugar', 4);
      expect(controller.maxQuantityOf('sweetener', 'honey'), 1);

      controller.toggleOption('sweetener', 'honey');
      controller.setOptionQuantity('sweetener', 'honey', 2);
      expect(selection().optionQuantities, {'sugar': 4, 'honey': 1});
      expect(controller.maxQuantityOf('sweetener', 'sugar'), 4);

      // The group is full: sugar stays where it is.
      controller.setOptionQuantity('sweetener', 'sugar', 5);
      expect(selection().optionQuantities, {'sugar': 4, 'honey': 1});
    });

    test('is not changed while it is not chosen', () {
      final (selection, controller) = open(tea());
      controller.setOptionQuantity('sweetener', 'sugar', 3);
      expect(selection().optionQuantities, isEmpty);
    });

    test('counts every piece towards what the group asks for', () {
      final (selection, controller) = open(
        product(
          groups: [
            optionGroup('shots', [option('shot', maxQuantity: 3)], min: 2),
          ],
        ),
      );
      controller.toggleOption('shots', 'shot');
      expect(selection().isComplete, isFalse);
      controller.setOptionQuantity('shots', 'shot', 2);
      expect(selection().isComplete, isTrue);
    });

    test('goes to the cart with its quantity', () {
      final (_, controller) = open(tea());
      controller.toggleOption('sweetener', 'sugar');
      controller.setOptionQuantity('sweetener', 'sugar', 3);
      expect(controller.choice.options.single.id, 'sugar');
      expect(controller.choice.options.single.quantity, 3);
    });
  });

  group('the selection opened from a cart line', () {
    CartLine line({
      String? sizeId,
      List<(String, int)> options = const [],
      int quantity = 1,
    }) => CartLine(
      id: 'line-1',
      choice: ProductChoice(
        productId: 'p1',
        productName: 'Latte',
        size: sizeId == null ? null : ChosenSize(id: sizeId, name: sizeId),
        options: [
          for (final (id, count) in options)
            ChosenOption(
              id: id,
              groupId: 'g',
              name: id,
              price: 0,
              quantity: count,
            ),
        ],
      ),
      quantity: quantity,
      unitPrice: 0,
      total: 0,
      isAvailable: true,
    );

    Product latte({bool largeAvailable = true, bool oatAvailable = true}) =>
        product(
          sizes: [
            size('small', 1000, isDefault: true),
            size('large', 1400, available: largeAvailable),
          ],
          groups: [
            optionGroup('milk', [
              option('whole', isDefault: true),
              option('oat', price: 250, available: oatAvailable),
            ], max: 1),
            optionGroup('sweetener', [option('sugar', maxQuantity: 5)]),
          ],
        );

    test('starts from what the line holds, not from the defaults', () {
      final (selection, _) = open(
        latte(),
        editing: line(
          sizeId: 'large',
          options: [('oat', 1), ('sugar', 3)],
          quantity: 2,
        ),
      );
      expect(selection().sizeId, 'large');
      expect(selection().optionQuantities, {'oat': 1, 'sugar': 3});
      expect(selection().quantity, 2);
      expect(selection().unitPrice, 1650);
      expect(selection().total, 3300);
    });

    test('a line with nothing chosen leaves the defaults off', () {
      final (selection, _) = open(latte(), editing: line(sizeId: 'small'));
      expect(selection().optionQuantities, isEmpty);
    });

    test('a size the branch no longer has gives way to the default', () {
      final (selection, _) = open(
        latte(largeAvailable: false),
        editing: line(sizeId: 'large'),
      );
      expect(selection().sizeId, 'small');
    });

    test('an option the branch no longer has is left out', () {
      final (selection, _) = open(
        latte(oatAvailable: false),
        editing: line(sizeId: 'small', options: [('oat', 1), ('gone', 1)]),
      );
      expect(selection().optionQuantities, isEmpty);
    });

    test('changes like any other selection', () {
      final (selection, controller) = open(
        latte(),
        editing: line(sizeId: 'large', options: [('sugar', 3)]),
      );
      controller.selectSize('small');
      controller.setOptionQuantity('sweetener', 'sugar', 1);
      expect(selection().sizeId, 'small');
      expect(selection().optionQuantities, {'sugar': 1});
    });
  });

  group('whether a cart line was changed', () {
    CartLine held() => CartLine(
      id: 'line-1',
      choice: const ProductChoice(
        productId: 'p1',
        productName: 'Latte',
        size: ChosenSize(id: 'large', name: 'large'),
        options: [
          ChosenOption(
            id: 'sugar',
            groupId: 'sweetener',
            name: 'sugar',
            price: 0,
            quantity: 2,
          ),
        ],
      ),
      quantity: 2,
      unitPrice: 0,
      total: 0,
      isAvailable: true,
    );

    Product latte({bool largeAvailable = true}) => product(
      sizes: [
        size('small', 1000, isDefault: true),
        size('large', 1400, available: largeAvailable),
      ],
      groups: [
        optionGroup('milk', [option('oat', price: 250)], max: 1),
        optionGroup('sweetener', [option('sugar', maxQuantity: 5)]),
      ],
    );

    test('a new selection is never unchanged', () {
      final (_, controller) = open(latte());
      expect(controller.isUnchanged, isFalse);
    });

    test('opened on a line, nothing is changed yet', () {
      final (_, controller) = open(latte(), editing: held());
      expect(controller.isUnchanged, isTrue);
    });

    test('a size, an option, its quantity or the quantity changes it', () {
      final (_, controller) = open(latte(), editing: held());

      controller.selectSize('small');
      expect(controller.isUnchanged, isFalse);
      controller.selectSize('large');
      expect(controller.isUnchanged, isTrue);

      controller.toggleOption('milk', 'oat');
      expect(controller.isUnchanged, isFalse);
      controller.toggleOption('milk', 'oat');
      expect(controller.isUnchanged, isTrue);

      controller.setOptionQuantity('sweetener', 'sugar', 3);
      expect(controller.isUnchanged, isFalse);
      controller.setOptionQuantity('sweetener', 'sugar', 2);
      expect(controller.isUnchanged, isTrue);

      controller.setQuantity(1);
      expect(controller.isUnchanged, isFalse);
    });

    test('a line the branch can no longer make as it is counts as changed', () {
      final (_, controller) = open(
        latte(largeAvailable: false),
        editing: held(),
      );
      expect(controller.isUnchanged, isFalse);
    });
  });

  group('the quantity', () {
    test('stays between one and the most a line holds', () {
      final (selection, controller) = open(product());
      controller.setQuantity(0);
      expect(selection().quantity, 1);
      controller.setQuantity(500);
      expect(selection().quantity, ProductSelectionController.maxQuantity);
    });
  });
}
