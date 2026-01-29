import 'dart:io';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String phone,
    required String password,
    required String role,
  });

  Future<UserEntity> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
  });

  Future<UserEntity> updateProfile({required UserEntity user, File? imageFile});
}
