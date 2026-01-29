import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:mero_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:mero_bazar/features/auth/domain/repositories/auth_repository.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  const user = UserEntity(
    id: '1',
    phone: '9800000000',
    fullName: 'John Doe',
    role: 'buyer',
  );

  group('Auth UseCases Unit Tests', () {
    test('LoginUseCase should call repository.login', () async {
      when(
        () => mockAuthRepository.login(
          phone: '9800000000',
          password: 'password',
          role: 'buyer',
        ),
      ).thenAnswer((_) async => user);

      final result = await loginUseCase(
        phone: '9800000000',
        password: 'password',
        role: 'buyer',
      );

      expect(result, user);
      verify(
        () => mockAuthRepository.login(
          phone: '9800000000',
          password: 'password',
          role: 'buyer',
        ),
      ).called(1);
    });

    test('RegisterUseCase should call repository.register', () async {
      when(
        () => mockAuthRepository.register(
          fullName: 'John Doe',
          phone: '9800000000',
          password: 'password',
          role: 'buyer',
        ),
      ).thenAnswer((_) async => user);

      final result = await registerUseCase(
        fullName: 'John Doe',
        phone: '9800000000',
        password: 'password',
        role: 'buyer',
      );

      expect(result, user);
      verify(
        () => mockAuthRepository.register(
          fullName: 'John Doe',
          phone: '9800000000',
          password: 'password',
          role: 'buyer',
        ),
      ).called(1);
    });
  });
}
