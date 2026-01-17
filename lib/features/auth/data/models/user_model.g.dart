// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      phone: fields[1] as String,
      fullName: fields[2] as String,
      role: fields[3] as String,
      password: fields[0] as String?,
      id: fields[4] as String?,
      image: fields[5] as String?,
      email: fields[6] as String?,
      dob: fields[7] as String?,
      province: fields[8] as String?,
      district: fields[9] as String?,
      city: fields[10] as String?,
      address: fields[11] as String?,
      altPhone: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.password)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.dob)
      ..writeByte(8)
      ..write(obj.province)
      ..writeByte(9)
      ..write(obj.district)
      ..writeByte(10)
      ..write(obj.city)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.altPhone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
