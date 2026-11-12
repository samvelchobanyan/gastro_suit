import 'package:freezed_annotation/freezed_annotation.dart';

import 'menu_category.dart';
import 'product.dart';

part 'menu.freezed.dart';

/// What one branch offers: its categories and products (DOMAIN_SPEC §2).
/// Identified by its branch; prices and availability are that branch's.
@freezed
abstract class Menu with _$Menu {
  const factory Menu({
    required String branchId,

    /// Both levels, in the admins' order.
    required List<MenuCategory> categories,

    /// Every product of the branch, in the admins' order.
    required List<Product> products,
  }) = _Menu;

  const Menu._();

  /// The top-level categories.
  List<MenuCategory> get rootCategories => [
    for (final c in categories)
      if (c.parentId == null) c,
  ];

  /// The subcategories of [categoryId]; empty when it has none.
  List<MenuCategory> subcategoriesOf(String categoryId) => [
    for (final c in categories)
      if (c.parentId == categoryId) c,
  ];

  /// The products that sit in [categoryId] itself, not in its subcategories.
  List<Product> productsIn(String categoryId) => [
    for (final p in products)
      if (p.categoryId == categoryId) p,
  ];

  /// The products the merchant marked as featured.
  List<Product> get featured => [
    for (final p in products)
      if (p.isFeatured) p,
  ];

  /// Null when the branch does not offer [productId].
  Product? product(String productId) =>
      products.where((p) => p.id == productId).firstOrNull;
}
