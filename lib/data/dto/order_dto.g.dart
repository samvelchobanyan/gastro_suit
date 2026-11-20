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
  paymentStatus: json['paymentStatus'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  locationId: json['locationId'] as String?,
  location: json['location'] == null
      ? null
      : OrderLocationDto.fromJson(json['location'] as Map<String, dynamic>),
  comment: json['comment'] as String?,
  itemsTotal: (json['itemsTotal'] as num?)?.toInt(),
  discount: (json['discount'] as num?)?.toInt(),
  walletSpent: (json['walletSpent'] as num?)?.toInt(),
  walletReturned: (json['walletReturned'] as num?)?.toInt(),
  totalToCharge: (json['totalToCharge'] as num?)?.toInt(),
  tipAmount: (json['tipAmount'] as num?)?.toInt(),
  gatewayOrderId: json['gatewayOrderId'] as String?,
  posNumber: json['posNumber'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderLineDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

OrderLocationDto _$OrderLocationDtoFromJson(Map<String, dynamic> json) =>
    OrderLocationDto(
      internalName: json['internalName'] as String?,
      name: translationsFromJson(json['name']),
      address: translationsFromJson(json['address']),
    );

OrderLineDto _$OrderLineDtoFromJson(Map<String, dynamic> json) => OrderLineDto(
  itemId: json['itemId'] as String?,
  name: json['name'] as String?,
  imageUrl: json['imageUrl'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  unitPrice: (json['unitPrice'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  modifiersJson: (json['modifiersJson'] as List<dynamic>?)
      ?.map((e) => SelectedModifierDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);
