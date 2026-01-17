import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String fullName,
    required String phone,
    required String password,
    required String role,
  }) {
    return repository.register(fullName: fullName, phone: phone, password: password, role: role);
  }
}
