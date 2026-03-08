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
    });

    test('should maintain existing values if copyWith fields are null', () {
      final updatedUser = user.copyWith();

      expect(updatedUser.fullName, user.fullName);
      expect(updatedUser.phone, user.phone);
    });

    test('should handle nullable field resets in copyWith (if applicable)', () {
      final updatedUser = user.copyWith(email: null);
      // In UserEntity, if email is null in copyWith, it keeps the old one.
      expect(updatedUser.email, user.email);
    });

    test('should support value equality', () {
      const user2 = UserEntity(
        id: '1',
        phone: '9800000000',
        fullName: 'Prashant Chaudhary',
        role: 'buyer',
        email: 'john@example.com',
      );
      expect(user, user2);
    });
  });
}
