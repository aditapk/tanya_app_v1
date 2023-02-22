import 'package:get/get.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/medicine_list_screen.dart';
import 'package:tanya_app_v1/Screen/Welcome/welcome_screen.dart';

class AppPageRoute {
  static var appPageRoute = [
    GetPage(
      name: '/',
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: '/editMedicineInfo',
      page: () => MedicineInfoEditorScreen(),
      binding: MedicineInfoBinding(),
    ),
    GetPage(
      name: '/detailMedicineInfo',
      page: () => const MedicineListScreen(),
    )
  ];
}
