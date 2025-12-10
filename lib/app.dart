import 'package:flutter/material.dart';
import 'package:mero_bazar/screens/auth/login_screen.dart';
import 'package:mero_bazar/screens/auth/role_selection_screen.dart';
import 'package:mero_bazar/screens/auth/signup_screen.dart';
import 'package:mero_bazar/screens/home/home_screen.dart';
import 'package:mero_bazar/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mero Baazar",
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
