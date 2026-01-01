import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(phone: json['phone']);
  }
}
