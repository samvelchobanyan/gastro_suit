import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/buy_again.dart';
import 'localized_text.dart';

part 'buy_again_dto.g.dart';

/// `BuyAgainResponse`: a dish as it was ordered, at the branch it was
/// ordered from. Only what the app uses is read: the chosen options stay
/// with the server, which adds the entry to the cart by [againId].
@JsonSerializable(createToJson: false)
class BuyAgainDto {
  const BuyAgainDto({
    required this.againId,
    required this.item,
    required this.branch,
    this.available,
  });

  factory BuyAgainDto.fromJson(Map<String, dynamic> json) =>
      _$BuyAgainDtoFromJson(json);

  final String againId;
  final BuyAgainNamedDto item;
  final BuyAgainNamedDto branch;
  final bool? available;

  BuyAgainItem toDomain(ContentLanguage language) {
    final imageUrl = item.imageUrl;
    return BuyAgainItem(
      id: againId,
      name: localized(item.name, language, internalName: item.internalName),
      imageUrl: imageUrl == null || imageUrl.isEmpty ? null : imageUrl,
      branchId: branch.id,
      branchName: localized(
        branch.name,
        language,
        internalName: branch.internalName,
      ),
      isAvailable: available ?? true,
    );
  }
}

/// The dish or the branch of a buy-again entry: its id and name, and the
/// dish's picture.
@JsonSerializable(createToJson: false)
class BuyAgainNamedDto {
  const BuyAgainNamedDto({
    required this.id,
    this.internalName,
    this.name,
    this.imageUrl,
  });

  factory BuyAgainNamedDto.fromJson(Map<String, dynamic> json) =>
      _$BuyAgainNamedDtoFromJson(json);

  final String id;
  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;
  final String? imageUrl;
}
