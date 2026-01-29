
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  // Token methods
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: _tokenKey, value: token);
  }
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
    return await _storage.read(key: _tokenKey);
  }
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: _tokenKey);
  }
  // User data methods
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userKey, value: jsonEncode(userData));
  }
  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _userKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }
  static Future<void> deleteUserData() async {
    await _storage.delete(key: _userKey);
  }
  // Combined session methods
  static Future<void> saveSession(String token, Map<String, dynamic> userData) async {
    await saveToken(token);
    await saveUserData(userData);
  }
  static Future<void> clearSession() async {
    await deleteToken();
    await deleteUserData();
  }
  static Future<bool> hasSession() async {
    final token = await getToken();
    final userData = await getUserData();
    return token != null && userData != null;
  }
}