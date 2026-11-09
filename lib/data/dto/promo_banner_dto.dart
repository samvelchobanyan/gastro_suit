import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/promo_banner.dart';
import 'app_link_dto.dart';
import 'localized_text.dart';

part 'promo_banner_dto.g.dart';

/// `BannerResponse` from `GET /banners`. `endsAt` is not read
/// (DESIGN_PRODUCT_QUESTIONS 13).
@JsonSerializable(createToJson: false)
class PromoBannerDto {
  const PromoBannerDto({
    required this.id,
    this.title,
    this.imageUrl,
    this.link,
  });

  factory PromoBannerDto.fromJson(Map<String, dynamic> json) =>
      _$PromoBannerDtoFromJson(json);

  final String id;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? title;

  final String? imageUrl;
  final AppLinkDto? link;

  /// Null for a banner without a picture: it is left out of the list.
  PromoBanner? toDomain(ContentLanguage language) {
    final imageUrl = this.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) return null;
    return PromoBanner(
      id: id,
      imageUrl: imageUrl,
      title: localizedOrNull(title, language),
      link: link?.toDomain(),
    );
  }
}
