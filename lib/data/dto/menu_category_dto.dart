import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/menu_category.dart';
import 'localized_text.dart';

part 'menu_category_dto.g.dart';

/// `CategoryResponse` from `GET /menu/categories`.
@JsonSerializable(createToJson: false)
class MenuCategoryDto {
  const MenuCategoryDto({
    required this.id,
    this.internalName,
    this.name,
    this.imageUrl,
    this.parentCategoryId,
  });

  factory MenuCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryDtoFromJson(json);

  final String id;
  final String? internalName;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? name;

  final String? imageUrl;
  final String? parentCategoryId;

  MenuCategory toDomain(ContentLanguage language) => MenuCategory(
    id: id,
    name: localized(name, language, internalName: internalName),
    imageUrl: imageUrl == null || imageUrl!.isEmpty ? null : imageUrl,
    parentId: parentCategoryId,
  );
}
