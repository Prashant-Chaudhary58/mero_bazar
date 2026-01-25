// lib/core/api/api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static final Dio dio = Dio();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Set base URL (you can change this anytime)
    dio.options.baseUrl = 'http://172.18.118.197:5001/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    // Setup persistent cookies (this is the magic!)
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