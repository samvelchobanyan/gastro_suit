import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/product.dart';
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
  }) => ProductOption(
    id: id,
    name: id,
    price: price,
    isAvailable: available,
    isDefault: isDefault,
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
  (ProductSelection Function(), ProductSelectionController) open(Product p) {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final provider = productSelectionProvider(p);
    // Kept alive as an open sheet keeps it.
    container.listen(provider, (_, _) {});
    return (() => container.read(provider), container.read(provider.notifier));
  }

  group('the selection a product opens with', () {
    test('is one piece at the base price', () {
      final (selection, _) = open(product());
      expect(selection().quantity, 1);
      expect(selection().sizeId, isNull);
      expect(selection().optionIds, isEmpty);
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
      expect(selection().optionIds, {'whole'});
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
      expect(selection().optionIds, isEmpty);
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
      expect(selection().optionIds, {'oat'});
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
      expect(selection().optionIds, {'oat'});
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
      expect(selection().optionIds, isEmpty);
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
      expect(selection().optionIds, {'a', 'b'});
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
      expect(selection().optionIds, isEmpty);
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
      expect(selection().optionIds, {'oat', 'iced'});
      expect(selection().isComplete, isTrue);
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
