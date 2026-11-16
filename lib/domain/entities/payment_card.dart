import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_card.freezed.dart';

/// A bank card the user saved to pay with.
@freezed
abstract class PaymentCard with _$PaymentCard {
  const factory PaymentCard({
    required String id,

    /// The number as the bank shows it, most of it hidden:
    /// `411111******1111`.
    required String maskedNumber,

    /// The card the user pays with unless they pick another.
    required bool isDefault,
  }) = _PaymentCard;

  const PaymentCard._();

  /// The digits a card is told from another by: the last four.
  String get lastDigits => maskedNumber.length <= 4
      ? maskedNumber
      : maskedNumber.substring(maskedNumber.length - 4);
}
