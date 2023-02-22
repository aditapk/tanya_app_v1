// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

class MedicineEditorState extends GetxController {
  final name = "".obs;
  final description = "".obs;
  final selected_type = "pills".obs;
  final selected_type_unit = "เม็ด".obs;
  final nTake = 1.0.obs;
  final order = "before".obs;
  final moning_time = true.obs;
  final lunch_time = false.obs;
  final evening_time = false.obs;
  final bed_time = false.obs;
  final picture_path = "".obs;
}
