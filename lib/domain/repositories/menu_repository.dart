import '../../core/locale/content_language.dart';
import '../entities/menu.dart';

/// Branch menus. Throws only `AppException`.
abstract interface class MenuRepository {
  /// The whole menu of [branchId]: its categories and every product, with
  /// that branch's prices and availability.
  Future<Menu> getMenu({
    required String restaurantId,
    required String branchId,
    required ContentLanguage language,
  });
}
