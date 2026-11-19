import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_choice.dart';

part 'order.freezed.dart';

/// Where an order is, as the user sees it.
enum OrderStatus {
  awaitingPayment,

  /// Paid and sent to the restaurant.
  placed,

  /// The restaurant took it.
  accepted,
  preparing,
  ready,
  collected,
  cancelled,
  paymentFailed,
}

/// An order the user placed (DOMAIN_SPEC §6). After it is placed its
/// contents and prices do not change; only its status does.
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required OrderStatus status,

    /// The short number the order is called by at the counter; null until
    /// the restaurant's till has given it one.
    String? number,

    /// The branch to collect from: its id, and its name and address in the
    /// app's language.
    @Default('') String branchId,
    required String branchName,
    String? branchAddress,

    /// When it was placed.
    DateTime? placedAt,

    /// When it is wanted for; null for as soon as possible.
    DateTime? scheduledAt,

    /// What was ordered, as it was named and priced then.
    @Default([]) List<OrderLine> lines,

    /// The lines together, before anything is taken off or added.
    @Default(0) int subtotal,

    /// What the restaurant took off; 0 for nothing.
    @Default(0) int discount,

    /// The user's tip; 0 for none.
    @Default(0) int tip,

    /// What the order cost the user: [subtotal] − [discount] + [tip].
    @Default(0) int total,

    /// What the user wrote to the kitchen.
    String? comment,

    /// Whether the money for it was taken.
    @Default(false) bool isPaid,
  }) = _Order;

  const Order._();

  /// Whether the order belongs in the user's history: one that was never
  /// paid for is not an order they made.
  bool get isInHistory =>
      status != OrderStatus.awaitingPayment &&
      status != OrderStatus.paymentFailed;
}

/// One product of an order with what was chosen for it.
@freezed
abstract class OrderLine with _$OrderLine {
  const factory OrderLine({
    /// The product's id is empty when it has since left the menu; its name
    /// is the one it was ordered under.
    required ProductChoice choice,
    required int quantity,

    /// The price of one, add-ons included.
    required int unitPrice,
    required int total,
  }) = _OrderLine;
}

/// What placing an order answers with: the order, and what to pay it by.
///
/// [paymentReference] is the payment's own name for the order, which paying
/// with a saved card takes. Null when nothing is left to pay.
typedef PlacedOrder = ({Order order, String? paymentReference});

/// One page of the user's orders, newest first. [hasMore] is false on the
/// last page.
typedef OrderPage = ({List<Order> orders, bool hasMore});
