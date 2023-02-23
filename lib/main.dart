// import Library file

//import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/medicine_list_screen.dart';
import 'package:tanya_app_v1/Services/hive_db_services.dart';
import 'package:tanya_app_v1/components/app_pages_route.dart';
import 'dart:developer';

import 'GetXBinding/medicine_state_binding.dart';
import 'Screen/Login/login_screen.dart';
import 'Screen/Notify/notify_screen_old.dart';
import 'Screen/Welcome/welcome_screen.dart';
import 'Screen/splash/splash_screen.dart';
import 'forTest/local_notify/notify.dart';
import 'forTest/local_notify/notify_list_screen.dart';

// ---

// Global variable

//var boxTasks;
//var medicineInfo;

// Local Notification Setting Up
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// ---

Future<void> main() async {
  // Initialization
  WidgetsFlutterBinding.ensureInitialized(); // Widget Binding before runApp

  // _configureLocalTimeZone();

  //log("main()");
  await initializeDateFormatting('th'); // initialize local date time format
  //log("-> initial Date Formatting");
  HiveDatabaseService.initialization();

  //await Hive.initFlutter(); // initial Hive database
  //log("-> initial Hive Database");
  // register task adapter
  //Hive.registerAdapter<Task>(TaskAdapter());
  //Hive.registerAdapter<TestMedicineInfo>(TestMedicineInfoAdapter());
  //Hive.registerAdapter<MedicineInfo>(MedicineInfoAdapter());
  //Hive.registerAdapter<NotifyInfoModel>(NotifyInfoModelAdapter());
  //log("-> register Adapter for Task");
  //HiveDatabaseService.init();
  ///HiveDatabaseService.registerAdapter();
  // clean database for test
  //await Hive.deleteBoxFromDisk('tasks');
  //await Hive.deleteBoxFromDisk('medicine_info');
  //await Hive.deleteBoxFromDisk('user_medicine_info');
  //log("->[Test] Clean database before run");

  // open box
  //await Hive.openBox<Task>('tasks');
  //await Hive.openBox<TestMedicineInfo>('medicine_info');
  //await Hive.openBox<MedicineInfo>('user_medicine_info');
  //log("-> open task database");

  // camera initial
  //final cameras = await availableCameras();
  //log("-> get available cameras");

  //final firstCamera = cameras.first;
  // ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: MedicineInfoBinding(),
        initialRoute: "/",
        getPages: AppPageRoute.appPageRoute,
        debugShowCheckedModeBanner: false,
        title: 'Medical Reminder',
        theme: ThemeData(
          primaryColor: Colors.blue,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.light,
        // for test
        //home:
        //TestImagePickerApp(),
        //const MedicineListScreen(),
        //MedicineListScreen(),

        home: LoginScreen()
        //WelcomeScreen(),
        //SplashScreen(),
        //ShowNotifyListScreen(), // Home App
        //TestLocalNotify(),
        // AnimatedSplashScreen(
        //   duration: 3000,
        //   splashIconSize: 500,
        //   splash: const SplashScreen(),
        //   nextScreen: const WelcomeScreen(),
        //   splashTransition: SplashTransition.slideTransition,
        //   //pageTransitionType: PageTransitionType.bottomToTop,
        // ),
        );
  }
}
