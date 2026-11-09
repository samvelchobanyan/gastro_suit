// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDto _$StoryDtoFromJson(Map<String, dynamic> json) => StoryDto(
  id: json['id'] as String,
  title: translationsFromJson(json['title']),
  imageUrl: json['imageUrl'] as String?,
  slides: (json['slides'] as List<dynamic>?)?.map((e) => e as String).toList(),
  link: json['link'] == null
      ? null
      : AppLinkDto.fromJson(json['link'] as Map<String, dynamic>),
  seen: json['seen'] as bool?,
);
