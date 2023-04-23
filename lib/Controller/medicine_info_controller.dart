// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Services/notify_services.dart';

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
  final color = Colors.blue.shade200.obs;
  final notifyServices = NotifyService().obs;
  final appointmentService = NotifyService().obs;
  final filterStartDate = DateTime.now().obs;
  final filterEndDate = DateTime.now().add(const Duration(days: 7)).obs;
}
