import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? note;

  @HiveField(2)
  DateTime? created_date;

  @HiveField(3)
  bool? done;

  Task({this.title, this.note, this.created_date, this.done});
}
