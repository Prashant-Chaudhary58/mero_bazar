import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    // 🔹 TEMP: simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserEntity(
      phone: phone,
      fullName: "Mr $role", // Mock name
      role: role,
      image: role == 'seller' ? "assets/images/farmer.png" : "assets/images/buyer.png",
    );
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
  }) async {
    // 🔹 TEMP: simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return UserEntity(
      phone: phone,
      fullName: fullName,
      role: role,
      image: role == 'seller' ? "assets/images/farmer.png" : "assets/images/buyer.png",
    );
  }
}
