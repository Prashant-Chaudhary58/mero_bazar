import 'package:flutter/material.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

class SignupViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final UserProvider userProvider;

  SignupViewModel(this.registerUseCase, this.userProvider);

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isAccepted = false;
  UserEntity? user;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  void toggleTermsAcceptance(bool? value) {
    isAccepted = value ?? false;
    notifyListeners();
  }

  Future<String?> register(
    String fullName,
    String phone,
    String password,
    String role,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      user = await registerUseCase(
        fullName: fullName,
        phone: phone,
        password: password,
        role: role,
      );
      if (user != null) {
        userProvider.setUser(
          user!,
        ); // Optional: Auto-login after signup? User requirement says navigate to login.
        // But for consistency with plan: "Success -> Login Screen"
        isLoading = false;
        notifyListeners();
        return null; // Success
      } else {
        isLoading = false;
        notifyListeners();
        return "Registration failed";
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
