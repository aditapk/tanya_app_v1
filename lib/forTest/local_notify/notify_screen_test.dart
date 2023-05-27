// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import '../../Services/notify_services.dart';

// class NotifyTestScreen extends StatefulWidget {
//   const NotifyTestScreen({super.key});

//   @override
//   State<NotifyTestScreen> createState() => _NotifyTestScreenState();
// }

// class _NotifyTestScreenState extends State<NotifyTestScreen> {
//   final FlutterLocalNotificationsPlugin localNotificationPlugin =
//       FlutterLocalNotificationsPlugin();
//   Future<void> localNotificationInit({
//     required DidReceiveLocalNotificationCallback iosOnDidRecieveNotification,
//     required DidReceiveNotificationResponseCallback
//         onDidReceiveNotificationResponse,
//   }) async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings iOSInitializationSetting =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: iosOnDidRecieveNotification,
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iOSInitializationSetting,
//     );
//     try {
//       await localNotificationPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       );
//     } catch (e) {
//       print('some error on initialize localNotification');
//     }
//   }

//   Future<void> requestPermission() async {
//     final AndroidFlutterLocalNotificationsPlugin?
//         androidFlutterLocalNotificationsPlugin =
//         localNotificationPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await androidFlutterLocalNotificationsPlugin?.requestPermission();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     // local notification setting

//     // final FlutterLocalNotificationsPlugin localNotificationPlugin =
//     //     FlutterLocalNotificationsPlugin();
//     super.initState();
//   }

//   // handle local notify function
//   void onDidRecieveNotificaitonFHandle(
//       int id, String? title, String? body, String? payload) {
//     print("id = $id, title = $title, body = $body, payload = $payload");
//   }

//   void onDidRecieveNotificationResponseFHandle(NotificationResponse details) {
//     print("detail = $details");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Local Notify')),
//       body: Column(children: [
//         ElevatedButton(
//             onPressed: () async {
//               var notifyService = NotifyService();
//               print(notifyService);
//             },
//             child: const Text('initial')),
//         ElevatedButton(
//             onPressed: () async {
//               await requestPermission();
//             },
//             child: const Text('request permission'))
//       ]),
//     );
//   }
// }
