import 'package:mero_bazar/core/utils/storage.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';

/// AuthService handles session persistence and restoration.
/// It reads/writes to SecureStorage but does NOT make API calls.
class AuthService {
  /// Attempts to restore a previously saved session.
  /// Returns UserModel if session exists, null otherwise.
  static Future<UserModel?> tryAutoLogin() async {
    try {
      final hasSession = await SecureStorage.hasSession();
      if (!hasSession) return null;

      final userData = await SecureStorage.getUserData();
      if (userData == null) return null;

      // Recreate user from stored data
      return UserModel.fromJson(userData);
    } catch (e) {
      await SecureStorage.clearSession();
      return null;
    }
  }

  /// Saves session after successful login/signup
  static Future<void> saveSession(String token, UserModel user) async {
    await SecureStorage.saveSession(token, user.toJson());
  }

  /// Clears session on logout
  static Future<void> clearSession() async {
    await SecureStorage.clearSession();
  }

  /// Check if user has an active session
  static Future<bool> isLoggedIn() async {
    return await SecureStorage.hasSession();
  }
}
