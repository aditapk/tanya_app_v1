// import 'package:flutter/material.dart';
// import 'package:tanya_app_v1/api/notification_api.dart';

// class TestLocalNotify extends StatefulWidget {
//   const TestLocalNotify({super.key});

//   @override
//   State<TestLocalNotify> createState() => _TestLocalNotifyState();
// }

// class _TestLocalNotifyState extends State<TestLocalNotify> {
//   var notifyHelper;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     notifyHelper = NotifyHelper();
//     notifyHelper.inintializeNotification();
//     notifyHelper.requestPermission();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Local Notification',
//         ),
//       ),
//       body: Container(
//         child: Center(
//           child: ElevatedButton(
//             child: Text("Notification alert"),
//             onPressed: () {
//               //notifyHelper.showNotification();
//               //notifyHelper.showNotificationWithAction();
//               //notifyHelper.showNotificationWithTextAction();
//               //notifyHelper.showNotificationWithTextChoice();
//               //notifyHelper.showNotificationSchedule();
//               //notifyHelper.showTimeoutNotification();
//               //notifyHelper.showBigPictureNotification();
//               //notifyHelper.showBigPictureNotificationBase64();
//               notifyHelper.showBigTextNotification();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
