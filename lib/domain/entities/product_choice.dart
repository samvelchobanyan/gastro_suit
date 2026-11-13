import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_choice.freezed.dart';

/// What was chosen for one product: the product, its size if it has sizes,
/// and the chosen add-ons (DOMAIN_SPEC §4). The part a cart line and an
/// order line share.
///
/// Carries no quantity and no line prices: those belong to the line.
@freezed
abstract class ProductChoice with _$ProductChoice {
  const factory ProductChoice({
    required String productId,
    required String productName,

    /// Null for a product without sizes.
    ChosenSize? size,

    /// Empty when nothing is chosen.
    required List<ChosenOption> options,
  }) = _ProductChoice;
}

/// The size of a [ProductChoice].
@freezed
abstract class ChosenSize with _$ChosenSize {
  const factory ChosenSize({required String id, required String name}) =
      _ChosenSize;
}

/// One add-on of a [ProductChoice].
@freezed
abstract class ChosenOption with _$ChosenOption {
  const factory ChosenOption({
    required String id,
    required String groupId,
    required String name,

    /// What it adds to the product's price; 0 when free.
    required int price,
  }) = _ChosenOption;
}
