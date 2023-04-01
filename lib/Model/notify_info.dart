import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';

part 'notify_info.g.dart';

@HiveType(typeId: 1)
class NotifyInfoModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  MedicineInfo medicineInfo;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  TimeOfDayModel time;

  @HiveField(5)
  int status; // 0 : complete, other : not complete

  //@HiveField(6)
  //NotifyModel notify;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "medicineInfo": {
        "name": medicineInfo.name,
        "description": medicineInfo.description,
        "type": medicineInfo.type,
        "unit": medicineInfo.unit,
        "nTake": medicineInfo.nTake,
        "order": medicineInfo.order,
        "period_time": [medicineInfo.period_time],
        "picture_path": medicineInfo.picture_path
      },
      "date": {
        "year": date.year,
        "month": date.month,
        "day": date.day,
      },
      "time": {
        "hour": time.hour,
        "minute": time.minute,
      },
      "status": status,
    };
  }

  NotifyInfoModel({
    this.name = '',
    this.description = '',
    required this.medicineInfo,
    required this.date,
    required this.time,
    this.status = 1,
  });
}

// @HiveType(typeId: 2)
// class NotifyModel {
//   @HiveField(0)
//   int id;

//   @HiveField(1)
//   String payload;
//   NotifyModel({required this.id, required this.payload});
// }

@HiveType(typeId: 3)
class TimeOfDayModel {
  @HiveField(0)
  int hour;

  @HiveField(1)
  int minute;

  TimeOfDayModel({required this.hour, required this.minute});
}
