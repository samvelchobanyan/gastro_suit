import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/repositories.dart';
import '../../../domain/entities/branch_review.dart';
import '../../../domain/state/branches_state.dart';

/// The signed-in user's own rating of one branch, for the review sheet:
/// loads the rating they gave earlier (null when none) and sends a new one.
class BranchReviewController extends AsyncNotifier<BranchReview?> {
  BranchReviewController(this.branchId);

  final String branchId;

  @override
  Future<BranchReview?> build() =>
      ref.read(branchRepositoryProvider).getReview(branchId);

  /// Rates the branch, replacing the earlier rating; the branch is then
  /// loaded again in the branch list, for its average to follow. Throws
  /// `AppException` when the rating was not accepted; the earlier one stays
  /// then.
  Future<void> send({required int rating, required String text}) async {
    // Taken before the request: by the time it is answered the sheet may be
    // closed and this controller, with its ref, gone.
    final branches = ref.read(branchesControllerProvider.notifier);
    await ref
        .read(branchRepositoryProvider)
        .rateBranch(branchId, rating: rating, text: text.trim());
    // Not waited for: the rating is accepted, the sheet may close.
    unawaited(branches.refreshBranch(branchId));
  }
}

/// A user's rating by branch id: `branchReviewProvider(branchId)`. Lives
/// while the review sheet is open.
final branchReviewProvider = AsyncNotifierProvider.autoDispose
    .family<BranchReviewController, BranchReview?, String>(
      BranchReviewController.new,
    );
