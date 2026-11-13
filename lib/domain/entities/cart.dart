import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_choice.dart';

part 'cart.freezed.dart';

/// What the user is about to order (DOMAIN_SPEC §5). One per user, kept by
/// the server, and tied to one branch.
@freezed
abstract class Cart with _$Cart {
  const factory Cart({
    /// Null while the server holds no cart for the branch.
    String? id,
    required String branchId,
    required List<CartLine> lines,

    /// The sum of the lines, as the server priced them.
    required int total,
  }) = _Cart;

  const Cart._();

  bool get isEmpty => lines.isEmpty;

  /// How many pieces the cart holds: the quantities of its lines together.
  int get itemCount => lines.fold(0, (sum, line) => sum + line.quantity);

  /// Whether any line cannot be ordered now; an order is refused while one
  /// is there.
  bool get hasUnavailable => lines.any((line) => !line.isAvailable);
}

/// One product of the cart with what was chosen for it.
@freezed
abstract class CartLine with _$CartLine {
  const factory CartLine({
    /// The line's own id: what changing its quantity and removing it take.
    required String id,
    required ProductChoice choice,
    String? imageUrl,
    required int quantity,

    /// The price of one, add-ons included.
    required int unitPrice,
    required int total,

    /// False: the branch cannot make it now.
    required bool isAvailable,

    /// The server's code of why not; null when [isAvailable].
    String? unavailableReason,
  }) = _CartLine;
}
