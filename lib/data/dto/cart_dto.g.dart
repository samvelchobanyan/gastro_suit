// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDto _$CartDtoFromJson(Map<String, dynamic> json) => CartDto(
  id: json['id'] as String?,
  locationId: json['locationId'] as String,
  total: (json['total'] as num?)?.toInt(),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => CartLineDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

CartLineDto _$CartLineDtoFromJson(Map<String, dynamic> json) => CartLineDto(
  id: json['id'] as String,
  itemId: json['itemId'] as String,
  quantity: (json['quantity'] as num?)?.toInt(),
  unitPrice: (json['unitPrice'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  modifiersJson: (json['modifiersJson'] as List<dynamic>?)
      ?.map((e) => SelectedModifierDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  item: json['item'] == null
      ? null
      : CartLineItemDto.fromJson(json['item'] as Map<String, dynamic>),
  available: json['available'] as bool?,
  unavailableReason: json['unavailableReason'] as String?,
);

SelectedModifierDto _$SelectedModifierDtoFromJson(Map<String, dynamic> json) =>
    SelectedModifierDto(
      id: json['id'] as String,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      groupId: json['groupId'] as String?,
    );

CartLineItemDto _$CartLineItemDtoFromJson(Map<String, dynamic> json) =>
    CartLineItemDto(
      internalName: json['internalName'] as String?,
      name: translationsFromJson(json['name']),
      imageUrl: json['imageUrl'] as String?,
    );
