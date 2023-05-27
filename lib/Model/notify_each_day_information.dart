class NofifyEachDayInformation {
  String? name;
  String? detail;
  String medicineInformation;
  String date;
  String time;
  String status;
  int numberOfNotify;
  NofifyEachDayInformation({
    this.name,
    this.detail,
    required this.medicineInformation,
    required this.date,
    required this.time,
    required this.status,
    required this.numberOfNotify,
  });
}
