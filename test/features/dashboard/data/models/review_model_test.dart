import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/data/models/review_model.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/review_entity.dart';

void main() {
  group('ReviewModel Unit Tests', () {
    test('should return a valid model from JSON', () {
      final json = {
        '_id': 'rev1',
        'title': 'Good',
        'rating': 4.5,
        'text': 'Nice product',
        'userName': 'User',
        'userId': 'u1',
      };

      final model = ReviewModel.fromJson(json);

      expect(model.id, 'rev1');
      expect(model.rating, 4.5);
      expect(model.title, 'Good');
    });

    test('should return a JSON map containing proper data', () {
      final model = ReviewModel(
        id: 'rev1',
        title: 'Good',
        rating: 4.5,
        text: 'Nice',
        userName: 'User',
        userId: 'u1',
      );

      final json = model.toJson();

      expect(json['title'], 'Good');
      expect(json['rating'], 4.5);
    });

    test('should be a subclass of ReviewEntity', () {
      final model = ReviewModel(title: 'T', rating: 1.0, text: 'Txt');
      expect(model, isA<ReviewEntity>());
    });
  });
}
