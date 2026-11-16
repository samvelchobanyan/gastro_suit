import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/di/repositories.dart';
import '../../../core/network/app_exception.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/payment_card.dart';
import '../../../domain/state/active_branch_state.dart';
import '../../../domain/state/active_orders_state.dart';
import '../../../domain/state/cart_state.dart';
import '../../../domain/state/payment_cards_state.dart';
import '../../../domain/state/server_config_state.dart';
import 'pickup_slots.dart';

part 'cart_checkout_controller.freezed.dart';

/// What the user chose on the cart sheet for the order to come: when they
/// want it, what tip they leave and the card they pay with.
@freezed
abstract class CartCheckout with _$CartCheckout {
  const factory CartCheckout({
    /// The times offered besides "as soon as possible".
    required List<DateTime> slots,

    /// Null: as soon as possible.
    DateTime? time,

    /// The tip in whole currency; 0 for none.
    required int tip,

    /// The user is entering an amount of their own.
    required bool isCustomTip,

    /// The card the user picked to pay with; null until they pick one
    /// ([checkoutCardProvider] then answers with their default card).
    String? cardId,
  }) = _CartCheckout;
}

/// The cart sheet's choices, and placing the order with them. Starts on
/// "as soon as possible", no tip and the default card each time the sheet
/// is opened.
///
/// The times are worked out on the device for now (`pickupSlots`). When
/// the server offers them, they are loaded here in place of that.
class CartCheckoutController extends Notifier<CartCheckout> {
  /// The amounts offered between "no tip" and "other".
  static const tipPresets = [100, 200, 300];

  @override
  CartCheckout build() {
    final branch = ref.watch(activeBranchProvider).value;
    final now = DateTime.now();
    return CartCheckout(
      slots: pickupSlots(now, closesAt: closingTime(branch, now)),
      tip: 0,
      isCustomTip: false,
    );
  }

  /// Null for as soon as possible.
  void selectTime(DateTime? time) => state = state.copyWith(time: time);

  /// One of the offered amounts; 0 for no tip.
  void selectTip(int amount) =>
      state = state.copyWith(tip: amount, isCustomTip: false);

  /// Opens the field for an amount of the user's own; nothing until they
  /// enter one.
  void selectCustomTip() => state = state.copyWith(tip: 0, isCustomTip: true);

  /// The amount entered in that field; null while it is empty.
  void setCustomTip(int? amount) =>
      state = state.copyWith(tip: amount ?? 0, isCustomTip: true);

  /// One of the user's saved cards.
  void selectCard(String cardId) => state = state.copyWith(cardId: cardId);

  /// The card to pay with among [cards]: the one picked ([pickedId]),
  /// otherwise the default card, otherwise the first. Null without cards.
  static PaymentCard? cardFor(List<PaymentCard> cards, String? pickedId) =>
      cards.where((card) => card.id == pickedId).firstOrNull ??
      cards.where((card) => card.isDefault).firstOrNull ??
      cards.firstOrNull;

  /// Turns the cart into an order with the chosen time and tip, pays it
  /// with the chosen card when the server left it to be paid, and loads the
  /// cart again: a paid order has emptied it.
  ///
  /// Throws the `AppException` of a refused order or a declined card; the
  /// cart is then as it was.
  Future<Order> placeOrder() async {
    final cart = ref.read(cartProvider).value;
    if (cart == null || cart.isEmpty) {
      throw const AppException(AppExceptionKind.unknown);
    }
    final card = cardFor(
      ref.read(paymentCardsProvider).value ?? const [],
      state.cardId,
    );
    final language = await ref.read(contentLanguageProvider.future);

    final placed = await ref
        .read(orderRepositoryProvider)
        .placeOrder(
          branchId: cart.branchId,
          time: state.time,
          tip: state.tip,
          language: language,
        );
    var order = placed.order;
    if (placed.paymentReference case final reference?) {
      // Nothing to pay it with: paying with a new card is not built.
      if (card == null) throw const AppException(AppExceptionKind.unknown);
      order = await ref
          .read(paymentRepositoryProvider)
          .payWithCard(
            card.id,
            paymentReference: reference,
            language: language,
          );
    }
    ref.invalidate(cartProvider);
    ref.invalidate(activeOrdersProvider);
    return order;
  }
}

final cartCheckoutProvider =
    NotifierProvider.autoDispose<CartCheckoutController, CartCheckout>(
      CartCheckoutController.new,
    );

/// The card the order will be paid with: the one the user picked on the
/// cart sheet, otherwise their default card, otherwise their first. Null
/// while the cards load and when the user has none.
final checkoutCardProvider = Provider.autoDispose<PaymentCard?>((ref) {
  final cards = ref.watch(paymentCardsProvider).value ?? const [];
  final picked = ref.watch(cartCheckoutProvider.select((c) => c.cardId));
  return CartCheckoutController.cardFor(cards, picked);
});
