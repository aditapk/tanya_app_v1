import 'package:get/get.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/medicine_list_screen.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen_selection.dart';
import 'package:tanya_app_v1/Screen/Signup/signup_screen.dart';
import 'package:tanya_app_v1/Screen/user/login_screen_org.dart';
import 'package:tanya_app_v1/home_app_screen.dart';

class AppPageRoute {
  static var appPageRoute = [
    GetPage(
      name: '/',
      page: () => const LoginScreenSelection(),
    ),
    GetPage(
      name: '/signUp',
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeAppScreen(),
      binding: AppInfoBinding(),
    ),
    GetPage(
      name: '/editMedicineInfo',
      page: () => const MedicineInfoEditorScreen(),
      binding: AppInfoBinding(),
    ),
    GetPage(
      name: '/detailMedicineInfo',
      page: () => const MedicineListScreen(),
    )
  ];
}
