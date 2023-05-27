class NotifyReport {
  String notifyName;
  String medicineName;
  String? picturePath;
  int nNotify;
  int nComplete;
  int color;
  String type;
  NotifyReport({
    required this.medicineName,
    required this.nNotify,
    required this.nComplete,
    this.picturePath,
    required this.notifyName,
    required this.color,
    required this.type,
  });
}
