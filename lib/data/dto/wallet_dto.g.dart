// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletDto _$WalletDtoFromJson(Map<String, dynamic> json) => WalletDto(
  total: json['total'] as num?,
  ownTopUp: json['ownTopUp'] as num?,
  giftCard: json['giftCard'] as num?,
  expiring: json['expiring'] as num?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
);

WalletMovementDto _$WalletMovementDtoFromJson(Map<String, dynamic> json) =>
    WalletMovementDto(
      id: json['id'] as String,
      type: json['type'] as String?,
      status: json['status'] as String?,
      amount: json['amount'] as num?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
