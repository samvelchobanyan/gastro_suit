import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../dto/branch_dto.dart';
import '../dto/json_list.dart';

class BranchRepositoryImpl implements BranchRepository {
  BranchRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<Branch>> getBranches({
    required String restaurantId,
    required ContentLanguage language,
  }) async {
    final json = await _api.get(
      '/branches',
      query: {'restaurantId': restaurantId},
    );
    return [
      for (final item in jsonObjectList(json))
        BranchDto.fromJson(item).toDomain(language),
    ];
  }
}
