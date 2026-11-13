import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/product_choice.dart';
import 'localized_text.dart';

part 'cart_dto.g.dart';

/// `CartResponse`: what every cart request answers with.
@JsonSerializable(createToJson: false)
class CartDto {
  const CartDto({this.id, required this.locationId, this.total, this.items});

  factory CartDto.fromJson(Map<String, dynamic> json) =>
      _$CartDtoFromJson(json);

  final String? id;
  final String locationId;
  final int? total;
  final List<CartLineDto>? items;

  Cart toDomain(ContentLanguage language) => Cart(
    id: id,
    branchId: locationId,
    total: total ?? 0,
    lines: [
      for (final item in items ?? const <CartLineDto>[])
        item.toDomain(language),
    ],
  );
}

/// `CartLineResponse`. Only what the app uses is read.
@JsonSerializable(createToJson: false)
class CartLineDto {
  const CartLineDto({
    required this.id,
    required this.itemId,
    this.quantity,
    this.unitPrice,
    this.total,
    this.modifiersJson,
    this.item,
    this.available,
    this.unavailableReason,
  });

  factory CartLineDto.fromJson(Map<String, dynamic> json) =>
      _$CartLineDtoFromJson(json);

  final String id;
  final String itemId;
  final int? quantity;
  final int? unitPrice;
  final int? total;

  /// What was chosen: the size and the add-ons in one list. Null when
  /// nothing was.
  final List<SelectedModifierDto>? modifiersJson;
  final CartLineItemDto? item;
  final bool? available;
  final String? unavailableReason;

  /// The id prefix of the group that holds a dish's sizes.
  static const _sizeGroupPrefix = 'size:';

  CartLine toDomain(ContentLanguage language) {
    final chosen = modifiersJson ?? const <SelectedModifierDto>[];
    bool isSize(SelectedModifierDto m) =>
        m.groupId?.startsWith(_sizeGroupPrefix) ?? false;
    final size = chosen.where(isSize).firstOrNull;
    final imageUrl = item?.imageUrl;

    return CartLine(
      id: id,
      choice: ProductChoice(
        productId: itemId,
        productName: localized(
          item?.name,
          language,
          internalName: item?.internalName,
        ),
        size: size == null
            ? null
            : ChosenSize(id: size.id, name: size.name ?? ''),
        options: [
          for (final m in chosen)
            if (!isSize(m))
              ChosenOption(
                id: m.id,
                groupId: m.groupId ?? '',
                name: m.name ?? '',
                price: m.price ?? 0,
              ),
        ],
      ),
      imageUrl: imageUrl == null || imageUrl.isEmpty ? null : imageUrl,
      quantity: quantity ?? 1,
      unitPrice: unitPrice ?? 0,
      total: total ?? 0,
      isAvailable: available ?? true,
      unavailableReason: unavailableReason,
    );
  }
}

/// `SelectedModifierResponse`: one chosen size or add-on; its name is
/// already in the request's language.
@JsonSerializable(createToJson: false)
class SelectedModifierDto {
  const SelectedModifierDto({
    required this.id,
    this.name,
    this.price,
    this.groupId,
  });

  factory SelectedModifierDto.fromJson(Map<String, dynamic> json) =>
      _$SelectedModifierDtoFromJson(json);

  final String id;
  final String? name;
  final int? price;
  final String? groupId;
}

/// The dish of a cart line: enough to draw the line.
@JsonSerializable(createToJson: false)
class CartLineItemDto {
  const CartLineItemDto({this.internalName, this.name, this.imageUrl});

  factory CartLineItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartLineItemDtoFromJson(json);

  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;
  final String? imageUrl;
}
