import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user_entity.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase);

  bool isLoading = false;
  bool obscurePassword = true;
  UserEntity? user;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> login(String phone, String password) async {
    isLoading = true;
    notifyListeners();

    user = await loginUseCase(phone: phone, password: password);

    isLoading = false;
    notifyListeners();
  }
}
