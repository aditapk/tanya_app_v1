import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/browser.dart';
import 'dart:io';

//import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// class NotificationApi {
//   //static final _notificationPlugin = FlutterLocalNotificationsPlugin();

//   static initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('mipmap/ic_launcher');
//   }

//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         channelDescription: 'Channel description',
//         importance: Importance.max,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   static Future showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     _notification.show(id, title, body, await _notificationDetails(),
//         payload: payload);
//   }
// }

// class NotificationService {
//   static final NotificationService _notificationService =
//       NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   NotificationService._internal();
// }

class NotifyHelper {
  // create flutter location notification
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(
      const Text("Welcome to flutter"),
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // TODO: Handle this case.
        // When click on notification
        print(notificationResponse.payload);

        break;
      case NotificationResponseType.selectedNotificationAction:
        // TODO: Handle this case.
        // When action on notification is clicked
        print(notificationResponse.actionId);
        print(notificationResponse.input);
        break;
    }
  }

  Future<void> inintializeNotification() async {
    tz.initializeTimeZones();
    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: iOSInitializationSettings,
            android: androidInitializationSettings);

    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? andriodImplementation =
          localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await andriodImplementation?.requestPermission();
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("My Channel ID", "My Channel Name",
            channelDescription: "My Channel Description",
            importance: Importance.max,
            priority: Priority.high,
            ticker: "ticker");
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await localNotificationsPlugin.show(
        0, 'plan title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  Future<void> showNotificationWithAction() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "My Channel ID",
      "My Channel Name",
      channelDescription: "My Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'ID:Complate',
          'Complete',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'ID:Cancel',
          'Cancel',
          showsUserInterface: true,
        )
      ],
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    //await localNotificationsPlugin.show(
    //    1, 'plan title', 'plain body', notificationDetails,
    //    payload: 'item z');
    TZDateTime schedule1 = TZDateTime.now(tz.local).add(Duration(seconds: 5));
    TZDateTime schedule2 = schedule1.add(Duration(seconds: 5));
    await localNotificationsPlugin.zonedSchedule(
      1,
      'title1',
      'body1',
      schedule1,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    await localNotificationsPlugin.zonedSchedule(
      2,
      'title1',
      'body1',
      schedule2,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showNotificationWithTextAction() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "My Channel ID",
      "My Channel Name",
      channelDescription: "My Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'Text_ID',
          'Enter Text',
          showsUserInterface: true,
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              label: 'Enter a message',
            )
          ],
        ),
      ],
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await localNotificationsPlugin.show(3, 'Text Input Notification',
        'Expand to see input action', notificationDetails,
        payload: 'text input');
  }

  Future<void> showNotificationWithTextChoice() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "My Channel ID",
      "My Channel Name",
      channelDescription: "My Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'Text_Choice',
          'Choose Item',
          showsUserInterface: true,
          inputs: <AndroidNotificationActionInput>[
            AndroidNotificationActionInput(
              choices: <String>['Item1', 'Item2'],
              allowFreeFormInput: false,
            )
          ],
        ),
      ],
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await localNotificationsPlugin.show(3, 'Text Choise of Notification',
        'There are 2 chioces', notificationDetails,
        payload: 'text input');
  }

  Future<void> showNotificationSchedule() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "My Channel ID",
      "My Channel Name",
      channelDescription: "My Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    var scheduledDate = tz.TZDateTime.now(tz.local).add(
      const Duration(seconds: 5),
    );

    await localNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showTimeoutNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('silent channel id', 'silent channel name',
            channelDescription: 'silent channel description',
            timeoutAfter: 3000,
            styleInformation: DefaultStyleInformation(true, true));
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await localNotificationsPlugin.show(0, 'timeout notification',
        'Times out after 3 seconds', notificationDetails);
  }

  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String filePath = '${directory.path}/$fileName';
  //   final http.Response response = await http.get(Uri.parse(url));
  //   final File file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  // Future<void> showBigPictureNotification() async {
  //   final String largeIconPath =
  //       await _downloadAndSaveFile('https://dummyimage.com/48x48', 'largeIcon');
  //   final String bigPicturePath = await _downloadAndSaveFile(
  //       'https://dummyimage.com/400x800', 'bigPicture');
  //   final BigPictureStyleInformation bigPictureStyleInformation =
  //       BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
  //           largeIcon: FilePathAndroidBitmap(largeIconPath),
  //           contentTitle: 'overridden <b>big</b> content title',
  //           htmlFormatContentTitle: true,
  //           summaryText: 'summary <i>text</i>',
  //           htmlFormatSummaryText: true);
  // final AndroidNotificationDetails androidNotificationDetails =
  //     AndroidNotificationDetails(
  //   'big text channel id',
  //   'big text channel name',
  //   channelDescription: 'big text channel description',
  //   styleInformation: bigPictureStyleInformation,
  //   importance: Importance.max,
  //   priority: Priority.high,
  //   ticker: 'ticker',
  // );
  //   final AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails("My Channel ID", "My Channel Name",
  //           channelDescription: "My Channel Description",
  //           styleInformation: bigPictureStyleInformation,
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           ticker: "ticker");
  //   final NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await localNotificationsPlugin.show(
  //       1, 'big text title', 'silent body', notificationDetails);
  // }

  // Future<String> _base64encodedImage(String url) async {
  //   final http.Response response = await http.get(Uri.parse(url));
  //   final String base64Data = base64Encode(response.bodyBytes);
  //   return base64Data;
  // }

  // Future<void> showBigPictureNotificationBase64() async {
  //   final String largeIcon =
  //       await _base64encodedImage('https://dummyimage.com/48x48');
  //   final String bigPicture =
  //       await _base64encodedImage('https://dummyimage.com/400x800');

  //   final BigPictureStyleInformation bigPictureStyleInformation =
  //       BigPictureStyleInformation(
  //           ByteArrayAndroidBitmap.fromBase64String(
  //               bigPicture), //Base64AndroidBitmap(bigPicture),
  //           largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
  //           contentTitle: 'overridden <b>big</b> content title',
  //           htmlFormatContentTitle: true,
  //           summaryText: 'summary <i>text</i>',
  //           htmlFormatSummaryText: true);
  //   final AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails("My Channel ID", "My Channel Name",
  //           channelDescription: "My Channel Description",
  //           styleInformation: bigPictureStyleInformation,
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           ticker: "ticker");
  //   final NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await localNotificationsPlugin.show(
  //       0, 'big text title', 'silent body', notificationDetails);
  // }

  // Future<void> showBigTextNotification() async {
  //   const BigTextStyleInformation bigTextStyleInformation =
  //       BigTextStyleInformation(
  //     'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //     htmlFormatBigText: true,
  //     contentTitle: 'overridden <b>big</b> content title',
  //     htmlFormatContentTitle: true,
  //     summaryText: 'summary <i>text</i>',
  //     htmlFormatSummaryText: true,
  //   );
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //           'big text channel id', 'big text channel name',
  //           channelDescription: 'big text channel description',
  //           styleInformation: bigTextStyleInformation);
  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await localNotificationsPlugin.show(
  //       10, 'big text title', 'silent body', notificationDetails);
  // }
}
