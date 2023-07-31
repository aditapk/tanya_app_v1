// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';

class MedicineInfoDisplayCard extends StatelessWidget {
  const MedicineInfoDisplayCard({
    this.medicineData,
    super.key,
  });

  final MedicineInfo? medicineData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 40),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white70,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 2,
          left: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicineData!.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              medicineData!.description,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "${_displayPrefixType(medicineData!.type)} ครั้งละ ${_displayNTake(medicineData!.nTake)} ${medicineData!.unit}",
              style: const TextStyle(fontSize: 16),
            ),
            medicineData!.order != ""
                ? Text(
                    _displayEatOrder(medicineData!.order),
                    style: const TextStyle(fontSize: 16),
                  )
                : Container(),
            Text(
              _displayPeriodTime(medicineData!.period_time),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  _displayNTake(double nTake) {
    if (nTake % 1 == 0) {
      return nTake.toInt();
    } else {
      return nTake;
    }
  }

  String _displayPrefixType(String type) {
    if (type == "pills" || type == "water") {
      return "กิน";
    } else if (type == "arrow") {
      return "ฉีด";
    } else if (type == "drop") {
      return "หยอด/พ่น";
    } else {
      return "";
    }
  }

  String _displayEatOrder(String order) {
    if (order == "before") {
      return "ก่อนอาหาร";
    } else if (order == "after") {
      return "หลังอาหาร";
    } else {
      return "";
    }
  }

  String _displayPeriodTime(List<bool> period_time) {
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
}
