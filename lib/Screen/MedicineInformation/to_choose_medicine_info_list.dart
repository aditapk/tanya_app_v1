import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/home_app_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../Model/medicine_info_model.dart';
import '../AddMedicalInformation/medicine_list_screen/components/empty_medicine_list.dart';
import '../AddMedicalInformation/medicine_list_screen/components/image_card.dart';
import '../AddMedicalInformation/medicine_list_screen/components/medicine_info_display_card.dart';

class ToChooseMedicine extends StatefulWidget {
  const ToChooseMedicine({super.key});

  @override
  State<ToChooseMedicine> createState() => _ToChooseMedicineState();
}

class _ToChooseMedicineState extends State<ToChooseMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เลือกรายการยา"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO).listenable(),
        builder: (_, box, __) {
          if (box.values.isNotEmpty) {
            var medicineboxInfo = box.values;
            var medicineboxInfoList = medicineboxInfo.toList();
            return ListView.builder(
              itemCount: medicineboxInfoList.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // get selected medicine infomation

                  // back and send medicine infomation
                  Get.back(result: medicineboxInfoList[index]);
                },
                child: MedicineCardSelect(
                  index: index,
                  medicineData: medicineboxInfoList[index],
                ),
              ),
            );
          } else {
            return Column(
              children: [
                const EmptyMedicineList(
                  emptyDescription: "กรุณาไปที่หน้าเพิ่มรายการยา",
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Get.off(() => const HomeAppScreen());
                    },
                    child: const Text(
                      "เพิ่มรายการยา",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class MedicineCardSelect extends StatelessWidget {
  const MedicineCardSelect({
    super.key,
    this.medicineData,
    required this.index,
  });

  final MedicineInfo? medicineData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Stack(
        children: [
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Color(medicineData!.color),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: GestureDetector(
                      child: ImageCard(
                        image: medicineData?.picture_path,
                      ),
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: MedicineInfoDisplayCard(
                      medicineData: medicineData,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
