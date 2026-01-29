import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';

void main() {
  group('ProductModel Unit Tests', () {
    final json = {
      '_id': '1',
      'name': 'Test Product',
      'description': 'Test Description',
      'price': 100,
      'category': 'Test',
      'quantity': 10,
      'image': 'test.png',
      'seller': 'seller1',
    };

    test('should return a valid model from JSON', () {
      final model = ProductModel.fromJson(json);

      expect(model.id, '1');
      expect(model.name, 'Test Product');
      expect(model.quantity, '10');
    });

    test('should return a JSON map from model', () {
      final model = ProductModel(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 100,
        category: 'Test',
        quantity: '10',
        image: 'test.png',
      );

      final result = model.toJson();

      expect(result['name'], 'Test Product');
      expect(result['quantity'], '10');
    });
  });
}
