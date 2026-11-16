import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/payment_card.dart';

part 'payment_card_dto.g.dart';

/// `PaymentMethodResponse`: one saved card. Only what the app uses is read.
@JsonSerializable(createToJson: false)
class PaymentCardDto {
  const PaymentCardDto({
    required this.bindingId,
    this.maskedPan,
    this.isDefault,
  });

  factory PaymentCardDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentCardDtoFromJson(json);

  final String bindingId;
  final String? maskedPan;
  final bool? isDefault;

  PaymentCard toDomain() => PaymentCard(
    id: bindingId,
    maskedNumber: maskedPan ?? '',
    isDefault: isDefault ?? false,
  );
}
