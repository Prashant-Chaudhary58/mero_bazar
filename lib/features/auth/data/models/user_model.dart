import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @HiveField(0)
  final String? password;

  @HiveField(1)
  @override
  final String phone;

  @HiveField(2)
  @override
  final String fullName;

  @HiveField(3)
  @override
  final String role;

  @HiveField(4)
  @override
  final String? id;

  @HiveField(5)
  @override
  final String? image;

  @HiveField(6)
  @override
  final String? email;

  @HiveField(7)
  @override
  final String? dob;

  @HiveField(8)
  @override
  final String? province;

  @HiveField(9)
  @override
  final String? district;

  @HiveField(10)
  @override
  final String? city;

  @HiveField(11)
  @override
  final String? address;

  @HiveField(12)
  @override
  final String? altPhone;

  @HiveField(13)
  @override
  final double? lat;

  @HiveField(14)
  @override
  final double? lng;

  UserModel({
    required this.phone,
    required this.fullName,
    required this.role,
    this.password,
    this.id,
    this.image,
    this.email,
    this.dob,
    this.province,
    this.district,
    this.city,
    this.address,
    this.altPhone,
    this.lat,
    this.lng,
  }) : super(
         phone: phone,
         fullName: fullName,
         role: role,
         id: id,
         image: image,
         email: email,
         dob: dob,
         province: province,
         district: district,
         city: city,
         address: address,
         altPhone: altPhone,
         lat: lat,
         lng: lng,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'],
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'buyer',
      id: json['id'] ?? json['_id'],
      image: json['image'],
      email: json['email'],
      dob: json['dob'],
      province: json['province'],
      district: json['district'],
      city: json['city'],
      address: json['address'],
      altPhone: json['altPhone'],
      lat: json['location'] != null
          ? (json['location']['coordinates'][1] as num?)?.toDouble()
          : null,
      lng: json['location'] != null
          ? (json['location']['coordinates'][0] as num?)?.toDouble()
          : null,
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
      'lat': lat,
      'lng': lng,
    };
  }
}
