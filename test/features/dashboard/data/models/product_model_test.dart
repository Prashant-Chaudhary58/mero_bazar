import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';

void main() {
  group('ProductModel Extended Unit Tests', () {
    test('toJson should return correct map', () {
      final model = ProductModel(
        id: '1',
        name: 'Test',
        price: 100,
        image: 'img.jpg',
        category: 'cat',
        description: 'desc',
        quantity: '1',
      );

      final json = model.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test');
      expect(json['price'], 100);
    });

    test('should support copyWith', () {
      final model = ProductModel(
        id: '1',
        name: 'Test',
        price: 100,
        image: 'img.jpg',
        category: 'cat',
        description: 'desc',
        quantity: '1',
      );

      final updated = model.copyWith(name: 'New Name');
      expect(updated.name, 'New Name');
      expect(updated.price, 100);
    });
  });
}
