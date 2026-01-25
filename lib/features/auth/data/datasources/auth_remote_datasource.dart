// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import 'dart:io';
import 'package:mero_bazar/core/utils/storage.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser(String phone, String password);
  Future<void> registerUser(UserEntity user, String password);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(UserEntity user, File? imageFile);
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
      final token = response.data['token']; 

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

  @override
  Future<UserModel> updateProfile(UserEntity user, File? imageFile) async {
    final Map<String, dynamic> fields = {
      'fullName': user.fullName,
      'email': user.email ?? '',
      'dob': user.dob ?? '',
      'province': user.province ?? '',
      'district': user.district ?? '',
      'city': user.city ?? '',
      'address': user.address ?? '',
      'altPhone': user.altPhone ?? '',
    };

    FormData formData = FormData.fromMap(fields);

    if (imageFile != null) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ),
      );
    }

    // Assuming endpoint is /users/update-profile/:id or similar
    // Using /users/update/${user.id} as a safe bet for now
    final response = await dio.put('/users/update/${user.id}', data: formData);

    if (response.statusCode == 200) {
      final updatedUser = UserModel.fromJson(response.data['data']);

      // Update local session
      // We need the token. Stored token should be valid.
      // We don't have token here easily unless we read it or pass it.
      // But we can just save the user part of the session if we could.
      // AuthService.saveSession requires token.
      // Ideally we read the existing token first.

      // For now, let's assume UI updates the provider.
      // But for persistence across restarts, we should update session in secure storage.
      // Let's try to get token from existing session.
      // Wait, tryAutoLogin returns UserModel, no token exposed there.
      // We might need to fetch token from SecureStorage directly.
      final token = await SecureStorage.getToken();
      if (token != null) {
        await AuthService.saveSession(token, updatedUser);
      }

      return updatedUser;
    }
    throw Exception(response.data['error'] ?? 'Update failed');
  }
}
