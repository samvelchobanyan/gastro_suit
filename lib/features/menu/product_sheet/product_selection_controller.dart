import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/entities/product_choice.dart';

part 'product_selection_controller.freezed.dart';

/// What the user has chosen for a product so far, with what follows from
/// it: the price and whether it can be added to the cart.
@freezed
abstract class ProductSelection with _$ProductSelection {
  const factory ProductSelection({
    /// Null for a product without sizes, or when every size has run out.
    String? sizeId,

    /// The chosen options of every group together.
    required Set<String> optionIds,
    required int quantity,

    /// The price of one: the size's price (the base price without sizes)
    /// plus the surcharges of the chosen options. A preview: the server
    /// prices the cart line.
    required int unitPrice,

    /// Whether this may be added: the product and a size are available,
    /// and every group has as many options chosen as it asks for.
    required bool isComplete,
  }) = _ProductSelection;

  const ProductSelection._();

  int get total => unitPrice * quantity;
}

/// The selection on a product's sheet: starts from the defaults (the
/// default size, the pre-selected options, one piece) and changes as the
/// user taps.
class ProductSelectionController extends Notifier<ProductSelection> {
  ProductSelectionController(this.product);

  final Product product;

  static const maxQuantity = 99;

  @override
  ProductSelection build() => _selection(
    sizeId: product.defaultSize?.id,
    optionIds: {
      for (final group in product.optionGroups)
        for (final option in group.defaultOptions) option.id,
    },
    quantity: 1,
  );

  /// A size the branch has run out of is not taken.
  void selectSize(String sizeId) {
    final size = product.sizes.where((s) => s.id == sizeId).firstOrNull;
    if (size == null || !size.isAvailable) return;
    state = _selection(
      sizeId: sizeId,
      optionIds: state.optionIds,
      quantity: state.quantity,
    );
  }

  /// Chooses [optionId] of [groupId], or takes it back when it is chosen.
  ///
  /// In a single-choice group the new option replaces the chosen one, and
  /// the only option of a required one cannot be taken back. In other
  /// groups an option over the group's maximum is not taken. Neither is an
  /// option the branch has run out of.
  void toggleOption(String groupId, String optionId) {
    final group = product.optionGroups
        .where((g) => g.id == groupId)
        .firstOrNull;
    final option = group?.options.where((o) => o.id == optionId).firstOrNull;
    if (group == null || option == null || !option.isAvailable) return;

    final chosen = {...state.optionIds};
    final chosenInGroup = group.options
        .where((o) => chosen.contains(o.id))
        .length;
    if (chosen.contains(optionId)) {
      if (group.isSingleChoice && group.isRequired) return;
      chosen.remove(optionId);
    } else if (group.isSingleChoice) {
      chosen
        ..removeAll(group.options.map((o) => o.id))
        ..add(optionId);
    } else {
      final max = group.maxSelected;
      if (max != null && chosenInGroup >= max) return;
      chosen.add(optionId);
    }
    state = _selection(
      sizeId: state.sizeId,
      optionIds: chosen,
      quantity: state.quantity,
    );
  }

  /// The selection as the cart takes it: the product with the chosen size
  /// and options. The quantity goes with it separately.
  ProductChoice get choice {
    final size = product.sizes.where((s) => s.id == state.sizeId).firstOrNull;
    return ProductChoice(
      productId: product.id,
      productName: product.name,
      size: size == null ? null : ChosenSize(id: size.id, name: size.name),
      options: [
        for (final group in product.optionGroups)
          for (final option in group.options)
            if (state.optionIds.contains(option.id))
              ChosenOption(
                id: option.id,
                groupId: group.id,
                name: option.name,
                price: option.price,
              ),
      ],
    );
  }

  /// Kept between 1 and [maxQuantity].
  void setQuantity(int quantity) {
    state = state.copyWith(quantity: quantity.clamp(1, maxQuantity));
  }

  ProductSelection _selection({
    required String? sizeId,
    required Set<String> optionIds,
    required int quantity,
  }) {
    final size = product.sizes.where((s) => s.id == sizeId).firstOrNull;
    var unitPrice = size?.price ?? product.price;
    var groupsFilled = true;
    for (final group in product.optionGroups) {
      final chosen = group.options.where((o) => optionIds.contains(o.id));
      for (final option in chosen) {
        unitPrice += option.price;
      }
      final count = chosen.length;
      final max = group.maxSelected;
      if (count < group.minSelected || (max != null && count > max)) {
        groupsFilled = false;
      }
    }
    return ProductSelection(
      sizeId: sizeId,
      optionIds: optionIds,
      quantity: quantity,
      unitPrice: unitPrice,
      isComplete:
          product.isAvailable &&
          (product.sizes.isEmpty || size != null) &&
          groupsFilled,
    );
  }
}

/// The selection for one product: `productSelectionProvider(product)`.
/// Lives while the product's sheet is open; a product that changed (the
/// menu was loaded again) starts from its defaults.
final productSelectionProvider = NotifierProvider.autoDispose
    .family<ProductSelectionController, ProductSelection, Product>(
      ProductSelectionController.new,
    );
