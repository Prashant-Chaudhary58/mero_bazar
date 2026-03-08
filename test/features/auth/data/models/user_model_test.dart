import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel Extended Unit Tests', () {
    test('fromJson should handle location mapping correctly', () {
      final json = {
        'phone': '9800000000',
        'fullName': 'Test',
        'role': 'buyer',
        'location': {
          'coordinates': [85.123, 27.456],
        },
      };

      final model = UserModel.fromJson(json);
      expect(model.lat, 27.456);
      expect(model.lng, 85.123);
    });

    test('toJson should include all necessary fields', () {
      final model = UserModel(
        phone: '9800000000',
        fullName: 'Test',
        role: 'buyer',
        email: 'test@example.com',
      );

      final json = model.toJson();
      expect(json['email'], 'test@example.com');
      expect(json['phone'], '9800000000');
    });
  });
}
