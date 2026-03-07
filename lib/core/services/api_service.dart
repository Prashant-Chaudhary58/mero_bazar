// lib/core/api/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mero_bazar/core/utils/storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.83.246.197:5001';
  static final Dio dio = Dio();
  static bool _isInitialized = false;

  static String getImageUrl(String? imageName, String roleOrType) {
    if (imageName == null || imageName == 'no-photo.jpg') {
      return ""; // Handle fallback in UI
    }

    // Check if it's a product image
    if (roleOrType == 'products' || roleOrType == 'product') {
      return '$baseUrl/uploads/products/$imageName';
    }

    // Default to users folder for profile images
    return '$baseUrl/uploads/users/$imageName';
  }

  static String getProductImageUrl(String imageName) {
    return getImageUrl(imageName, 'products');
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Set base URL
    dio.options.baseUrl = '$baseUrl/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    // Setup persistent cookies
    final dir = await getApplicationDocumentsDirectory();
    final cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${dir.path}/.cookies/"),
    );

    dio.interceptors.add(CookieManager(cookieJar));

    // Add Bearer Token Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    // auto logout on 401
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Future: trigger logout globally
            print("Session expired - should logout");
          }
          handler.next(error);
        },
      ),
    );

    _isInitialized = true;
  }
}
