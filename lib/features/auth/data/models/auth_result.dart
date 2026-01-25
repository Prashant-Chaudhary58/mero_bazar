import 'package:mero_bazar/features/auth/data/models/user_model.dart';
/// Holds the result of authentication (login/register)
/// Contains both the user data and the JWT token
class AuthResult {
  final UserModel user;
  final String token;
  const AuthResult({
    required this.user,
    required this.token,
  });
}
