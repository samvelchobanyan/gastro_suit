import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/menu.dart';
import '../../domain/repositories/menu_repository.dart';
import '../dto/json_list.dart';
import '../dto/menu_category_dto.dart';
import '../dto/product_dto.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Menu> getMenu({
    required String restaurantId,
    required String branchId,
    required ContentLanguage language,
  }) async {
    final query = {'restaurantId': restaurantId, 'branchId': branchId};
    // Both at once; the first failure is the one thrown.
    final [categories, items] = await Future.wait([
      _api.get('/menu/categories', query: query),
      _api.get('/menu/items', query: query),
    ]);
    return Menu(
      branchId: branchId,
      categories: [
        for (final json in jsonObjectList(categories))
          MenuCategoryDto.fromJson(json).toDomain(language),
      ],
      products: [
        for (final json in jsonObjectList(items))
          ProductDto.fromJson(json).toDomain(language),
      ],
    );
  }
}
