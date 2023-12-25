// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
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
  final color = Colors.blue.shade200.obs;
}

class ReportFilterState extends GetxController {
  final filterStartDate = DateTime.now().obs;
  final filterEndDate = DateTime.now().add(const Duration(days: 7)).obs;
}

class PageState extends GetxController {
  int pageIndex = 0;
  var pageController = PageController(initialPage: 0);

  void changePageto(int newPage) {
    pageIndex = newPage;
    pageController.animateToPage(
      newPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    update();
  }

  void changePageIndexTo(int newPageIndex) {
    pageIndex = newPageIndex;
    update();
  }
}
