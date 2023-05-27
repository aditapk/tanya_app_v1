import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

import 'medicine_type_card.dart';

class TypeMedicineSeletion extends StatelessWidget {
  TypeMedicineSeletion({super.key});

  final medicineInfoState = Get.find<MedicineEditorState>();

  final Map<String, String> defaultUnitTypeOfMedicine = {
    "pills": "เม็ด",
    "water": "ช้อนชา",
    "arrow": "ยูนิต",
    "drop": "หยด"
  };
  chooseBeforeBedTimeOnly() {
    return (medicineInfoState.bed_time.value == true &&
        (medicineInfoState.moning_time.value == false &&
            medicineInfoState.lunch_time.value == false &&
            medicineInfoState.evening_time.value == false));
  }

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
              medicineInfoState
                  .selected_type_unit(defaultUnitTypeOfMedicine["pills"]);

              if (!chooseBeforeBedTimeOnly()) {
                if (medicineInfoState.order.isEmpty) {
                  medicineInfoState.order("before");
                }
              } else {
                if (medicineInfoState.order.value.isNotEmpty) {
                  medicineInfoState.order.value = "";
                } else {
                  // do nothing
                }
              }
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/water_type.png",
            selection: medicineInfoState.selected_type.value == "water",
            onTap: () {
              medicineInfoState.selected_type("water");
              medicineInfoState
                  .selected_type_unit(defaultUnitTypeOfMedicine["water"]);
              if (!chooseBeforeBedTimeOnly()) {
                if (medicineInfoState.order.isEmpty) {
                  medicineInfoState.order("before");
                }
              } else {
                if (medicineInfoState.order.value.isNotEmpty) {
                  medicineInfoState.order.value = "";
                } else {
                  // do nothing
                }
              }
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/injection.png",
            selection: medicineInfoState.selected_type.value == "arrow",
            onTap: () {
              medicineInfoState.selected_type("arrow");
              medicineInfoState
                  .selected_type_unit(defaultUnitTypeOfMedicine["arrow"]);
              if (!chooseBeforeBedTimeOnly()) {
                if (medicineInfoState.order.isEmpty) {
                  medicineInfoState.order("before");
                }
              } else {
                if (medicineInfoState.order.value.isNotEmpty) {
                  medicineInfoState.order.value = "";
                } else {
                  // do nothing
                }
              }
            },
          ),
        ),
        Obx(
          () => MedicineTypeCard(
            image: "assets/images/medicine_type/drops.png",
            selection: medicineInfoState.selected_type.value == "drop",
            onTap: () {
              medicineInfoState.selected_type("drop");
              medicineInfoState
                  .selected_type_unit(defaultUnitTypeOfMedicine["drop"]);
              medicineInfoState.order("");
            },
          ),
        ),
      ],
    );
  }
}
