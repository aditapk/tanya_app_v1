//import 'package:hive/hive.dart';
//import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/Model/doctor_appointment.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';

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
    await Hive.openBox<MedicineInfo>('user_medicine_info');
    // open user_notify_info box
    await Hive.openBox<NotifyInfoModel>('user_notify_info');
    // open user_login box
    await Hive.openBox<UserLogin>('user_login');
    // open user_info box
    await Hive.openBox<UserInfo>('user_info');
    // open doctor_appointment box
    await Hive.openBox<DoctorAppointMent>('doctor_appointment');
  }

  static Future<void> deleteBox() async {
    await Hive.deleteBoxFromDisk('user_notify_info');
    await Hive.deleteBoxFromDisk('doctor_appointment');
    await Hive.deleteBoxFromDisk('user_info');
    await Hive.deleteBoxFromDisk('user_notify_info');
    await Hive.deleteBoxFromDisk('user_medicine_info');
  }
}
