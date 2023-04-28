import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

import 'time_schedule_selection_card.dart';

class TakeMedicineAndTimeSelection extends StatelessWidget {
  TakeMedicineAndTimeSelection({super.key});

  final double _height = 50;

  //final medicineInfoState = Get.put(MedicineEditorState());
  final medicineInfoState = Get.find<MedicineEditorState>();

  get bedTimeFlag =>
      medicineInfoState.bed_time.value &&
      (!medicineInfoState.moning_time.value &&
          !medicineInfoState.lunch_time.value &&
          !medicineInfoState.evening_time.value);

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
                selection: !bedTimeFlag
                    ? medicineInfoState.order.value == "before"
                    : false,
                borderColor: Colors.blue,
                backgroundColor: Colors.blue.shade100,
                onTap: () =>
                    !bedTimeFlag ? medicineInfoState.order("before") : null,
              ),
            ),
            Obx(
              () => TimeScheduleSelectionCard(
                title: "เช้า",
                height: _height,
                selection: medicineInfoState.moning_time.value,
                borderColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                onTap: () {
                  medicineInfoState
                      .moning_time(!medicineInfoState.moning_time.value);
                  if (bedTimeFlag) {
                    medicineInfoState.order("");
                  } else {
                    medicineInfoState.order("before");
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
                  if (bedTimeFlag) {
                    medicineInfoState.order("");
                  } else {
                    medicineInfoState.order("before");
                  }
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => TimeScheduleSelectionCard(
                title: "หลังอาหาร",
                height: _height,
                selection: !bedTimeFlag
                    ? medicineInfoState.order.value == "after"
                    : false,
                borderColor: Colors.blue,
                backgroundColor: Colors.blue.shade100,
                onTap: () =>
                    !bedTimeFlag ? medicineInfoState.order("after") : null,
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
                  if (bedTimeFlag) {
                    medicineInfoState.order("");
                  } else {
                    medicineInfoState.order("before");
                  }
                },
              ),
            ),
            Obx(
              () => TimeScheduleSelectionCard(
                  title: "ก่อนนอน",
                  height: _height,
                  selection: medicineInfoState.bed_time.value,
                  borderColor: Colors.green,
                  backgroundColor: Colors.green.shade100,
                  onTap: () {
                    medicineInfoState
                        .bed_time(!medicineInfoState.bed_time.value);
                    if (bedTimeFlag) {
                      medicineInfoState.order("");
                    } else {
                      medicineInfoState.order("before");
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
