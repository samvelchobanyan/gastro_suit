import '../../core/locale/content_language.dart';
import '../entities/cart.dart';
import '../entities/product_choice.dart';

/// The signed-in user's cart. Every change answers with the whole cart as
/// it now stands. Throws only `AppException`.
abstract interface class CartRepository {
  /// The cart as [branchId] sees it: empty when the user's cart is at
  /// another branch (that cart is left as it is).
  Future<Cart> getCart({
    required String branchId,
    required ContentLanguage language,
  });

  /// Adds [quantity] of [choice] at [branchId]. A choice already in the
  /// cart gets the quantity added to its line. Adding at another branch
  /// than the cart's replaces the cart: its earlier lines are gone.
  Future<Cart> addItem({
    required String branchId,
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  });

  /// Sets the quantity of the line [lineId]; 0 removes it.
  Future<Cart> setQuantity(
    String lineId, {
    required int quantity,
    required ContentLanguage language,
  });

  Future<Cart> removeLine(String lineId, {required ContentLanguage language});

  /// Empties the cart at [branchId].
  Future<Cart> clear({
    required String branchId,
    required ContentLanguage language,
  });
}
