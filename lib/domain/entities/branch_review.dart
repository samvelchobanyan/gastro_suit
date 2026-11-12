import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_review.freezed.dart';

/// The user's own rating of a branch (DOMAIN_SPEC §3). One per user and
/// branch: rating again replaces it.
@freezed
abstract class BranchReview with _$BranchReview {
  const factory BranchReview({
    /// Whole stars, 1 to 5.
    required int rating,

    /// What the user wrote, read by the merchant only; null when nothing.
    String? text,
  }) = _BranchReview;
}
