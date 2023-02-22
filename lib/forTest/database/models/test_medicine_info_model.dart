import 'package:hive/hive.dart';

part 'test_medicine_info_model.g.dart';

@HiveType(typeId: 0)
class TestMedicineInfo extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String? type;

  @HiveField(3)
  int? nTake;

  @HiveField(4)
  String? order;

  @HiveField(5)
  List<String>? period_time;

  TestMedicineInfo(
      {this.name,
      this.description,
      this.type,
      this.nTake,
      this.order,
      this.period_time});
}
