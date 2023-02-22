import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/Notify/notify_screen_old.dart';

import 'components/display_medicine_info_list.dart';

class MedicineListScreen extends StatelessWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Get.off(NotifyScreen())
        //   },
        //   icon: Icon(Icons.home),
        // ),
        title: const Text("รายการยา"),
        centerTitle: true,
      ),
      body: const DisplayMedicineInfoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMedicineInfo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createMedicineInfo() {
    Get.to(
      () => MedicineInfoEditorScreen(),
      binding: MedicineInfoBinding(),
    );
  }
}
