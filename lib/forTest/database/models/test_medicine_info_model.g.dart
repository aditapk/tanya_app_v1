// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_medicine_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestMedicineInfoAdapter extends TypeAdapter<TestMedicineInfo> {
  @override
  final int typeId = 0;

  @override
  TestMedicineInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestMedicineInfo(
      name: fields[0] as String?,
      description: fields[1] as String?,
      type: fields[2] as String?,
      nTake: fields[3] as int?,
      order: fields[4] as String?,
      period_time: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TestMedicineInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.nTake)
      ..writeByte(4)
      ..write(obj.order)
      ..writeByte(5)
      ..write(obj.period_time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestMedicineInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
