import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mero_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:mero_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:mero_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:mero_bazar/features/auth/presentation/pages/role_selection_screen.dart';
import 'package:mero_bazar/features/auth/presentation/pages/signup_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/login_view_model.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/dashboard_view.dart';
import 'package:mero_bazar/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:mero_bazar/theme/theme_data.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        // Global State
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // Repositories
        Provider(create: (_) => AuthRepositoryImpl()),
        
        // UseCases
        ProxyProvider<AuthRepositoryImpl, LoginUseCase>(
          update: (_, repo, __) => LoginUseCase(repo),
        ),
        ProxyProvider<AuthRepositoryImpl, RegisterUseCase>(
          update: (_, repo, __) => RegisterUseCase(repo),
        ),

        // ViewModels
        ChangeNotifierProxyProvider2<LoginUseCase, UserProvider, LoginViewModel>(
          create: (context) => LoginViewModel(
            context.read<LoginUseCase>(),
            context.read<UserProvider>(),
          ),
          update: (_, useCase, userProvider, __) => LoginViewModel(useCase, userProvider),
        ),
        ChangeNotifierProxyProvider2<RegisterUseCase, UserProvider, SignupViewModel>(
          create: (context) => SignupViewModel(
            context.read<RegisterUseCase>(),
            context.read<UserProvider>(),
          ),
          update: (_, useCase, userProvider, __) => SignupViewModel(useCase, userProvider),
        ),
      ],
      child: MaterialApp(
        title: "Mero Baazar",
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const RoleSelectionScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/bottomnav': (context) => const DashboardView(),
          '/edit-profile': (context) => const EditProfileScreen(),
        },
      ),
    );
  }
}
