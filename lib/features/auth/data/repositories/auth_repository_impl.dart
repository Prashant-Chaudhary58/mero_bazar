import 'package:mero_bazar/features/auth/data/models/user_model.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      return await _localDataSource.loginUser(phone, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final user = UserModel(
        phone: phone,
        fullName: fullName,
        role: role,
        password: password,
        image: role == 'seller' ? "assets/images/farmer.png" : "assets/images/buyer.png",
      );
      await _localDataSource.registerUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
