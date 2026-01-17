import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/data/models/user_model.dart';
import 'app.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  final userBox = await Hive.openBox<UserModel>('users');

  runApp(MyApp(userBox: userBox));
}
