// lib/core/api/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
class ApiService {
  static const String baseUrl = 'http://172.30.111.197:5001';
  static final Dio dio = Dio();
  static bool _isInitialized = false;
  
  static String getImageUrl(String? imageName, String roleOrType) {
    if (imageName == null || imageName == 'no-photo.jpg') {
      return ""; // Handle fallback in UI
    }
    String folder;
    if (roleOrType == 'seller') {
      folder = 'farmer';
    } else if (roleOrType == 'buyer') {
      folder = 'buyer';
    } else if (roleOrType == 'products' || roleOrType == 'product') {
      folder = 'products';
    } else {
      folder = 'others';
    }
    return '$baseUrl/uploads/$folder/$imageName';
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

    // auto logout on 401
    dio.interceptors.add(
      InterceptorsWrapper(onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Future: trigger logout globally
          print("Session expired - should logout");
        }
        handler.next(error);
      }),
    );

    _isInitialized = true;
  }
}