import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      return await _remoteDataSource.loginUser(phone, password);
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
        image: role == 'seller'
            ? "assets/images/farmer.png"
            : "assets/images/buyer.png",
      );
      await _remoteDataSource.registerUser(user, password);
      return user; 
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> updateProfile({
    required UserEntity user,
    File? imageFile,
  }) async {
    try {
      return await _remoteDataSource.updateProfile(user, imageFile);
    } catch (e) {
      rethrow;
    }
  }
}
