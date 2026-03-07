import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final Dio dio;

  ForgotPasswordViewModel(this.dio);

  bool isLoading = false;
  String? error;

  int step = 1; // 1: Phone, 2: OTP, 3: New Password
  String phone = '';
  String otp = '';
  String resetToken = '';

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setStep(int newStep) {
    step = newStep;
    notifyListeners();
  }

  Future<bool> sendOtp(String phoneNumber) async {
    setLoading(true);
    error = null;
    phone = phoneNumber;

    try {
      final response = await dio.post('/auth/send-otp', data: {'phone': phone});

      if (response.statusCode == 200 && response.data['success'] == true) {
        step = 2;
        setLoading(false);
        return true;
      } else {
        error = "Failed to send OTP.";
      }
    } on DioException catch (e) {
      error = e.response?.data['error'] ?? "Network error.";
    } catch (e) {
      error = "Something went wrong.";
    }

    setLoading(false);
    return false;
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    setLoading(true);
    error = null;
    otp = enteredOtp;

    try {
      final response = await dio.post(
        '/auth/verify-otp-reset',
        data: {'phone': phone, 'otp': otp},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        resetToken = response.data['data']['resetToken'];
        step = 3;
        setLoading(false);
        return true;
      } else {
        error = response.data['error'] ?? "Invalid OTP.";
      }
    } on DioException catch (e) {
      error = e.response?.data['error'] ?? "Invalid OTP or Network Error.";
    } catch (e) {
      error = "Something went wrong.";
    }

    setLoading(false);
    return false;
  }

  Future<bool> resetPassword(String newPassword) async {
    setLoading(true);
    error = null;

    try {
      final response = await dio.put(
        '/auth/reset-password',
        data: {'resetToken': resetToken, 'password': newPassword},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Successfully reset password and auto-logged in (cookie received)
        setLoading(false);
        return true;
      } else {
        error = response.data['error'] ?? "Failed to reset password.";
      }
    } on DioException catch (e) {
      error = e.response?.data['error'] ?? "Network error.";
    } catch (e) {
      error = "Something went wrong.";
    }

    setLoading(false);
    return false;
  }
}
