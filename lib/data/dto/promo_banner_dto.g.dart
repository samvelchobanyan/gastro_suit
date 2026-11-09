// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_banner_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoBannerDto _$PromoBannerDtoFromJson(Map<String, dynamic> json) =>
    PromoBannerDto(
      id: json['id'] as String,
      title: translationsFromJson(json['title']),
      imageUrl: json['imageUrl'] as String?,
      link: json['link'] == null
          ? null
          : AppLinkDto.fromJson(json['link'] as Map<String, dynamic>),
    );
