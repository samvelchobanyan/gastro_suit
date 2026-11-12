import '../../core/locale/content_language.dart';
import '../entities/branch.dart';
import '../entities/branch_review.dart';
import '../entities/city.dart';

/// The organisation's branches. Throws only `AppException`.
abstract interface class BranchRepository {
  /// Every active branch of [restaurantId], in the admins' order.
  Future<List<Branch>> getBranches({
    required String restaurantId,
    required ContentLanguage language,
  });

  /// One branch as it is now. Fails with code `location_not_found` when it
  /// no longer exists or is inactive.
  Future<Branch> getBranch(
    String branchId, {
    required ContentLanguage language,
  });

  /// The cities [restaurantId]'s branches stand in, each with its
  /// districts, in the admins' order.
  Future<List<City>> getCities({
    required String restaurantId,
    required ContentLanguage language,
  });

  /// The signed-in user's own rating of [branchId]; null when they have not
  /// rated it.
  Future<BranchReview?> getReview(String branchId);

  /// Rates [branchId] for the signed-in user, replacing their earlier
  /// rating. [rating] is whole stars, 1 to 5; an empty [text] is no words,
  /// and removes the earlier ones. Returns the rating as it now stands.
  Future<BranchReview> rateBranch(
    String branchId, {
    required int rating,
    required String text,
  });
}
