// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPlacedDto _$OrderPlacedDtoFromJson(Map<String, dynamic> json) =>
    OrderPlacedDto(
      order: OrderDto.fromJson(json['order'] as Map<String, dynamic>),
    );

CardPaidDto _$CardPaidDtoFromJson(Map<String, dynamic> json) => CardPaidDto(
  success: json['success'] as bool?,
  order: json['order'] == null
      ? null
      : OrderDto.fromJson(json['order'] as Map<String, dynamic>),
);

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
  id: json['id'] as String,
  status: json['status'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  location: json['location'] == null
      ? null
      : OrderLocationDto.fromJson(json['location'] as Map<String, dynamic>),
  gatewayOrderId: json['gatewayOrderId'] as String?,
);

OrderLocationDto _$OrderLocationDtoFromJson(Map<String, dynamic> json) =>
    OrderLocationDto(
      internalName: json['internalName'] as String?,
      name: translationsFromJson(json['name']),
    );
