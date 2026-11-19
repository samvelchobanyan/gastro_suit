// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_again_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyAgainDto _$BuyAgainDtoFromJson(Map<String, dynamic> json) => BuyAgainDto(
  againId: json['againId'] as String,
  item: BuyAgainNamedDto.fromJson(json['item'] as Map<String, dynamic>),
  branch: BuyAgainNamedDto.fromJson(json['branch'] as Map<String, dynamic>),
  available: json['available'] as bool?,
);

BuyAgainNamedDto _$BuyAgainNamedDtoFromJson(Map<String, dynamic> json) =>
    BuyAgainNamedDto(
      id: json['id'] as String,
      internalName: json['internalName'] as String?,
      name: translationsFromJson(json['name']),
      imageUrl: json['imageUrl'] as String?,
    );
