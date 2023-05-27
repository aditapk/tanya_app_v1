import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

import 'time_schedule_selection_card.dart';

class TakeMedicineAndTimeSelection extends StatelessWidget {
  TakeMedicineAndTimeSelection({super.key});

  final double _height = 50;

  final medicineInfoState = Get.find<MedicineEditorState>();

  chooseBeforeBedTimeOnly() {
    return (medicineInfoState.bed_time.value == true &&
        (medicineInfoState.moning_time.value == false &&
            medicineInfoState.lunch_time.value == false &&
            medicineInfoState.evening_time.value == false));
  }

  selectedDropMedicineType() {
    return medicineInfoState.selected_type.value == "drop";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => TimeScheduleSelectionCard(
                  title: "ก่อนอาหาร",
                  height: _height,
                  selection: medicineInfoState.order.value == "before",
                  borderColor: Colors.blue,
                  backgroundColor: Colors.blue.shade200,
                  onTap: () {
                    // on change before widget

                    if (chooseBeforeBedTimeOnly() ||
                        selectedDropMedicineType()) {
                      // do nothing
                    } else {
                      medicineInfoState.order("before");
                    }
                  }),
            ),
            Obx(
              () => TimeScheduleSelectionCard(
                  title: "หลังอาหาร",
                  height: _height,
                  selection: medicineInfoState.order.value == "after",
                  borderColor: Colors.blue,
                  backgroundColor: Colors.blue.shade200,
                  onTap: () {
                    if (chooseBeforeBedTimeOnly() ||
                        selectedDropMedicineType()) {
                      // do nothing
                    } else {
                      medicineInfoState.order("after");
                    }
                  }),
            ),
          ],
        ),
        Row(
          children: [
            Obx(
              () => TimeScheduleSelectionCard(
                title: "เช้า",
                height: _height,
                selection: medicineInfoState.moning_time.value,
                borderColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                onTap: () {
                  // set morning state
                  medicineInfoState
                      .moning_time(!medicineInfoState.moning_time.value);

                  if (chooseBeforeBedTimeOnly()) {
                    medicineInfoState.order("");
                  } else {
                    if (!selectedDropMedicineType()) {
                      if (medicineInfoState.order.isEmpty) {
                        medicineInfoState.order("before");
                      }
                    }
                  }
                },
              ),
            ),
            Obx(
              () => TimeScheduleSelectionCard(
                title: "กลางวัน",
                height: _height,
                selection: medicineInfoState.lunch_time.value,
                borderColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                onTap: () {
                  medicineInfoState
                      .lunch_time(!medicineInfoState.lunch_time.value);
                  if (chooseBeforeBedTimeOnly()) {
                    medicineInfoState.order("");
                  } else {
                    if (!selectedDropMedicineType()) {
                      if (medicineInfoState.order.isEmpty) {
                        medicineInfoState.order("before");
                      }
                    }
                  }
                },
              ),
            ),
            Obx(
              () => TimeScheduleSelectionCard(
                title: "เย็น",
                height: _height,
                selection: medicineInfoState.evening_time.value,
                borderColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                onTap: () {
                  medicineInfoState
                      .evening_time(!medicineInfoState.evening_time.value);
                  if (chooseBeforeBedTimeOnly()) {
                    medicineInfoState.order("");
                  } else {
                    if (!selectedDropMedicineType()) {
                      if (medicineInfoState.order.isEmpty) {
                        medicineInfoState.order("before");
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Obx(
              () => TimeScheduleSelectionCard(
                  title: "ก่อนนอน",
                  height: _height,
                  selection: medicineInfoState.bed_time.value,
                  borderColor: Colors.green,
                  backgroundColor: Colors.green.shade100,
                  onTap: () {
                    // set before bed state
                    medicineInfoState
                        .bed_time(!medicineInfoState.bed_time.value);

                    if (chooseBeforeBedTimeOnly()) {
                      medicineInfoState.order("");
                    } else {
                      if (!selectedDropMedicineType()) {
                        if (medicineInfoState.order.isEmpty) {
                          medicineInfoState.order("before");
                        }
                      }
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
