import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/order.dart';
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
    this.scheduledAt,
    this.location,
    this.gatewayOrderId,
    this.posNumber,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  final String id;
  final String? status;

  /// Null for as soon as possible.
  final DateTime? scheduledAt;
  final OrderLocationDto? location;

  /// What paying the order with a saved card takes.
  final String? gatewayOrderId;

  /// The number the order is called by at the counter.
  final String? posNumber;

  Order toDomain(ContentLanguage language) => Order(
    id: id,
    status: _status(status),
    number: posNumber,
    branchName: localized(
      location?.name,
      language,
      internalName: location?.internalName,
    ),
    scheduledAt: scheduledAt?.toLocal(),
  );

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
  const OrderLocationDto({this.internalName, this.name});

  factory OrderLocationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderLocationDtoFromJson(json);

  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;
}
