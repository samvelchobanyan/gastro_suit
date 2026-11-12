// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: json['id'] as String,
  internalName: json['internalName'] as String?,
  name: translationsFromJson(json['name']),
  description: translationsFromJson(json['description']),
  imageUrl: json['imageUrl'] as String?,
  categoryId: json['categoryId'] as String?,
  price: (json['price'] as num?)?.toInt(),
  isAvailable: json['isAvailable'] as bool?,
  isFeatured: json['isFeatured'] as bool?,
  portion: json['portion'] == null
      ? null
      : PortionDto.fromJson(json['portion'] as Map<String, dynamic>),
  modifiersJson: (json['modifiersJson'] as List<dynamic>?)
      ?.map((e) => ModifierGroupDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  unavailableModifiers: (json['unavailableModifiers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  optionNames: _optionNamesFromJson(json['optionNames']),
);

ModifierGroupDto _$ModifierGroupDtoFromJson(Map<String, dynamic> json) =>
    ModifierGroupDto(
      id: json['id'] as String,
      name: json['name'] as String?,
      kind: json['kind'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ModifierOptionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      restrictions: json['restrictions'] == null
          ? null
          : ModifierRestrictionsDto.fromJson(
              json['restrictions'] as Map<String, dynamic>,
            ),
    );

ModifierOptionDto _$ModifierOptionDtoFromJson(Map<String, dynamic> json) =>
    ModifierOptionDto(
      id: json['id'] as String,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      restrictions: json['restrictions'] == null
          ? null
          : ModifierRestrictionsDto.fromJson(
              json['restrictions'] as Map<String, dynamic>,
            ),
    );

ModifierRestrictionsDto _$ModifierRestrictionsDtoFromJson(
  Map<String, dynamic> json,
) => ModifierRestrictionsDto(
  minQuantity: json['minQuantity'] as num?,
  maxQuantity: json['maxQuantity'] as num?,
  defaultQuantity: json['defaultQuantity'] as num?,
);

PortionDto _$PortionDtoFromJson(Map<String, dynamic> json) =>
    PortionDto(amount: json['amount'] as num?, unit: json['unit'] as String?);
