import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/state/active_branch_state.dart';
import 'pickup_slots.dart';

part 'cart_checkout_controller.freezed.dart';

/// What the user chose on the cart sheet for the order to come: when they
/// want it and what tip they leave.
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
  }) = _CartCheckout;
}

/// The cart sheet's choices. Starts on "as soon as possible" and no tip
/// each time the sheet is opened; they go to the server with the order.
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
}

final cartCheckoutProvider =
    NotifierProvider.autoDispose<CartCheckoutController, CartCheckout>(
      CartCheckoutController.new,
    );
