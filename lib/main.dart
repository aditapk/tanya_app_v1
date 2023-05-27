// import Library file

//import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:intl/date_symbol_data_local.dart';

import 'package:tanya_app_v1/Services/hive_db_services.dart';

import 'GetXBinding/medicine_state_binding.dart';
import 'Screen/Login/login_screen_selection.dart';
// ---

// Global variable

//var boxTasks;
//var medicineInfo;

// Local Notification Setting Up
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// ---

Future<void> main() async {
  Intl.defaultLocale = 'th';
  // Initialization
  WidgetsFlutterBinding.ensureInitialized(); // Widget Binding before runApp

  // init background service
  // await BackgroundService.intialization();

  // initialize local date time format
  await initializeDateFormatting('th');

  // Hive Database initialization
  await HiveDatabaseService.initialization();

  // notification initialization
  // await NotifyService().inintializeNotification(
  //     onDidReceiveNotificationIOS: null,
  //     onDidReceiveNotificationAndroid:
  //         NotificationHandeling.medicineOnDidReceiveNotificationAndroid);

  // start app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final FlutterLocalization localization = FlutterLocalization.instance;

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
      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      //   brightness: Brightness.light,
      // ),
      // darkTheme: ThemeData(
      //   primaryColor: Colors.blue,
      //   brightness: Brightness.dark,
      // ),
      // themeMode: ThemeMode.light,
      // localizationsDelegates: localization.localizationsDelegates,
      // supportedLocales: localization.supportedLocales,
      // locale: const Locale('th'),
      // for test
      //home:
      //TestImagePickerApp(),
      //const MedicineListScreen(),
      //MedicineListScreen(),

      home: const LoginScreenSelection(),
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
