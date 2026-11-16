import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_card.freezed.dart';

/// The user's place in the restaurant's loyalty programme: the points they
/// have, their tier, and the card the cashier scans at the counter.
@freezed
abstract class LoyaltyCard with _$LoyaltyCard {
  const factory LoyaltyCard({
    required int points,

    /// What the cashier scans; the QR code shows this number.
    required String number,

    /// The tier as the restaurant names it; null when it names none. Only a
    /// name so far: the API gives a tier no percent.
    String? tier,
  }) = _LoyaltyCard;
}
