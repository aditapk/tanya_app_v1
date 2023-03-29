// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 2;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo(
      name: fields[0] as String?,
      address: fields[1] as String?,
      doctorName: fields[2] as String?,
      appointmentWithDoctor: (fields[3] as List?)?.cast<DateTime>(),
      picturePath: fields[4] as String?,
      weight: fields[5] as double?,
      hight: fields[7] as double?,
      pressure: fields[6] as String?,
      lastUpdate: fields[8] as DateTime?,
      lineToken: fields[9] as String?,
      fPG: fields[10] as double?,
      hbA1c: fields[11] as double?,
      creatinine: fields[25] as double?,
      gFR: fields[12] as double?,
      totalCholesterol: fields[13] as double?,
      triglyceride: fields[14] as double?,
      hDLc: fields[15] as double?,
      lDLc: fields[16] as double?,
      aST: fields[17] as double?,
      aLT: fields[18] as double?,
      aLP: fields[20] as double?,
      t3: fields[21] as double?,
      freeT3: fields[22] as double?,
      freeT4: fields[23] as double?,
      tSH: fields[24] as double?,
      otherCheckup: fields[26] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.doctorName)
      ..writeByte(3)
      ..write(obj.appointmentWithDoctor)
      ..writeByte(4)
      ..write(obj.picturePath)
      ..writeByte(8)
      ..write(obj.lastUpdate)
      ..writeByte(9)
      ..write(obj.lineToken)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.pressure)
      ..writeByte(7)
      ..write(obj.hight)
      ..writeByte(10)
      ..write(obj.fPG)
      ..writeByte(11)
      ..write(obj.hbA1c)
      ..writeByte(12)
      ..write(obj.gFR)
      ..writeByte(25)
      ..write(obj.creatinine)
      ..writeByte(13)
      ..write(obj.totalCholesterol)
      ..writeByte(14)
      ..write(obj.triglyceride)
      ..writeByte(15)
      ..write(obj.hDLc)
      ..writeByte(16)
      ..write(obj.lDLc)
      ..writeByte(17)
      ..write(obj.aST)
      ..writeByte(18)
      ..write(obj.aLT)
      ..writeByte(20)
      ..write(obj.aLP)
      ..writeByte(21)
      ..write(obj.t3)
      ..writeByte(22)
      ..write(obj.freeT3)
      ..writeByte(23)
      ..write(obj.freeT4)
      ..writeByte(24)
      ..write(obj.tSH)
      ..writeByte(26)
      ..write(obj.otherCheckup);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
