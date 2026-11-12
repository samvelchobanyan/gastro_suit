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
}
