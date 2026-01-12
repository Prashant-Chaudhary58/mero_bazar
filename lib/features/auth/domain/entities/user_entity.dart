class UserEntity {
  final String id;
  final String phone;
  final String fullName;
  final String role; // 'seller' or 'buyer'
  final String? image;
  final String? email;
  final String? dob;
  final String? province;
  final String? district;
  final String? city;
  final String? address;
  final String? altPhone;

  const UserEntity({
    this.id = '123',
    required this.phone,
    required this.fullName,
    required this.role,
    this.image,
    this.email,
    this.dob,
    this.province,
    this.district,
    this.city,
    this.address,
    this.altPhone,
  });

  UserEntity copyWith({
    String? fullName,
    String? image,
    String? email,
    String? dob,
    String? province,
    String? district,
    String? city,
    String? address,
    String? altPhone,
  }) {
    return UserEntity(
      id: id,
      phone: phone,
      fullName: fullName ?? this.fullName,
      role: role,
      image: image ?? this.image,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      province: province ?? this.province,
      district: district ?? this.district,
      city: city ?? this.city,
      address: address ?? this.address,
      altPhone: altPhone ?? this.altPhone,
    );
  }
}
