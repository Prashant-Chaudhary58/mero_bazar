import 'dart:io';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:mero_bazar/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<UserEntity>> getUsers() async {
    final users = await remoteDataSource.getUsers();
    return users.cast<UserEntity>();
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final products = await remoteDataSource.getAllProducts();
    return products.cast<ProductEntity>();
  }

  @override
  Future<void> createUser(
    UserEntity user,
    String password,
    File? imageFile,
  ) async {
    final userModel = UserModel(
      fullName: user.fullName,
      phone: user.phone,
      role: user.role,
      address: user.address,
      city: user.city,
      district: user.district,
      province: user.province,
      email: user.email,
      id: user.id,
      image: user.image,
      dob: user.dob,
      altPhone: user.altPhone,
      lat: user.lat,
      lng: user.lng,
      isAdmin: user.isAdmin,
    );
    return await remoteDataSource.createUser(userModel, password, imageFile);
  }

  @override
  Future<void> updateUser(
    String id,
    UserEntity user,
    File? imageFile, {
    String? password,
  }) async {
    final userModel = UserModel(
      fullName: user.fullName,
      phone: user.phone,
      role: user.role,
      address: user.address,
      city: user.city,
      district: user.district,
      province: user.province,
      email: user.email,
      id: user.id,
      image: user.image,
      dob: user.dob,
      altPhone: user.altPhone,
      lat: user.lat,
      lng: user.lng,
      isAdmin: user.isAdmin,
    );
    return await remoteDataSource.updateUser(
      id,
      userModel,
      imageFile,
      password: password,
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    return await remoteDataSource.deleteUser(id);
  }
}
