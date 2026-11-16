import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

/// The user's money at the restaurant, in the currency of the instance.
///
/// What the user topped up themselves never expires; money from elsewhere
/// (a gift, a credit from the restaurant) may.
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    /// All of it.
    required int total,

    /// What the user topped up themselves. Does not expire.
    required int ownTopUp,

    /// What came as gifts.
    required int gifts,

    /// How much of the wallet expires next, on [expiresAt]; 0 when nothing
    /// does.
    required int expiring,

    /// When [expiring] expires; null when nothing does.
    DateTime? expiresAt,
  }) = _Wallet;
}
