import '../../core/locale/content_language.dart';
import '../entities/order.dart';

/// The signed-in user's orders. Throws only `AppException`.
abstract interface class OrderRepository {
  /// Turns the cart at [branchId] into an order for pickup at [time] (null
  /// for as soon as possible) with [tip] on top (0 for none).
  ///
  /// The order may come back paid already, or with what is left to pay it
  /// by (`PlacedOrder.paymentReference`). The cart is emptied once the
  /// order is paid, not before.
  Future<PlacedOrder> placeOrder({
    required String branchId,
    required DateTime? time,
    required int tip,
    required ContentLanguage language,
  });
}
