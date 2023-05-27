import 'medicine_info_model.dart';

class MedicineInformation {
  String? name;
  String? description;
  String? type;
  String? unit;
  double? nTake;
  String? order;
  List<bool>? periodTime;
  String? picturePath;
  int? color;
  int? id;

  MedicineInfo asMedicineInfo() {
    return MedicineInfo(
      name: name!,
      description: description!,
      type: type!,
      unit: unit!,
      nTake: nTake!,
      order: order!,
      period_time: periodTime!,
      picture_path: picturePath,
      color: color!,
      id: id!,
    );
  }

  MedicineInformation({
    this.name,
    this.description,
    this.type,
    this.unit,
    this.nTake,
    this.order,
    this.periodTime,
    this.picturePath,
    this.color,
    this.id,
  });
}
