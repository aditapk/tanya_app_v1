// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:fraction/fraction.dart';

class MedicineInfoDisplayCard extends StatelessWidget {
  MedicineInfoDisplayCard({this.medicineData, super.key});
  MedicineInfo? medicineData;

  _displayPrefixType(String type) {
    if (type == "pills" || type == "water") {
      return "รับประทาน";
    } else if (type == "arrow") {
      return "ใช้ฉีด";
    } else if (type == "drop") {
      return "ใช้หยด";
    }
  }

  _displayEatOrder(String order) {
    if (order == "before") {
      return "ก่อนอาหาร";
    } else if (order == "after") {
      return "หลังอาหาร";
    }
  }

  _displayPeriodTime(List<bool> period_time) {
    List<String> display = [];
    if (period_time[0]) {
      display.add("เช้า");
    }
    if (period_time[1]) {
      display.add("กลางวัน");
    }
    if (period_time[2]) {
      display.add("เย็น");
    }
    if (period_time[3]) {
      display.add("ก่อนนอน");
    }
    if (display.isNotEmpty) {
      return display.join(", ");
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineData!.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(medicineData!.description),
          Row(
            children: [
              Text(
                  "${_displayPrefixType(medicineData!.type)}   ${medicineData!.nTake.toFraction()}"),
              const SizedBox(
                width: 10,
              ),
              Text(medicineData!.unit)
            ],
          ),
          Text(_displayEatOrder(medicineData!.order)),
          Text(_displayPeriodTime(medicineData!.period_time)),
        ],
      ),
    );
  }
}
