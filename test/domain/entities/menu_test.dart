import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/domain/entities/menu.dart';
import 'package:gastro_suit/domain/entities/menu_category.dart';
import 'package:gastro_suit/domain/entities/product.dart';

void main() {
  Product product(String id, String categoryId, {bool featured = false}) =>
      Product(
        id: id,
        categoryId: categoryId,
        name: id,
        price: 1000,
        isAvailable: true,
        isFeatured: featured,
        sizes: const [],
        optionGroups: const [],
      );

  final menu = Menu(
    branchId: 'b1',
    categories: const [
      MenuCategory(id: 'combo', name: 'Combo'),
      MenuCategory(id: 'iced-tea', name: 'Iced Tea', parentId: 'combo'),
      MenuCategory(id: 'sweets', name: 'Sweets'),
      MenuCategory(id: 'hot-tea', name: 'Hot Tea', parentId: 'combo'),
    ],
    products: [
      product('tea-set', 'iced-tea', featured: true),
      product('muffin', 'sweets'),
      product('duo', 'combo'),
      product('cake', 'sweets', featured: true),
    ],
  );

  List<String> ids(Iterable<Object> items) => [
    for (final item in items)
      switch (item) {
        MenuCategory(:final id) || Product(:final id) => id,
        _ => '?',
      },
  ];

  test('root categories are the ones without a parent, in order', () {
    expect(ids(menu.rootCategories), ['combo', 'sweets']);
  });

  test('subcategories of a category, in order', () {
    expect(ids(menu.subcategoriesOf('combo')), ['iced-tea', 'hot-tea']);
    expect(menu.subcategoriesOf('sweets'), isEmpty);
  });

  test('products of a category do not include its subcategories', () {
    expect(ids(menu.productsIn('sweets')), ['muffin', 'cake']);
    expect(ids(menu.productsIn('combo')), ['duo']);
  });

  test('featured products, in order', () {
    expect(ids(menu.featured), ['tea-set', 'cake']);
  });

  test('a product by id', () {
    expect(menu.product('muffin')?.name, 'muffin');
    expect(menu.product('gone'), isNull);
  });
}
