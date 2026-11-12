import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/branch_review.dart';

part 'branch_review_dto.g.dart';

/// `ReviewResponse` from `GET /branches/{id}/reviews/mine` and
/// `POST /branches/{id}/reviews`. Only what the app uses is read.
@JsonSerializable(createToJson: false)
class BranchReviewDto {
  const BranchReviewDto({required this.rating, this.text});

  factory BranchReviewDto.fromJson(Map<String, dynamic> json) =>
      _$BranchReviewDtoFromJson(json);

  final num rating;
  final String? text;

  BranchReview toDomain() {
    final text = this.text?.trim();
    return BranchReview(
      rating: rating.round(),
      text: text == null || text.isEmpty ? null : text,
    );
  }
}
