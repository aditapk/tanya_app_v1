import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';

import 'empty_medicine_list.dart';
import 'medicine_info_card.dart';

class DisplayMedicineInfoList extends StatelessWidget {
  const DisplayMedicineInfoList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<MedicineInfo>('user_medicine_info').listenable(),
      builder: (_, box, __) {
        if (box.values.isNotEmpty) {
          var medicineboxInfo = box.values;
          return ListView(
            children: medicineboxInfo.map((medicineData) {
              return MedicineInfoCard(
                medicineData: medicineData,
              );
            }).toList(),
          );
        } else {
          return EmptyMedicineList(
            emptyDescription: "กรุณาเพิ่มรายการยา โดยกดที่ปุ่ม +",
          );
        }
      },
    );
  }
}
