import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity Unit Tests', () {
    test('should hold correct property values', () {
      final review = ReviewEntity(
        id: 'rev1',
        title: 'Great',
        rating: 5.0,
        text: 'Excellent product',
        userName: 'John',
        userId: 'user1',
      );

      expect(review.id, 'rev1');
      expect(review.title, 'Great');
      expect(review.rating, 5.0);
      expect(review.text, 'Excellent product');
      expect(review.userName, 'John');
    });
  });
}
