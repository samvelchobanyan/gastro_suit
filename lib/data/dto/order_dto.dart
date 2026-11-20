import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/product_choice.dart';
import 'cart_dto.dart';
import 'localized_text.dart';

part 'order_dto.g.dart';

/// `OrderPlacedResponse`: what placing an order answers with.
@JsonSerializable(createToJson: false)
class OrderPlacedDto {
  const OrderPlacedDto({required this.order});

  factory OrderPlacedDto.fromJson(Map<String, dynamic> json) =>
      _$OrderPlacedDtoFromJson(json);

  final OrderDto order;

  PlacedOrder toDomain(ContentLanguage language) {
    final placed = order.toDomain(language);
    return (
      order: placed,
      // Only an order that still awaits payment has something to pay by.
      paymentReference: placed.status == OrderStatus.awaitingPayment
          ? order.gatewayOrderId
          : null,
    );
  }
}

/// `CardPaidResponse`: what paying with a saved card answers with.
@JsonSerializable(createToJson: false)
class CardPaidDto {
  const CardPaidDto({this.success, this.order});

  factory CardPaidDto.fromJson(Map<String, dynamic> json) =>
      _$CardPaidDtoFromJson(json);

  final bool? success;
  final OrderDto? order;
}

/// `OrderResponse`. Only what the app uses is read.
@JsonSerializable(createToJson: false)
class OrderDto {
  const OrderDto({
    required this.id,
    this.status,
    this.paymentStatus,
    this.scheduledAt,
    this.locationId,
    this.location,
    this.comment,
    this.itemsTotal,
    this.discount,
    this.walletSpent,
    this.walletReturned,
    this.totalToCharge,
    this.tipAmount,
    this.gatewayOrderId,
    this.posNumber,
    this.createdAt,
    this.items,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  final String id;
  final String? status;
  final String? paymentStatus;

  /// Null for as soon as possible.
  final DateTime? scheduledAt;
  final String? locationId;
  final OrderLocationDto? location;
  final String? comment;

  /// The lines, before anything is taken off.
  final int? itemsTotal;
  final int? discount;

  /// What the wallet paid, and what of that came back when the till closed
  /// the order without taking it.
  final int? walletSpent;
  final int? walletReturned;

  /// What the card paid, the tip included.
  final int? totalToCharge;
  final int? tipAmount;

  /// What paying the order with a saved card takes.
  final String? gatewayOrderId;

  /// The number the order is called by at the counter.
  final String? posNumber;
  final DateTime? createdAt;
  final List<OrderLineDto>? items;

  Order toDomain(ContentLanguage language) {
    final address = location?.address == null
        ? ''
        : localized(location?.address, language);
    final comment = this.comment;
    return Order(
      id: id,
      status: _status(status),
      number: posNumber,
      branchId: locationId ?? '',
      branchName: localized(
        location?.name,
        language,
        internalName: location?.internalName,
      ),
      branchAddress: address.isEmpty ? null : address,
      placedAt: createdAt?.toLocal(),
      scheduledAt: scheduledAt?.toLocal(),
      lines: [
        for (final item in items ?? const <OrderLineDto>[]) item.toDomain(),
      ],
      subtotal: itemsTotal ?? 0,
      discount: discount ?? 0,
      tip: tipAmount ?? 0,
      total: (totalToCharge ?? 0) + (walletSpent ?? 0) - (walletReturned ?? 0),
      comment: comment == null || comment.isEmpty ? null : comment,
      isPaid: paymentStatus == 'captured',
    );
  }

  /// An unknown status is shown as an order just placed.
  static OrderStatus _status(String? status) => switch (status) {
    'payment_pending' => OrderStatus.awaitingPayment,
    'accepted' => OrderStatus.accepted,
    'preparing' => OrderStatus.preparing,
    'ready' => OrderStatus.ready,
    'completed' => OrderStatus.collected,
    'cancelled' => OrderStatus.cancelled,
    'payment_failed' => OrderStatus.paymentFailed,
    _ => OrderStatus.placed,
  };
}

/// `OrderLocationResponse`: the branch an order is collected from.
@JsonSerializable(createToJson: false)
class OrderLocationDto {
  const OrderLocationDto({this.internalName, this.name, this.address});

  factory OrderLocationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLocationDtoFromJson(json);

  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? address;
}

/// `OrderLineResponse`: one dish of an order, as it was named and priced
/// when ordered.
@JsonSerializable(createToJson: false)
class OrderLineDto {
  const OrderLineDto({
    this.itemId,
    this.name,
    this.imageUrl,
    this.quantity,
    this.unitPrice,
    this.total,
    this.modifiersJson,
  });

  factory OrderLineDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLineDtoFromJson(json);

  /// Null when the dish has since left the menu.
  final String? itemId;
  final String? name;
  final String? imageUrl;
  final int? quantity;
  final int? unitPrice;
  final int? total;

  /// What was chosen: the size and the add-ons in one list, as in the cart.
  final List<SelectedModifierDto>? modifiersJson;

  /// The id prefix of the group that holds a dish's sizes.
  static const _sizeGroupPrefix = 'size:';

  OrderLine toDomain() {
    final chosen = modifiersJson ?? const <SelectedModifierDto>[];
    bool isSize(SelectedModifierDto m) =>
        m.groupId?.startsWith(_sizeGroupPrefix) ?? false;
    final size = chosen.where(isSize).firstOrNull;
    final imageUrl = this.imageUrl;
    return OrderLine(
      imageUrl: imageUrl == null || imageUrl.isEmpty ? null : imageUrl,
      choice: ProductChoice(
        productId: itemId ?? '',
        productName: name ?? '',
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
                quantity: m.quantity ?? 1,
              ),
        ],
      ),
      quantity: quantity ?? 1,
      unitPrice: unitPrice ?? 0,
      total: total ?? 0,
    );
  }
}
