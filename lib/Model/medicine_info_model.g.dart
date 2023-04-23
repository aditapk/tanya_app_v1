// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineInfoAdapter extends TypeAdapter<MedicineInfo> {
  @override
  final int typeId = 0;

  @override
  MedicineInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineInfo(
      name: fields[0] as String,
      description: fields[1] as String,
      type: fields[2] as String,
      unit: fields[3] as String,
      nTake: fields[4] as double,
      order: fields[5] as String,
      period_time: (fields[6] as List).cast<bool>(),
      picture_path: fields[7] as String?,
      color: fields[8] as int,
      id: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineInfo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.nTake)
      ..writeByte(5)
      ..write(obj.order)
      ..writeByte(6)
      ..write(obj.period_time)
      ..writeByte(7)
      ..write(obj.picture_path)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
