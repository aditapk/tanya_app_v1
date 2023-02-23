// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notify_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotifyInfoModelAdapter extends TypeAdapter<NotifyInfoModel> {
  @override
  final int typeId = 1;

  @override
  NotifyInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotifyInfoModel(
      name: fields[0] as String,
      description: fields[1] as String,
      medicineInfo: fields[2] as MedicineInfo,
      date: fields[3] as DateTime,
      time: fields[4] as TimeOfDayModel,
      status: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotifyInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.medicineInfo)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifyInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeOfDayModelAdapter extends TypeAdapter<TimeOfDayModel> {
  @override
  final int typeId = 3;

  @override
  TimeOfDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeOfDayModel(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeOfDayModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeOfDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
