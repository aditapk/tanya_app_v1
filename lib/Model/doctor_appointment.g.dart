// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorAppointMentAdapter extends TypeAdapter<DoctorAppointMent> {
  @override
  final int typeId = 5;

  @override
  DoctorAppointMent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorAppointMent(
      appointmentTime: fields[0] as DateTime,
      notifyID: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorAppointMent obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.appointmentTime)
      ..writeByte(1)
      ..write(obj.notifyID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAppointMentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
