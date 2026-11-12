import 'package:flutter_test/flutter_test.dart';
import 'package:gastro_suit/data/dto/branch_review_dto.dart';
import 'package:gastro_suit/domain/entities/branch_review.dart';

void main() {
  group('BranchReviewDto', () {
    test('maps the stars and the words', () {
      final review = BranchReviewDto.fromJson({
        'locationId': 'b1',
        'rating': 4,
        'text': 'Great coffee',
        'updatedAt': '2026-11-13T10:00:00.000Z',
      }).toDomain();
      expect(review, const BranchReview(rating: 4, text: 'Great coffee'));
    });

    test('no words, or blank ones, are no text', () {
      expect(
        BranchReviewDto.fromJson({'rating': 5, 'text': null}).toDomain().text,
        isNull,
      );
      expect(
        BranchReviewDto.fromJson({'rating': 5, 'text': '  '}).toDomain().text,
        isNull,
      );
    });
  });
}
