import '../../core/locale/content_language.dart';
import '../entities/promo_banner.dart';

/// Home's promo banners. Throws only `AppException`.
abstract interface class PromoBannerRepository {
  /// The banners on show now, in the server's order.
  Future<List<PromoBanner>> getBanners(ContentLanguage language);
}
