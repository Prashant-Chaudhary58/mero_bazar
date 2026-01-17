import 'package:flutter/material.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final UserProvider userProvider;

  LoginViewModel(this.loginUseCase, this.userProvider);

  bool isLoading = false;
  bool obscurePassword = true;
  UserEntity? user;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<String?> login(String phone, String password, String role) async {
    isLoading = true;
    notifyListeners();

    try {
      user = await loginUseCase(phone: phone, password: password, role: role);
      if (user != null) {
        userProvider.setUser(user!);
        isLoading = false;
        notifyListeners();
        return null; // Success
      } else {
        isLoading = false;
        notifyListeners();
        return "Login failed";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
