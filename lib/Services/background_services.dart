// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

// class BackgroundService {
//   static Future<void> intialization() async {
//     final service = FlutterBackgroundService();

//     await service.configure(
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIOSBackground,
//       ),
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: true,
//         foregroundServiceNotificationId: 999999,
//         initialNotificationTitle: 'background service application',
//         initialNotificationContent: 'Initializing',
//       ),
//     );

//     await service.startService();
//   }

//   @pragma('vm:entry-point')
//   static onStart(ServiceInstance service) {
//     DartPluginRegistrant.ensureInitialized();

//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });
//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }

//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//   }

//   @pragma('vm:entry-point')
//   static FutureOr<bool> onIOSBackground(ServiceInstance service) {
//     WidgetsFlutterBinding.ensureInitialized();
//     DartPluginRegistrant.ensureInitialized();
//     return true;
//   }
// }
