import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mero_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:mero_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:mero_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:mero_bazar/features/auth/presentation/pages/role_selection_screen.dart';
import 'package:mero_bazar/features/auth/presentation/pages/signup_screen.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/login_view_model.dart';
import 'package:mero_bazar/features/auth/presentation/view_model/signup_view_model.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/dashboard_view.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/product_details_screen.dart';
import 'package:mero_bazar/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:mero_bazar/features/profile/presentation/pages/my_listings_screen.dart';
import 'package:mero_bazar/features/dashboard/data/datasources/product_remote_datasource.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/theme/theme_data.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/admin_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/admin/admin_dashboard_screen.dart';
import 'package:mero_bazar/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:mero_bazar/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:mero_bazar/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mero_bazar/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mero_bazar/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:mero_bazar/features/chat/presentation/pages/chat_screen.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';

class MyApp extends StatelessWidget {
  final UserModel? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global State
        ChangeNotifierProvider(
          create: (_) => UserProvider(initialUser: initialUser),
        ),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),

        // External
        Provider<Dio>.value(value: ApiService.dio),

        // Data Sources
        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(context.read<Dio>()),
        ),
        Provider<ProductRemoteDataSource>(
          create: (context) => ProductRemoteDataSourceImpl(context.read<Dio>()),
        ),
        Provider<AdminRemoteDataSource>(
          create: (context) => AdminRemoteDataSourceImpl(context.read<Dio>()),
        ),
        Provider<ChatRemoteDataSource>(
          create: (context) => ChatRemoteDataSourceImpl(context.read<Dio>()),
        ),

        // Repositories
        ProxyProvider<AuthRemoteDataSource, AuthRepositoryImpl>(
          update: (_, dataSource, __) => AuthRepositoryImpl(dataSource),
        ),
        ProxyProvider<ProductRemoteDataSource, ProductRepositoryImpl>(
          update: (_, dataSource, __) => ProductRepositoryImpl(dataSource),
        ),
        ProxyProvider<AdminRemoteDataSource, AdminRepositoryImpl>(
          update: (_, dataSource, __) => AdminRepositoryImpl(dataSource),
        ),
        ProxyProvider<ChatRemoteDataSource, ChatRepositoryImpl>(
          update: (_, dataSource, __) => ChatRepositoryImpl(dataSource),
        ),

        // UseCases
        ProxyProvider<AuthRepositoryImpl, LoginUseCase>(
          update: (_, repo, __) => LoginUseCase(repo),
        ),
        ProxyProvider<AuthRepositoryImpl, RegisterUseCase>(
          update: (_, repo, __) => RegisterUseCase(repo),
        ),

        // ViewModels
        ChangeNotifierProxyProvider2<
          LoginUseCase,
          UserProvider,
          LoginViewModel
        >(
          create: (context) => LoginViewModel(
            context.read<LoginUseCase>(),
            context.read<UserProvider>(),
          ),
          update: (_, useCase, userProvider, __) =>
              LoginViewModel(useCase, userProvider),
        ),
        ChangeNotifierProxyProvider2<
          RegisterUseCase,
          UserProvider,
          SignupViewModel
        >(
          create: (context) => SignupViewModel(
            context.read<RegisterUseCase>(),
            context.read<UserProvider>(),
          ),
          update: (_, useCase, userProvider, __) =>
              SignupViewModel(useCase, userProvider),
        ),
        ChangeNotifierProxyProvider<ProductRepositoryImpl, ProductProvider>(
          create: (context) =>
              ProductProvider(context.read<ProductRepositoryImpl>()),
          update: (_, repo, previous) => ProductProvider(repo),
        ),
        ChangeNotifierProxyProvider2<
          ProductRepositoryImpl,
          AdminRepositoryImpl,
          AdminProvider
        >(
          create: (context) => AdminProvider(
            context.read<ProductRepositoryImpl>(),
            context.read<AdminRepositoryImpl>(),
          ),
          update: (_, productRepo, adminRepo, previous) =>
              AdminProvider(productRepo, adminRepo),
        ),
        ChangeNotifierProxyProvider2<
          ChatRepositoryImpl,
          UserProvider,
          ChatProvider
        >(
          create: (context) {
            final provider = ChatProvider(context.read<ChatRepositoryImpl>());
            provider.initSocket(context.read<UserProvider>().user);
            return provider;
          },
          update: (_, repo, userProvider, previous) {
            previous ??= ChatProvider(repo);
            if (previous.user != userProvider.user)
              previous.initSocket(userProvider.user);
            return previous;
          },
        ),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: "Mero Baazar",
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        initialRoute: initialUser != null ? '/bottomnav' : '/',
        routes: {
          '/': (context) => const RoleSelectionScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/bottomnav': (context) => const DashboardView(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/my-listings': (context) => const MyListingsScreen(),
          '/product-details': (context) => const ProductDetailsScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
          '/chat-list': (context) => const ChatListScreen(),
          '/chat-details': (context) => const ChatScreen(),
        },
      ),
    );
  }
}
