import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/cart.dart';
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

    /// The chosen options of every group together, each with how many of
    /// it one product carries (1 or more).
    required Map<String, int> optionQuantities,
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

/// What a selection is made for: a product, and the cart line being
/// changed when the sheet was opened from the cart.
typedef ProductSelectionTarget = ({Product product, CartLine? editing});

/// The selection on a product's sheet: starts from the defaults (the
/// default size, the pre-selected options, one piece), or from what a cart
/// line holds, and changes as the user taps.
class ProductSelectionController extends Notifier<ProductSelection> {
  ProductSelectionController(ProductSelectionTarget target)
    : product = target.product,
      editing = target.editing;

  final Product product;

  /// The cart line the selection starts from; null for a new one.
  final CartLine? editing;

  static const maxQuantity = 99;

  @override
  ProductSelection build() {
    final line = editing;
    if (line == null) {
      return _selection(
        sizeId: product.defaultSize?.id,
        optionQuantities: {
          for (final group in product.optionGroups)
            for (final option in group.defaultOptions) option.id: 1,
        },
        quantity: 1,
      );
    }

    // What the line holds, as far as the branch still offers it: a size
    // that is gone gives way to the default one, an option that is gone is
    // left out.
    final chosen = {
      for (final option in line.choice.options) option.id: option.quantity,
    };
    final size = product.sizes
        .where((s) => s.id == line.choice.size?.id && s.isAvailable)
        .firstOrNull;
    return _selection(
      sizeId: (size ?? product.defaultSize)?.id,
      optionQuantities: {
        for (final group in product.optionGroups)
          for (final option in group.options)
            if (option.isAvailable)
              if (chosen[option.id] case final quantity?)
                option.id: quantity.clamp(1, option.maxQuantity),
      },
      quantity: line.quantity.clamp(1, maxQuantity),
    );
  }

  /// A size the branch has run out of is not taken.
  void selectSize(String sizeId) {
    final size = product.sizes.where((s) => s.id == sizeId).firstOrNull;
    if (size == null || !size.isAvailable) return;
    state = _selection(
      sizeId: sizeId,
      optionQuantities: state.optionQuantities,
      quantity: state.quantity,
    );
  }

  /// Chooses one of [optionId] of [groupId], or takes the option back
  /// when it is chosen.
  ///
  /// In a single-choice group the new option replaces the chosen one, and
  /// the only option of a required one cannot be taken back. In other
  /// groups an option over the group's maximum is not taken. Neither is an
  /// option the branch has run out of.
  void toggleOption(String groupId, String optionId) {
    final (group, option) = _find(groupId, optionId);
    if (group == null || option == null || !option.isAvailable) return;

    final chosen = {...state.optionQuantities};
    if (chosen.containsKey(optionId)) {
      if (group.isSingleChoice && group.isRequired) return;
      chosen.remove(optionId);
    } else if (group.isSingleChoice) {
      for (final other in group.options) {
        chosen.remove(other.id);
      }
      chosen[optionId] = 1;
    } else {
      if (maxQuantityOf(groupId, optionId) < 1) return;
      chosen[optionId] = 1;
    }
    state = _selection(
      sizeId: state.sizeId,
      optionQuantities: chosen,
      quantity: state.quantity,
    );
  }

  /// How many of the chosen option [optionId] one product carries, kept
  /// between 1 and [maxQuantityOf]. An option that is not chosen is left
  /// alone: [toggleOption] chooses it.
  void setOptionQuantity(String groupId, String optionId, int quantity) {
    if (!state.optionQuantities.containsKey(optionId)) return;
    final max = maxQuantityOf(groupId, optionId);
    if (max < 1) return;
    state = _selection(
      sizeId: state.sizeId,
      optionQuantities: {
        ...state.optionQuantities,
        optionId: quantity.clamp(1, max),
      },
      quantity: state.quantity,
    );
  }

  /// The most of [optionId] the selection can hold now: what the option
  /// allows on one product, and what its group has left once the group's
  /// other chosen options are counted. 0 when it cannot be chosen.
  int maxQuantityOf(String groupId, String optionId) {
    final (group, option) = _find(groupId, optionId);
    if (group == null || option == null || !option.isAvailable) return 0;
    final groupMax = group.maxSelected;
    if (groupMax == null) return option.maxQuantity;
    var others = 0;
    for (final other in group.options) {
      if (other.id != optionId) {
        others += state.optionQuantities[other.id] ?? 0;
      }
    }
    return math.max(0, math.min(option.maxQuantity, groupMax - others));
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
            if (state.optionQuantities[option.id] case final quantity?)
              ChosenOption(
                id: option.id,
                groupId: group.id,
                name: option.name,
                price: option.price,
                quantity: quantity,
              ),
      ],
    );
  }

  /// Kept between 1 and [maxQuantity].
  void setQuantity(int quantity) {
    state = state.copyWith(quantity: quantity.clamp(1, maxQuantity));
  }

  (ProductOptionGroup?, ProductOption?) _find(String groupId, String optionId) {
    final group = product.optionGroups
        .where((g) => g.id == groupId)
        .firstOrNull;
    final option = group?.options.where((o) => o.id == optionId).firstOrNull;
    return (group, option);
  }

  ProductSelection _selection({
    required String? sizeId,
    required Map<String, int> optionQuantities,
    required int quantity,
  }) {
    final size = product.sizes.where((s) => s.id == sizeId).firstOrNull;
    var unitPrice = size?.price ?? product.price;
    var groupsFilled = true;
    for (final group in product.optionGroups) {
      // A group counts the pieces of its options together.
      var count = 0;
      for (final option in group.options) {
        final chosen = optionQuantities[option.id] ?? 0;
        count += chosen;
        unitPrice += option.price * chosen;
      }
      final max = group.maxSelected;
      if (count < group.minSelected || (max != null && count > max)) {
        groupsFilled = false;
      }
    }
    return ProductSelection(
      sizeId: sizeId,
      optionQuantities: optionQuantities,
      quantity: quantity,
      unitPrice: unitPrice,
      isComplete:
          product.isAvailable &&
          (product.sizes.isEmpty || size != null) &&
          groupsFilled,
    );
  }
}

/// The selection for one product:
/// `productSelectionProvider((product: …, editing: …))`.
/// Lives while the product's sheet is open; a product that changed (the
/// menu was loaded again) starts over.
final productSelectionProvider = NotifierProvider.autoDispose
    .family<
      ProductSelectionController,
      ProductSelection,
      ProductSelectionTarget
    >(ProductSelectionController.new);
