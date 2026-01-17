import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String phone,
    required String password,
    required String role,
  }) {
    return repository.login(phone: phone, password: password, role: role);
  }
}
