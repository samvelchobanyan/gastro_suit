import '../../core/locale/content_language.dart';
import '../../core/network/api_client.dart';
import '../../core/network/app_exception.dart';
import '../../domain/entities/branch.dart';
import '../../domain/entities/branch_review.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/branch_repository.dart';
import '../dto/branch_dto.dart';
import '../dto/branch_review_dto.dart';
import '../dto/city_dto.dart';
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

  @override
  Future<Branch> getBranch(
    String branchId, {
    required ContentLanguage language,
  }) async {
    final json = await _api.get('/branches/$branchId');
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return BranchDto.fromJson(json).toDomain(language);
  }

  @override
  Future<List<City>> getCities({
    required String restaurantId,
    required ContentLanguage language,
  }) async {
    final json = await _api.get(
      '/branches/cities',
      query: {'restaurantId': restaurantId},
    );
    return [
      for (final item in jsonObjectList(json))
        CityDto.fromJson(item).toDomain(language),
    ];
  }

  @override
  Future<BranchReview?> getReview(String branchId) async {
    final json = await _api.get('/branches/$branchId/reviews/mine');
    // No rating is a `null` body, which arrives as null or as an empty one.
    if (json == null || json == '') return null;
    return _review(json);
  }

  @override
  Future<BranchReview> rateBranch(
    String branchId, {
    required int rating,
    required String text,
  }) async {
    final json = await _api.post(
      '/branches/$branchId/reviews',
      data: {'rating': rating, 'text': text},
    );
    return _review(json);
  }

  static BranchReview _review(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const AppException(AppExceptionKind.unknown);
    }
    return BranchReviewDto.fromJson(json).toDomain();
  }
}
