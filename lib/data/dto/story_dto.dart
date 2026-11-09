import 'package:json_annotation/json_annotation.dart';

import '../../core/locale/content_language.dart';
import '../../domain/entities/story.dart';
import 'app_link_dto.dart';
import 'localized_text.dart';

part 'story_dto.g.dart';

/// `StoryResponse` from `GET /stories`.
@JsonSerializable(createToJson: false)
class StoryDto {
  const StoryDto({
    required this.id,
    this.title,
    this.imageUrl,
    this.slides,
    this.link,
    this.seen,
  });

  factory StoryDto.fromJson(Map<String, dynamic> json) =>
      _$StoryDtoFromJson(json);

  final String id;

  @JsonKey(fromJson: translationsFromJson)
  final Map<String, String>? title;

  final String? imageUrl;
  final List<String>? slides;
  final AppLinkDto? link;

  /// Present only when the request carried a token.
  final bool? seen;

  /// Null for a story with nothing to play: it is left out of the list.
  Story? toDomain(ContentLanguage language) {
    final slides = [...?this.slides].where((s) => s.isNotEmpty).toList();
    if (slides.isEmpty) return null;
    return Story(
      id: id,
      title: localizedOrNull(title, language),
      coverUrl: imageUrl ?? slides.first,
      slides: slides,
      link: link?.toDomain(),
      isSeen: seen ?? false,
    );
  }
}
