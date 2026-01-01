import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
  }) async {
    // 🔹 TEMP: simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(phone: phone);
  }
}
