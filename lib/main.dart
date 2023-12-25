// import Library file

//import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:intl/date_symbol_data_local.dart';

import 'package:tanya_app_v1/Services/hive_db_services.dart';

import 'Controller/medicine_info_controller.dart';
import 'GetXBinding/medicine_state_binding.dart';
import 'Screen/Login/login_screen_selection.dart';
import 'Services/notification_handling.dart';
import 'Services/notify_services.dart';
// ---

// ---

Future<void> main() async {
  //debugPrint('main: Initialization');

  // Widget Binding before runApp
  WidgetsFlutterBinding.ensureInitialized();
  //debugPrint('\tWidgetsFlutterBinding');

  Intl.defaultLocale = 'th';

  // init background service
  //await BackgroundService.intialization();

  // initialize local date time format
  await initializeDateFormatting('th');
  //debugPrint('\tDateFormat Initial');

  // Hive Database initialization
  await HiveDatabaseService.initialization();
  //debugPrint('\tDatabase Initial');

  //notification initialization in case application is log off
  await NotifyService().inintializeNotification(
    onDidReceiveNotification: NotificationHandeling.onDidReceiveNotification,
  );

  // init share preferences
  //await SharePreferencesData.init();

  // put page state
  Get.put(PageState());
  // run My App
  //debugPrint('main: Running');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppInfoBinding(),
      debugShowCheckedModeBanner: false,
      title: 'Medical Reminder',
      home: const LoginScreenSelection(),
      //const IntroScreen(),
    );
  }
}
