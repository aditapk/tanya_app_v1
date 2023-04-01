// import Library file

//import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:intl/date_symbol_data_local.dart';

import 'package:tanya_app_v1/Services/hive_db_services.dart';
import 'package:tanya_app_v1/components/app_pages_route.dart';

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

  // _configureLocalTimeZone();

  //log("main()");
  await initializeDateFormatting('th'); // initialize local date time format
  //log("-> initial Date Formatting");
  await HiveDatabaseService.initialization();

  // ---

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
    // ignore: todo
    // TODO: implement initState
    // localization
    //     .init(mapLocales: [MapLocale('th', {})], initLanguageCode: 'en');

    super.initState();
  }

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
