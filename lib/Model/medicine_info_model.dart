import 'package:hive/hive.dart';

part 'medicine_info_model.g.dart';

@HiveType(typeId: 0)
class MedicineInfo extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String type;

  @HiveField(3)
  String unit;

  @HiveField(4)
  double nTake;

  @HiveField(5)
  String order;

  @HiveField(6)
  // ignore: non_constant_identifier_names
  List<bool> period_time;

  @HiveField(7)
  // ignore: non_constant_identifier_names
  String? picture_path;

  MedicineInfo(
      {required this.name,
      required this.description,
      required this.type,
      required this.unit,
      required this.nTake,
      required this.order,
      // ignore: non_constant_identifier_names
      required this.period_time,
      // ignore: non_constant_identifier_names
      this.picture_path});
}
