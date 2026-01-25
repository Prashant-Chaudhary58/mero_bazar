// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser(String phone, String password);
  Future<void> registerUser(UserEntity user, String password);
  Future<UserModel> getCurrentUser(); // ← NEW
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> loginUser(String phone, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'phone': phone, 'password': password},
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(response.data['data']);
      final token = response.data['token']; // Assuming token is here

      if (token != null) {
        await AuthService.saveSession(token, user);
      }

      return user;
    }
    throw Exception(response.data['error'] ?? 'Login failed');
  }

  @override
  Future<void> registerUser(UserEntity user, String password) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'fullName': user.fullName,
        'phone': user.phone,
        'password': password,
        'role': user.role,
      },
    );

    if (response.statusCode != 201) {
      throw Exception(response.data['error'] ?? 'Registration failed');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dio.get('/auth/me');

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    throw Exception('Not authenticated');
  }
}
