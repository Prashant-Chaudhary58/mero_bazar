import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserProvider Unit Tests', () {
    late UserProvider userProvider;
    const user = UserEntity(
      id: '1',
      phone: '9800000000',
      fullName: 'Prashant Chaudhary',
      role: 'buyer',
    );

    setUp(() {
      userProvider = UserProvider();
    });

    test('initial state should be logged out', () {
      expect(userProvider.user, isNull);
      expect(userProvider.isLoggedIn, isFalse);
    });

    test('setUser should update user and isLoggedIn', () {
      userProvider.setUser(user);

      expect(userProvider.user, user);
      expect(userProvider.isLoggedIn, isTrue);
      expect(userProvider.isSeller, isFalse);
    });

    test('clearUser should reset state', () {
      userProvider.setUser(user);
      userProvider.clearUser();

      expect(userProvider.user, isNull);
      expect(userProvider.isLoggedIn, isFalse);
    });
  });
}
