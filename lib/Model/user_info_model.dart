import 'package:hive/hive.dart';

part 'user_info_model.g.dart';

@HiveType(typeId: 2)
class UserInfo extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? address;

  @HiveField(2)
  String? doctorName;

  @HiveField(3)
  List<DateTime>? appointmentWithDoctor;

  @HiveField(4)
  String? picturePath;

  @HiveField(5)
  double? weight;

  @HiveField(6)
  String? pressure;

  @HiveField(7)
  double? hight;

  @HiveField(8)
  DateTime? lastUpdate;

  @HiveField(9)
  String? lineToken;

  UserInfo({
    this.name,
    this.address,
    this.doctorName,
    this.appointmentWithDoctor,
    this.picturePath,
    this.weight,
    this.hight,
    this.pressure,
    this.lastUpdate,
    this.lineToken,
  });
}
