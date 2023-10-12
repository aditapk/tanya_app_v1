// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLoginAdapter extends TypeAdapter<UserLogin> {
  @override
  final int typeId = 4;

  @override
  UserLogin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLogin(
      username: fields[0] as String,
      password: fields[1] as String,
      lastTimeLogin: fields[2] as String,
      logOut: fields[3] as bool?,
      beginningUse: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLogin obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.lastTimeLogin)
      ..writeByte(3)
      ..write(obj.logOut)
      ..writeByte(4)
      ..write(obj.beginningUse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoginAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
