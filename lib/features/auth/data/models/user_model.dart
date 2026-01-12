import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.phone,
    required super.fullName,
    required super.role,
    super.id,
    super.image,
    super.email,
    super.dob,
    super.province,
    super.district,
    super.city,
    super.address,
    super.altPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'],
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'buyer',
      id: json['id'],
      image: json['image'],
      email: json['email'],
      dob: json['dob'],
      province: json['province'],
      district: json['district'],
      city: json['city'],
      address: json['address'],
      altPhone: json['altPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'fullName': fullName,
      'role': role,
      'image': image,
      'email': email,
      'dob': dob,
      'province': province,
      'district': district,
      'city': city,
      'address': address,
      'altPhone': altPhone,
    };
  }
}
