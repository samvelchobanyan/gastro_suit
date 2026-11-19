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
  /// than the cart's replaces the cart: its earlier lines are gone (they
  /// are kept only by [moveTo]).
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

  /// Puts [choice] and [quantity] in place of what the line [lineId]
  /// holds; the line keeps its place. A choice another line of the same
  /// product already holds merges into that line, and this one is gone.
  Future<Cart> changeLine(
    String lineId, {
    required ProductChoice choice,
    required int quantity,
    required ContentLanguage language,
  });

  Future<Cart> removeLine(String lineId, {required ContentLanguage language});

  /// Adds one piece of the buy-again item [buyAgainId], as it was ordered,
  /// to the cart of the branch it was ordered from. A cart of another
  /// branch is replaced, as by [addItem].
  Future<Cart> addAgain(String buyAgainId, {required ContentLanguage language});

  /// Moves the cart to [branchId]: it keeps its lines, each priced there.
  /// A line that branch cannot make stays, marked unavailable.
  Future<Cart> moveTo({
    required String branchId,
    required ContentLanguage language,
  });

  /// Empties the cart at [branchId].
  Future<Cart> clear({
    required String branchId,
    required ContentLanguage language,
  });
}
