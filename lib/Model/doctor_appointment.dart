import 'package:hive/hive.dart';

part 'doctor_appointment.g.dart';

@HiveType(typeId: 5)
class DoctorAppointMent extends HiveObject {
  @HiveField(0)
  DateTime appointmentTime;

  @HiveField(1)
  int notifyID;

  DoctorAppointMent({required this.appointmentTime, required this.notifyID});
}
