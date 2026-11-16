import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/domain/entities/order.dart';
import 'package:gastro_suit/domain/entities/payment_card.dart';
import 'package:gastro_suit/domain/repositories/order_repository.dart';
import 'package:gastro_suit/domain/repositories/payment_repository.dart';

/// A server that takes orders: answers [placeOrder] with an order at
/// "Northern Avenue", paid already unless [awaitsPayment] is set.
class FakeOrderRepository implements OrderRepository {
  /// Every order placed: branch, time, tip.
  final placed = <(String, DateTime?, int)>[];

  /// The next orders come back to be paid, by the reference `pay-1`.
  var awaitsPayment = false;

  /// Thrown by the next orders when set.
  Object? error;

  /// What [getRecentOrders] answers with; changed to move an order on.
  var recent = <Order>[];

  /// How many times the recent orders were read.
  var recentReads = 0;

  /// Thrown by the next reads of the recent orders when set.
  Object? recentError;

  @override
  Future<List<Order>> getRecentOrders(ContentLanguage language) async {
    recentReads++;
    if (recentError case final error?) throw error;
    return recent;
  }

  @override
  Future<PlacedOrder> placeOrder({
    required String branchId,
    required DateTime? time,
    required int tip,
    required ContentLanguage language,
  }) async {
    if (error case final error?) throw error;
    placed.add((branchId, time, tip));
    return (
      order: Order(
        id: 'order-1',
        status: awaitsPayment
            ? OrderStatus.awaitingPayment
            : OrderStatus.accepted,
        branchName: 'Northern Avenue',
        scheduledAt: time,
      ),
      paymentReference: awaitsPayment ? 'pay-1' : null,
    );
  }
}

/// The user's saved [cards], and paying with them.
class FakePaymentRepository implements PaymentRepository {
  FakePaymentRepository([this.cards = const []]);

  final List<PaymentCard> cards;

  /// Every payment: card, reference.
  final paid = <(String, String)>[];

  /// Thrown by the next payments when set.
  Object? error;

  @override
  Future<List<PaymentCard>> getCards() async => cards;

  @override
  Future<Order> payWithCard(
    String cardId, {
    required String paymentReference,
    required ContentLanguage language,
  }) async {
    if (error case final error?) throw error;
    paid.add((cardId, paymentReference));
    return const Order(
      id: 'order-1',
      status: OrderStatus.accepted,
      branchName: 'Northern Avenue',
    );
  }
}
