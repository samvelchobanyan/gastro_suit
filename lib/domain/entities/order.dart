import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

/// Where an order is, as the user sees it.
enum OrderStatus {
  awaitingPayment,
  accepted,
  preparing,
  ready,
  collected,
  cancelled,
  paymentFailed,
}

/// An order the user placed. Holds what the screens built so far show;
/// its lines and amounts arrive with the screens that show them.
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required OrderStatus status,

    /// The branch to collect from, in the app's language.
    required String branchName,

    /// When it is wanted for; null for as soon as possible.
    DateTime? scheduledAt,
  }) = _Order;
}

/// What placing an order answers with: the order, and what to pay it by.
///
/// [paymentReference] is the payment's own name for the order, which paying
/// with a saved card takes. Null when nothing is left to pay.
typedef PlacedOrder = ({Order order, String? paymentReference});
