import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/product.dart';

void main() {
  ProductSize size(
    String id, {
    bool isDefault = false,
    bool available = true,
  }) => ProductSize(
    id: id,
    name: id,
    price: 1000,
    isAvailable: available,
    isDefault: isDefault,
  );

  Product product(List<ProductSize> sizes) => Product(
    id: 'p1',
    categoryId: 'c1',
    name: 'Latte',
    price: 1000,
    isAvailable: true,
    isFeatured: false,
    sizes: sizes,
    optionGroups: const [],
  );

  group('defaultSize', () {
    test('is the size marked as default', () {
      final p = product([size('small'), size('regular', isDefault: true)]);
      expect(p.defaultSize?.id, 'regular');
    });

    test('is the first available size when the default has run out', () {
      final p = product([
        size('small', available: false),
        size('regular', isDefault: true, available: false),
        size('large'),
        size('xl'),
      ]);
      expect(p.defaultSize?.id, 'large');
    });

    test('is null when every size has run out', () {
      final p = product([
        size('small', isDefault: true, available: false),
        size('large', available: false),
      ]);
      expect(p.defaultSize, isNull);
    });

    test('is null for a product with one size', () {
      expect(product(const []).defaultSize, isNull);
    });
  });

  group('defaultOptions', () {
    ProductOption option(
      String id, {
      bool isDefault = true,
      bool available = true,
    }) => ProductOption(
      id: id,
      name: id,
      price: 0,
      isAvailable: available,
      isDefault: isDefault,
    );

    ProductOptionGroup optionGroup(List<ProductOption> options, {int? max}) =>
        ProductOptionGroup(
          id: 'g1',
          name: 'Milk',
          minSelected: 0,
          maxSelected: max,
          options: options,
        );

    test('are the pre-selected options the branch still has', () {
      final g = optionGroup([
        option('whole'),
        option('oat', isDefault: false),
        option('almond', available: false),
      ]);
      expect([for (final o in g.defaultOptions) o.id], ['whole']);
    });

    test('are no more than may be chosen', () {
      final g = optionGroup([option('whole'), option('oat')], max: 1);
      expect([for (final o in g.defaultOptions) o.id], ['whole']);
    });
  });
}
