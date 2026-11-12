// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuCategoryDto _$MenuCategoryDtoFromJson(Map<String, dynamic> json) =>
    MenuCategoryDto(
      id: json['id'] as String,
      internalName: json['internalName'] as String?,
      name: translationsFromJson(json['name']),
      imageUrl: json['imageUrl'] as String?,
      parentCategoryId: json['parentCategoryId'] as String?,
    );
