import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import 'features/auth/data/models/user_model.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

  // 2. Initialize Dio + persistent cookies right after Hive
  //    This ensures cookies are loaded before any network call
  await ApiService.initialize();

  final user = await AuthService.tryAutoLogin();

  runApp(MyApp(initialUser: user));
}
