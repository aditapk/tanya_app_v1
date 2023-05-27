import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/utils/constans.dart';

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
          Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO).listenable(),
      builder: (_, box, __) {
        if (box.values.isNotEmpty) {
          var medicineboxInfo = box.values;
          var medicineInfoList = medicineboxInfo.toList();
          //var medicineInfoMap = medicineInfoList.asMap();

          return ListView.builder(
            itemCount: medicineInfoList.length,
            itemBuilder: (context, index) => MedicineInfoCard(
              index: index,
              medicineData: medicineInfoList[index],
            ),
          );
        } else {
          return const EmptyMedicineList(
            emptyDescription: "เพิ่มรายการยา กรุณากดปุ่ม + ",
          );
        }
      },
    );
  }
}
