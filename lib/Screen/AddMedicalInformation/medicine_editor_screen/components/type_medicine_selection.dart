import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

import 'medicine_type_card.dart';

class TypeMedicineSeletion extends StatelessWidget {
  TypeMedicineSeletion({super.key});

  final medicineInfoState = Get.find<MedicineEditorState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/pills_type.png",
            selection: medicineInfoState.selected_type.value == "pills",
            onTap: () {
              medicineInfoState.selected_type("pills");
              medicineInfoState.selected_type_unit("เม็ด");
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/water_type.png",
            selection: medicineInfoState.selected_type.value == "water",
            onTap: () {
              medicineInfoState.selected_type("water");
              medicineInfoState.selected_type_unit("ช้อนชา");
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/injection.png",
            selection: medicineInfoState.selected_type.value == "arrow",
            onTap: () {
              medicineInfoState.selected_type("arrow");
              medicineInfoState.selected_type_unit("ยูนิต");
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/drops.png",
            selection: medicineInfoState.selected_type.value == "drop",
            onTap: () {
              medicineInfoState.selected_type("drop");
              medicineInfoState.selected_type_unit("หยด");
            },
          ),
        ),
      ],
    );
  }
}
