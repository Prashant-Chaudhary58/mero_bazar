import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/forgot_password_view_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    final phoneController = TextEditingController(text: vm.phone);
    final otpController = TextEditingController(text: vm.otp);
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  color: Colors.red.shade100,
                  child: Text(
                    vm.error!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              if (vm.step == 1) ...[
                const Text(
                  "Enter your registered phone number to receive a 6-digit OTP.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "98XXXXXXXX",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final success = await vm.sendOtp(
                              phoneController.text,
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("OTP Sent!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                    child: vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Send OTP",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ] else if (vm.step == 2) ...[
                Text(
                  "Enter the OTP sent to ${vm.phone}.",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                const Text(
                  "6-Digit OTP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(
                    letterSpacing: 8,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: "••••••",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final success = await vm.verifyOtp(
                              otpController.text,
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("OTP Verified!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                    child: vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Verify OTP",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => vm.setStep(1),
                    child: const Text(
                      "Change Phone Number",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ] else if (vm.step == 3) ...[
                const Text(
                  "Create a new strong password for your account.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                const Text(
                  "New Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "••••••••",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final success = await vm.resetPassword(
                              passwordController.text,
                            );
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Password Reset Successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Pop all the way back to login and maybe skip to dashboard since token is set
                              // For simplicity, just pop to login for them to re-login, or go directly to app
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            }
                          },
                    child: vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Reset Password & Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
