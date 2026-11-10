import '../../core/locale/content_language.dart';
import '../entities/branch.dart';

/// The organisation's branches. Throws only `AppException`.
abstract interface class BranchRepository {
  /// Every active branch of [restaurantId], in the admins' order.
  Future<List<Branch>> getBranches({
    required String restaurantId,
    required ContentLanguage language,
  });
}
