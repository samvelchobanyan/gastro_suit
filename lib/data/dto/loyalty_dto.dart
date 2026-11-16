import 'package:json_annotation/json_annotation.dart';

part 'loyalty_dto.g.dart';

/// `LoyaltyBalanceResponse`. Only what the app uses is read: `cashback`,
/// `categories` and `wallets` are not (IMPLEMENTATION_NOTES §12).
@JsonSerializable(createToJson: false)
class LoyaltyBalanceDto {
  const LoyaltyBalanceDto({this.points, this.tier});

  factory LoyaltyBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyBalanceDtoFromJson(json);

  final num? points;

  /// The tier as the POS names it.
  final String? tier;
}

/// `CounterQrResponse`: the card the cashier scans. The picture the API
/// sends with it is not read: the app draws the code from the number.
@JsonSerializable(createToJson: false)
class CounterQrDto {
  const CounterQrDto({this.cardNumber});

  factory CounterQrDto.fromJson(Map<String, dynamic> json) =>
      _$CounterQrDtoFromJson(json);

  final String? cardNumber;
}
