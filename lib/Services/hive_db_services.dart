//import 'package:hive/hive.dart';
//import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/Model/doctor_appointment.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../Model/user_info_model.dart';

class HiveDatabaseService {
  static initialization() async {
    await init(); // initial hive on flutter
    registerAdapter(); // register all adapter
    //await deleteBox(); // delete box for test
    await openAllBox(); // open all box
  }

  static Future<void> init() async {
    // Initial Database
    await Hive.initFlutter();
  }

  static void registerAdapter() {
    // register MedicineInfo Adapter
    Hive.registerAdapter<MedicineInfo>(MedicineInfoAdapter());
    // register NotifyInfo Adapter
    Hive.registerAdapter<NotifyInfoModel>(NotifyInfoModelAdapter());
    // register TimeOfDayModel Adapter
    Hive.registerAdapter<TimeOfDayModel>(TimeOfDayModelAdapter());
    // register UserLogin Adapter
    Hive.registerAdapter<UserLogin>(UserLoginAdapter());
    // register UserInfo Adapter
    Hive.registerAdapter<UserInfo>(UserInfoAdapter());
    // register DoctorAppointment Adapter
    Hive.registerAdapter<DoctorAppointMent>(DoctorAppointMentAdapter());
  }

  static Future<void> openAllBox() async {
    // open user_medicine_info box
    await Hive.openBox<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO);
    // open user_notify_info box
    await Hive.openBox<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    // open user_login box
    await Hive.openBox<UserLogin>(HiveDatabaseName.USER_LOGIN);
    // open user_info box
    await Hive.openBox<UserInfo>(HiveDatabaseName.USER_INFO);
    // open doctor_appointment box
    await Hive.openBox<DoctorAppointMent>(
        HiveDatabaseName.DOCTOR_APPOINMENT_INFO);
  }

  // for test
  static Future<void> deleteBox() async {
    await Hive.deleteBoxFromDisk(HiveDatabaseName.NOTIFY_INFO);
    await Hive.deleteBoxFromDisk(HiveDatabaseName.DOCTOR_APPOINMENT_INFO);
    await Hive.deleteBoxFromDisk(HiveDatabaseName.USER_INFO);
    await Hive.deleteBoxFromDisk(HiveDatabaseName.MEDICINE_INFO);
    await Hive.deleteBoxFromDisk(HiveDatabaseName.USER_LOGIN);
  }

  // static Future<void> clearBox() async {
  //   await clearUserMedicineInfo();
  //   await clearDotorAppointment();
  // }

  // static Future<void> clearUserMedicineInfo() async {
  //   var userMedicineInfoBox =
  //       await Hive.openBox<MedicineInfo>('user_medicine_info');
  //   await userMedicineInfoBox.clear();
  // }

  // static Future<void> clearDotorAppointment() async {
  //   var doctorAppointMentBox =
  //       await Hive.openBox<DoctorAppointMent>('doctor_appointment');
  //   await doctorAppointMentBox.clear();
  // }

  // static Future<void> clearUserInfo() async {
  //   var userInfoBox = await Hive.openBox<UserInfo>('user_info');
  // }
}
