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

  @HiveField(8)
  DateTime? lastUpdate;

  @HiveField(9)
  String? lineToken;

  // healpcare information
  @HiveField(5)
  double? weight;

  @HiveField(6)
  String? pressure;

  @HiveField(7)
  double? hight;

  @HiveField(10)
  double? fPG;

  @HiveField(11)
  double? hbA1c;

  @HiveField(12)
  double? gFR;

  @HiveField(25)
  double? creatinine;

  @HiveField(13)
  double? totalCholesterol;

  @HiveField(14)
  double? triglyceride;

  @HiveField(15)
  double? hDLc;

  @HiveField(16)
  double? lDLc;

  @HiveField(17)
  double? aST;

  @HiveField(18)
  double? aLT;

  @HiveField(20)
  double? aLP;

  @HiveField(21)
  double? t3;

  @HiveField(22)
  double? freeT3;

  @HiveField(23)
  double? freeT4;

  @HiveField(24)
  double? tSH;

  @HiveField(26)
  String? otherCheckup;

  UserInfo(
      {this.name,
      this.address,
      this.doctorName,
      this.appointmentWithDoctor,
      this.picturePath,
      this.weight,
      this.hight,
      this.pressure,
      this.lastUpdate,
      this.lineToken,
      this.fPG,
      this.hbA1c,
      this.creatinine,
      this.gFR,
      this.totalCholesterol,
      this.triglyceride,
      this.hDLc,
      this.lDLc,
      this.aST,
      this.aLT,
      this.aLP,
      this.t3,
      this.freeT3,
      this.freeT4,
      this.tSH,
      this.otherCheckup});
}
