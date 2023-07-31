import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import 'empty_medicine_list.dart';
import 'medicine_info_card.dart';

class DisplayMedicineInfoList extends StatelessWidget {
  const DisplayMedicineInfoList({
    Key? key,
    required this.changeImageShowCaseKey,
    required this.toMedicineNotifyShowCaseKey,
    required this.editMedicineShowCaseKey,
    required this.deleteMedicineShowCaseKey,
  }) : super(key: key);
  final GlobalKey changeImageShowCaseKey;
  final GlobalKey toMedicineNotifyShowCaseKey;
  final GlobalKey editMedicineShowCaseKey;
  final GlobalKey deleteMedicineShowCaseKey;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO).listenable(),
      builder: (_, box, __) {
        if (box.values.isNotEmpty) {
          var medicineboxInfo = box.values;
          var medicineInfoList = medicineboxInfo.toList();

          return ListView.builder(
              itemCount: medicineInfoList.length,
              itemBuilder: (context, index) => MedicineInfoCard(
                    index: index,
                    medicineData: medicineInfoList[index],
                    imageShowCaseKey: changeImageShowCaseKey,
                    toMedicineNotifyShowCaseKey: toMedicineNotifyShowCaseKey,
                    editMedicineShowCaseKey: editMedicineShowCaseKey,
                    deleteMedecineShowCaseKey: deleteMedicineShowCaseKey,
                  ));
        } else {
          return const EmptyMedicineList(
            emptyDescription: "เพิ่มรายการยา กรุณากดปุ่ม + ",
          );
        }
      },
    );
  }
}
