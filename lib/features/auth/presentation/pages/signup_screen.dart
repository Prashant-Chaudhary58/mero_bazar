import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/signup_view_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You might need to provide the ViewModel higher up or here if strict DI isn't setup.
    // For now, assume it's provided.
    final vm = context.watch<SignupViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),

              Center(
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/logo.jpg"),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              const Text("Full Name", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  hintText: "Enter your full Name",
                ),
              ),

              const SizedBox(height: 16),
              const Text("Phone No", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Enter your Phone No",
                ),
              ),

              const SizedBox(height: 16),
              const Text("Password", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: vm.obscurePassword,
                decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: vm.togglePasswordVisibility,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text("Confirm Password", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: confirmPasswordController,
                obscureText: vm.obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Enter your confirm password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: vm.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: vm.isAccepted,
                    activeColor: Colors.green,
                    onChanged: vm.toggleTermsAcceptance,
                  ),
                  const Expanded(
                    child: Text(
                      "I accept all the terms and conditions.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final role =
                              ModalRoute.of(context)?.settings.arguments
                                  as String? ??
                              'buyer';
                          final error = await vm.register(
                            fullNameController.text,
                            phoneController.text,
                            passwordController.text,
                            role,
                          );

                          if (context.mounted) {
                            if (error == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Registration Successful! Please Login.",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pushReplacementNamed(
                                context,
                                '/login',
                                arguments: role,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?  "),
                    GestureDetector(
                      onTap: () {
                        final role =
                            ModalRoute.of(context)?.settings.arguments
                                as String? ??
                            'buyer';
                        Navigator.pushNamed(context, '/login', arguments: role);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
