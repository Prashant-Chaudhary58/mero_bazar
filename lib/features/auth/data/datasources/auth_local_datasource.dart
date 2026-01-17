import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel> loginUser(String phone, String password);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> _userBox;

  AuthLocalDataSourceImpl(this._userBox);

  @override
  Future<void> registerUser(UserModel user) async {
    // using key as phone number to ensure uniqueness or easy lookup
    // If phone already exists, it will overwrite (update) or we can check first.
    if (_userBox.containsKey(user.phone)) {
      throw Exception('User with this phone already exists');
    }
    await _userBox.put(user.phone, user);
  }

  @override
  Future<UserModel> loginUser(String phone, String password) async {
    final user = _userBox.get(phone);
    if (user != null) {
      if (user.password == password) {
        return user;
      } else {
        throw Exception('Invalid Credentials');
      }
    } else {
      throw Exception('User not found');
    }
  }
}
