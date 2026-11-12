import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/product.dart';
import 'localized_text.dart';

part 'product_dto.g.dart';

/// `ItemResponse`: a menu item as one branch offers it. Only what the app
/// uses is read.
@JsonSerializable(createToJson: false)
class ProductDto {
  const ProductDto({
    required this.id,
    this.internalName,
    this.name,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.price,
    this.isAvailable,
    this.isFeatured,
    this.portion,
    this.modifiersJson,
    this.unavailableModifiers,
    this.optionNames,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final String id;
  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? description;

  final String? imageUrl;
  final String? categoryId;
  final int? price;
  final bool? isAvailable;
  final bool? isFeatured;
  final PortionDto? portion;

  /// The item's sizes and add-on groups.
  final List<ModifierGroupDto>? modifiersJson;

  /// Ids of the options the branch has run out of.
  final List<String>? unavailableModifiers;

  /// Translations of group and option names, by their id. The names inside
  /// [modifiersJson] are the POS's own.
  @JsonKey(fromJson: _optionNamesFromJson)
  final Map<String, Map<String, String>>? optionNames;

  Product toDomain(ContentLanguage language) {
    final basePrice = price ?? 0;
    final groups = modifiersJson ?? const <ModifierGroupDto>[];
    final unavailable = {...?unavailableModifiers};
    String nameOf(String id, String? posName) =>
        localized(optionNames?[id], language, internalName: posName);

    // The first group of sizes is the product's sizes; every other group is
    // a group of add-ons.
    final sizeGroup = groups.where((g) => g.kind == 'size').firstOrNull;
    final sizeOptions = sizeGroup?.items ?? const <ModifierOptionDto>[];
    final marked = sizeOptions.indexWhere((o) => o.isDefault);
    final defaultIndex = marked < 0 ? 0 : marked;

    return Product(
      id: id,
      categoryId: categoryId ?? '',
      name: localized(name, language, internalName: internalName),
      description: localizedOrNull(description, language),
      imageUrl: imageUrl == null || imageUrl!.isEmpty ? null : imageUrl,
      price: basePrice,
      isAvailable: isAvailable ?? true,
      portion: portion?.toDomain(),
      isFeatured: isFeatured ?? false,
      sizes: [
        for (final (i, option) in sizeOptions.indexed)
          ProductSize(
            id: option.id,
            name: nameOf(option.id, option.name),
            // The API gives a size as a surcharge over the smallest one.
            price: basePrice + (option.price ?? 0),
            isAvailable: !unavailable.contains(option.id),
            isDefault: i == defaultIndex,
          ),
      ],
      optionGroups: [
        for (final group in groups)
          if (!identical(group, sizeGroup))
            ProductOptionGroup(
              id: group.id,
              name: nameOf(group.id, group.name),
              minSelected: group.restrictions?.minQuantity?.toInt() ?? 0,
              maxSelected: group.restrictions?.maxQuantity?.toInt(),
              options: [
                for (final option in group.items ?? const <ModifierOptionDto>[])
                  ProductOption(
                    id: option.id,
                    name: nameOf(option.id, option.name),
                    price: option.price ?? 0,
                    isAvailable: !unavailable.contains(option.id),
                    isDefault: option.isDefault,
                  ),
              ],
            ),
      ],
    );
  }
}

/// `ModifierGroupResponse`: the item's sizes (`kind: size`) or one group of
/// add-ons.
@JsonSerializable(createToJson: false)
class ModifierGroupDto {
  const ModifierGroupDto({
    required this.id,
    this.name,
    this.kind,
    this.items,
    this.restrictions,
  });

  factory ModifierGroupDto.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupDtoFromJson(json);

  final String id;
  final String? name;
  final String? kind;
  final List<ModifierOptionDto>? items;
  final ModifierRestrictionsDto? restrictions;
}

/// `ModifierOptionResponse`: one size or one add-on.
@JsonSerializable(createToJson: false)
class ModifierOptionDto {
  const ModifierOptionDto({
    required this.id,
    this.name,
    this.price,
    this.restrictions,
  });

  factory ModifierOptionDto.fromJson(Map<String, dynamic> json) =>
      _$ModifierOptionDtoFromJson(json);

  final String id;
  final String? name;
  final int? price;
  final ModifierRestrictionsDto? restrictions;

  /// Pre-selected by the merchant.
  bool get isDefault => (restrictions?.defaultQuantity ?? 0) > 0;
}

/// `ModifierRestrictionsResponse`: min and max on a group, default on an
/// option.
@JsonSerializable(createToJson: false)
class ModifierRestrictionsDto {
  const ModifierRestrictionsDto({
    this.minQuantity,
    this.maxQuantity,
    this.defaultQuantity,
  });

  factory ModifierRestrictionsDto.fromJson(Map<String, dynamic> json) =>
      _$ModifierRestrictionsDtoFromJson(json);

  final num? minQuantity;
  final num? maxQuantity;
  final num? defaultQuantity;
}

/// `PortionResponse`.
@JsonSerializable(createToJson: false)
class PortionDto {
  const PortionDto({this.amount, this.unit});

  factory PortionDto.fromJson(Map<String, dynamic> json) =>
      _$PortionDtoFromJson(json);

  final num? amount;
  final String? unit;

  /// Null without an amount or for a unit the app does not know: no portion
  /// is shown rather than a wrong one.
  Portion? toDomain() {
    final amount = this.amount;
    final unit = switch (this.unit) {
      'GRAM' => PortionUnit.gram,
      'KILOGRAM' => PortionUnit.kilogram,
      'MILLILITER' => PortionUnit.milliliter,
      'LITER' => PortionUnit.liter,
      _ => null,
    };
    if (amount == null || unit == null) return null;
    return Portion(amount: amount, unit: unit);
  }
}

/// Reads `optionNames`: translation maps by group or option id. An entry
/// that is not a translation map is skipped.
Map<String, Map<String, String>>? _optionNamesFromJson(Object? json) {
  if (json is! Map) return null;
  return {
    for (final entry in json.entries)
      if (entry.key is String)
        entry.key as String: ?translationsFromJson(entry.value),
  };
}
