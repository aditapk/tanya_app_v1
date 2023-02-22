class TestMedicineModel {
  String name;

  String detail;

  int dose; //ขนาดรับประทาน

  String type; //ชนิดยากินยาฉีด

  String period_time;

  String? picture;

  TestMedicineModel(
      {required this.name,
      required this.detail,
      required this.dose,
      required this.type,
      required this.period_time,
      this.picture});
}
