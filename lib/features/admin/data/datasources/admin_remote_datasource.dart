import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';
import 'package:mero_bazar/core/services/api_service.dart';

abstract class AdminRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<List<ProductModel>> getAllProducts();
  Future<void> createUser(UserModel user, String password, File? imageFile);
  Future<void> updateUser(
    String id,
    UserModel user,
    File? imageFile, {
    String? password,
  });
  Future<void> deleteUser(String id);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl(this.dio);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('${ApiService.baseUrl}/api/admin/users');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => UserModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load users');
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await dio.get('${ApiService.baseUrl}/api/admin/products');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<void> createUser(
    UserModel user,
    String password,
    File? imageFile,
  ) async {
    final Map<String, dynamic> fields = {
      'fullName': user.fullName,
      'phone': user.phone,
      'password': password,
      'role': user.role,
      'address': user.address,
      'city': user.city,
      'district': user.district,
      'province': user.province,
      // 'email': user.email, // Optional, add if needed
      // 'dob': user.dob,
      // 'altPhone': user.altPhone,
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

    final response = await dio.post(
      '${ApiService.baseUrl}/api/admin/users',
      data: formData,
    );

    if (response.statusCode != 201) {
      throw Exception(response.data['error'] ?? 'Failed to create user');
    }
  }

  @override
  Future<void> updateUser(
    String id,
    UserModel user,
    File? imageFile, {
    String? password,
  }) async {
    final Map<String, dynamic> fields = {
      'fullName': user.fullName,
      'phone': user.phone,
      'role': user.role,
      'address': user.address,
      'city': user.city,
      'district': user.district,
      'province': user.province,
      'email': user.email,
      'dob': user.dob,
      'altPhone': user.altPhone,
    };

    if (password != null && password.isNotEmpty) {
      fields['password'] = password;
    }

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

    final response = await dio.put(
      '${ApiService.baseUrl}/api/admin/users/$id',
      data: formData,
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['error'] ?? 'Failed to update user');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final response = await dio.delete(
      '${ApiService.baseUrl}/api/admin/users/$id',
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['error'] ?? 'Failed to delete user');
    }
  }
}
