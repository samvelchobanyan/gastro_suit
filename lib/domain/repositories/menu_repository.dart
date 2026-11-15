import '../../core/locale/content_language.dart';
import '../entities/menu.dart';
import '../entities/product.dart';

/// Branch menus. Throws only `AppException`.
abstract interface class MenuRepository {
  /// The whole menu of [branchId]: its categories and every product, with
  /// that branch's prices and availability.
  Future<Menu> getMenu({
    required String restaurantId,
    required String branchId,
    required ContentLanguage language,
  });

  /// The products the merchant suggests with [productId], as [branchId]
  /// offers them, in the merchant's order. Empty when there are none.
  Future<List<Product>> getRecommended({
    required String restaurantId,
    required String branchId,
    required String productId,
    required ContentLanguage language,
  });
}
