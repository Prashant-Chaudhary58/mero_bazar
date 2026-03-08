import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';

void main() {
  group('ProductEntity Unit Tests', () {
    test('should hold correct property values', () {
      final p1 = ProductEntity(
        id: '1',
        name: 'Test',
        price: 100,
        image: 'img.jpg',
        category: 'cat',
        description: 'desc',
        quantity: '1',
      );

      expect(p1.id, '1');
      expect(p1.name, 'Test');
      expect(p1.price, 100);
      expect(p1.image, 'img.jpg');
    });
  });
}
