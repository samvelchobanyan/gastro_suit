import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/core/locale/content_language.dart';
import 'package:gastro_suit/data/dto/app_link_dto.dart';
import 'package:gastro_suit/data/dto/promo_banner_dto.dart';
import 'package:gastro_suit/data/dto/story_dto.dart';
import 'package:gastro_suit/domain/entities/app_link.dart';

void main() {
  const ru = ContentLanguage(current: 'ru', fallback: 'en');

  group('AppLinkDto', () {
    test('maps the API types', () {
      expect(
        const AppLinkDto(type: 'item', target: 'p1').toDomain(),
        const AppLink(type: AppLinkType.product, target: 'p1'),
      );
      expect(
        const AppLinkDto(type: 'category', target: 'c1').toDomain()?.type,
        AppLinkType.category,
      );
    });

    test('an unknown type or an empty target leads nowhere', () {
      expect(const AppLinkDto(type: 'video', target: 'x').toDomain(), isNull);
      expect(const AppLinkDto(type: 'url', target: '').toDomain(), isNull);
    });
  });

  group('StoryDto', () {
    final json = {
      'id': 's1',
      'title': {'en': 'Cold brew', 'ru': 'Колд брю'},
      'imageUrl': 'http://x/cover.png',
      'slides': ['http://x/1.png', 'http://x/2.png'],
      'link': null,
      'seen': true,
    };

    test('maps a story in the current language', () {
      final story = StoryDto.fromJson(json).toDomain(ru)!;
      expect(story.title, 'Колд брю');
      expect(story.coverUrl, 'http://x/cover.png');
      expect(story.slides, hasLength(2));
      expect(story.isSeen, isTrue);
      expect(story.link, isNull);
    });

    test('a guest response has no seen flag: every story is new', () {
      final story = StoryDto.fromJson({...json}..remove('seen')).toDomain(ru)!;
      expect(story.isSeen, isFalse);
    });

    test('a story with no slides is left out', () {
      expect(StoryDto.fromJson({...json, 'slides': []}).toDomain(ru), isNull);
    });
  });

  group('PromoBannerDto', () {
    test('maps a banner with a link', () {
      final banner = PromoBannerDto.fromJson({
        'id': 'b1',
        'title': {'en': 'Combos'},
        'imageUrl': 'http://x/b.png',
        'link': {'type': 'url', 'target': 'https://example.com'},
        'endsAt': null,
      }).toDomain(ru)!;
      expect(banner.title, 'Combos');
      expect(banner.link?.type, AppLinkType.url);
    });

    test('a banner without a picture is left out', () {
      expect(PromoBannerDto.fromJson({'id': 'b1'}).toDomain(ru), isNull);
    });
  });
}
