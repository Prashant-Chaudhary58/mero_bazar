import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/auth/data/datasources/auth_remote_datasource.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
    registerFallbackValue(
      UserModel(fullName: '', phone: '', role: '', password: ''),
    );
  });

  group('AuthRepositoryImpl Unit Tests', () {
    test('should login successfully', () async {
      final user = UserModel(
        id: '1',
        fullName: 'John',
        phone: '123',
        role: 'buyer',
      );
      when(
        () => mockRemoteDataSource.loginUser(any(), any()),
      ).thenAnswer((_) async => user);

      final result = await repository.login(
        phone: '123',
        password: 'pass',
        role: 'buyer',
      );

      expect(result, user);
      verify(() => mockRemoteDataSource.loginUser('123', 'pass')).called(1);
    });
  });
}
