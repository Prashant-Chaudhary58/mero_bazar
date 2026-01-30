import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity Unit Tests', () {
    const user = UserEntity(
      id: '1',
      phone: '9800000000',
      fullName: 'Prashant Chaudhary',
      role: 'buyer',
      email: 'john@example.com',
    );

    test('should return a copy with updated fields using copyWith', () {
      final updatedUser = user.copyWith(
        fullName: 'John Smith',
        city: 'Kathmandu',
      );

      expect(updatedUser.fullName, 'John Smith');
      expect(updatedUser.city, 'Kathmandu');
      expect(updatedUser.phone, '9800000000');
      expect(updatedUser.id, '1');
      expect(updatedUser.email, 'john@example.com');
    });

    test('should maintain existing values if copyWith fields are null', () {
      final updatedUser = user.copyWith();

      expect(updatedUser.fullName, user.fullName);
      expect(updatedUser.phone, user.phone);
      expect(updatedUser.email, user.email);
    });
  });
}
