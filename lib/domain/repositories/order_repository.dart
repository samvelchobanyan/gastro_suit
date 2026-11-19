import '../../core/locale/content_language.dart';
import '../entities/buy_again.dart';
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

  /// The user's latest orders, newest first: enough of them to hold every
  /// order still on its way.
  Future<List<Order>> getRecentOrders(ContentLanguage language);

  /// One page of all the user's orders, newest first; pages count from 1.
  Future<OrderPage> getOrders({
    required int page,
    required ContentLanguage language,
  });

  /// One order, as it stands now.
  Future<Order> getOrder(String id, ContentLanguage language);

  /// What the user ordered before, newest first: each product as it was
  /// chosen, once per branch it was ordered from.
  Future<List<BuyAgainItem>> getBuyAgain(ContentLanguage language);
}
