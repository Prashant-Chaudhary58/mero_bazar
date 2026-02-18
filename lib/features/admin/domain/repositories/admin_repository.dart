import 'dart:io';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';

abstract class AdminRepository {
  Future<List<UserEntity>> getUsers();
  Future<List<ProductEntity>> getAllProducts();
  Future<void> createUser(UserEntity user, String password, File? imageFile);
  Future<void> updateUser(
    String id,
    UserEntity user,
    File? imageFile, {
    String? password,
  });
  Future<void> deleteUser(String id);
}
