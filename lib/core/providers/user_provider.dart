import 'package:flutter/material.dart';
import '../../features/auth/domain/entities/user_entity.dart';

class UserProvider extends ChangeNotifier {
  UserEntity? _user;

  UserEntity? get user => _user;

  bool get isLoggedIn => _user != null;
  
  bool get isSeller => _user?.role == 'seller';

  void setUser(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(UserEntity updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
