import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// An item that can be ordered, as one branch offers it (DOMAIN_SPEC §1).
/// The same product has its own price and availability in each branch.
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    required String name,
    String? description,
    String? imageUrl,

    /// The base price; with [sizes], the price of the smallest size.
    required int price,

    /// False: the branch has stopped it. Shown greyed; the cart refuses it.
    required bool isAvailable,

    /// How much one portion is. With [sizes] each size has its own.
    Portion? portion,
    required bool isFeatured,

    /// From the cheapest; empty when the product has one size.
    required List<ProductSize> sizes,

    /// Empty when the product has no add-ons.
    required List<ProductOptionGroup> optionGroups,
  }) = _Product;

  const Product._();

  /// Whether ordering it takes a choice: it has sizes or add-ons, required
  /// or not. The cart may then hold several lines of it.
  bool get hasChoices => sizes.isNotEmpty || optionGroups.isNotEmpty;

  /// The size chosen until the user picks another: the default one, or the
  /// first the branch still has when the default has run out. Null without
  /// [sizes] or when every size has run out.
  ProductSize? get defaultSize {
    final available = sizes.where((s) => s.isAvailable);
    return available.where((s) => s.isDefault).firstOrNull ??
        available.firstOrNull;
  }
}

/// One size of a product. Its price is final, not a surcharge.
@freezed
abstract class ProductSize with _$ProductSize {
  const factory ProductSize({
    required String id,
    required String name,
    required int price,

    /// False: the branch has run out of it.
    required bool isAvailable,

    /// Exactly one size of a product is the default.
    required bool isDefault,

    /// How much this size is; null when the kitchen entered none.
    Portion? portion,
  }) = _ProductSize;
}

/// One question asked when ordering ("Which milk?", "Any syrup?").
@freezed
abstract class ProductOptionGroup with _$ProductOptionGroup {
  const factory ProductOptionGroup({
    required String id,
    required String name,

    /// How many options must be chosen; 0 for an optional group. An option
    /// chosen several times counts as many.
    required int minSelected,

    /// How many options may be chosen, counted the same way; null for no
    /// limit.
    int? maxSelected,
    required List<ProductOption> options,
  }) = _ProductOptionGroup;

  const ProductOptionGroup._();

  bool get isRequired => minSelected >= 1;

  bool get isSingleChoice => maxSelected == 1;

  /// Whether any of its options costs extra.
  bool get isPaid => options.any((o) => o.price > 0);

  /// The options chosen until the user changes them: the pre-selected ones
  /// the branch still has, no more than may be chosen.
  List<ProductOption> get defaultOptions {
    final defaults = options.where((o) => o.isDefault && o.isAvailable);
    final max = maxSelected;
    return (max == null ? defaults : defaults.take(max)).toList();
  }
}

/// One answer to a group's question.
@freezed
abstract class ProductOption with _$ProductOption {
  const factory ProductOption({
    required String id,
    required String name,

    /// What choosing it adds to the product's price; 0 when free.
    required int price,

    /// False: the branch has run out of it.
    required bool isAvailable,

    /// Chosen until the user changes it.
    required bool isDefault,

    /// How many of it one product may carry: 1 for an option that is
    /// chosen or not, more for one with a quantity (three spoons of sugar).
    @Default(1) int maxQuantity,
  }) = _ProductOption;
}

/// How much one portion is, e.g. 300 ml.
@freezed
abstract class Portion with _$Portion {
  const factory Portion({required num amount, required PortionUnit unit}) =
      _Portion;
}

enum PortionUnit { gram, kilogram, milliliter, liter }
