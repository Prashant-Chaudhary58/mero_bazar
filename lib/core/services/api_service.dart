import 'package:dio/dio.dart';
import 'package:mero_bazar/core/utils/storage.dart';


final dio = Dio(BaseOptions(
  baseUrl: 'http://172.18.118.197:5001/api/v1', // change to your actual URL
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
)); // BaseOptions // Dio

void setupInterceptors() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      // Optional: If token is invalid/expired (401), logout automatically
      if (error.response?.statusCode == 401) {
        await SecureStorage.deleteToken();
        // You can add navigation to login screen here if needed
      }
      handler.next(error);
    },
  ));
}