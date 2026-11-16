import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/wallet.dart';

part 'wallet_dto.g.dart';

/// `WalletBalanceResponse`. `promo` is not read: no screen shows it yet.
@JsonSerializable(createToJson: false)
class WalletDto {
  const WalletDto({
    this.total,
    this.ownTopUp,
    this.giftCard,
    this.expiring,
    this.expiryDate,
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) =>
      _$WalletDtoFromJson(json);

  final num? total;
  final num? ownTopUp;
  final num? giftCard;

  /// How much of the wallet expires on [expiryDate].
  final num? expiring;
  final DateTime? expiryDate;

  Wallet toDomain() {
    final expiring = this.expiring?.round() ?? 0;
    return Wallet(
      total: total?.round() ?? 0,
      ownTopUp: ownTopUp?.round() ?? 0,
      gifts: giftCard?.round() ?? 0,
      expiring: expiring,
      // A date with nothing to expire says nothing.
      expiresAt: expiring > 0 ? expiryDate?.toLocal() : null,
    );
  }
}
