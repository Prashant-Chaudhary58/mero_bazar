import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/core/services/api_service.dart';

void main() {
  group('ApiService Unit Tests', () {
    test('getImageUrl should return correct URL for buyer profile', () {
      final url = ApiService.getImageUrl('test.jpg', 'buyer');
      expect(url, contains('uploads/users/test.jpg'));
    });

    test('getImageUrl should return correct URL for products', () {
      final url = ApiService.getImageUrl('test.jpg', 'products');
      expect(url, contains('uploads/products/test.jpg'));
    });

    test('getImageUrl should return empty string if image is null', () {
      final url = ApiService.getImageUrl(null, 'buyer');
      expect(url, equals(""));
    });
  });
}
