import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/promo_banner.dart';
import '../../domain/repositories/promo_banner_repository.dart';
import '../dto/json_list.dart';
import '../dto/promo_banner_dto.dart';

class PromoBannerRepositoryImpl implements PromoBannerRepository {
  PromoBannerRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<PromoBanner>> getBanners(ContentLanguage language) async {
    final json = await _api.get('/banners', public: true);
    return [
      for (final item in jsonObjectList(json))
        ?PromoBannerDto.fromJson(item).toDomain(language),
    ];
  }
}
