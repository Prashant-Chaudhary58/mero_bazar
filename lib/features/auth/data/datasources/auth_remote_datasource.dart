import 'package:dio/dio.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginUser(String phone, String password);
  Future<void> registerUser(UserEntity user, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  // Use 10.0.2.2 for Android Emulator to access localhost of the host machine.
  // Use http://localhost:5000 for iOS Simulator or Web.
  // static const String baseUrl = 'http://10.59.167.197:5000/api/v1';
  static const String baseUrl = 'http://172.18.118.197:5001/api/v1';

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> loginUser(String phone, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = response.data['token'];
        // Ideally save token here or in repository
        return UserModel.fromJson(data);
      } else {
        throw Exception(response.data['error'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Login failed: ${e.message}',
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/register',
        data: {
          'fullName': user.fullName,
          'phone': user.phone,
          'password': password,
          'role': user.role,
        },
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.data['error'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Registration failed: ${e.message}',
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
