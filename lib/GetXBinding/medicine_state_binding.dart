import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

class MedicineInfoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicineEditorState>(() => MedicineEditorState());
  }
}
